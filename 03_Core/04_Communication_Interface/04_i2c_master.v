//--------------------------------------------------------------------------------------------------
// 04_i2c_master.v
// I2C 主机控制器 (简化版)
//
// 支持操作:
//   - 写操作: START → ADDR+W → ACK → DATA → ACK → STOP
//   - 读操作: START → ADDR+R → ACK → DATA → NAK → STOP
//
// 时钟: 100KHz 标准模式
//--------------------------------------------------------------------------------------------------

module i2c_master #(
    parameter CLK_FREQ  = 50_000_000,
    parameter I2C_FREQ   = 100_000         // I2C 时钟频率
)(
    input  wire            clk,
    input  wire            rst_n,
    // I2C 接口 (开漏, 需要 pull-up)
    inout  wire            sda,            // 数据线 (双向)
    output reg             scl,            // 时钟线
    // 用户接口
    input  wire [6:0]      dev_addr,       // 7 位设备地址
    input  wire            rw,             // 0=写, 1=读
    input  wire [7:0]      wr_data,        // 写数据
    output reg  [7:0]      rd_data,        // 读数据
    input  wire            i2c_start,      // 启动传输
    output reg             i2c_done,       // 传输完成
    output wire            i2c_busy        // 忙标志
);

    // SCL 分频
    localparam SCL_DIV = CLK_FREQ / (2 * I2C_FREQ);
    reg [$clog2(SCL_DIV)-1:0] scl_cnt;
    wire scl_tick;
    assign scl_tick = (scl_cnt == SCL_DIV - 1);

    // SCL 生成
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            scl_cnt <= 0;
        else if (i2c_busy && scl_tick)
            scl_cnt <= 0;
        else if (i2c_busy)
            scl_cnt <= scl_cnt + 1'b1;
    end

    // SDA 输出控制 (开漏)
    reg sda_out_en;
    reg sda_out;
    // SDA 双向: 输出时驱动, 输入时高阻
    assign sda = sda_out_en ? sda_out : 1'bz;

    wire sda_in;   // SDA 输入采样
    assign sda_in = sda;

    // 状态机
    localparam IDLE       = 4'd0;
    localparam START      = 4'd1;
    localparam SEND_ADDR  = 4'd2;
    localparam ACK_ADDR   = 4'd3;
    localparam WR_DATA    = 4'd4;
    localparam ACK_WR     = 4'd5;
    localparam RD_DATA    = 4'd6;
    localparam ACK_RD     = 4'd7;
    localparam STOP       = 4'd8;

    reg [3:0]   state;
    reg [2:0]   bit_idx;       // 0~7, 当前 bit
    reg [7:0]   shift_reg;

    assign i2c_busy = (state != IDLE);

    // SCL 边沿
    reg scl_d;
    always @(posedge clk) scl_d <= scl;
    wire scl_rise = scl & ~scl_d;
    wire scl_fall = ~scl & scl_d;

    // 主状态机
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            scl        <= 1'b1;
            sda_out_en <= 1'b0;
            sda_out    <= 1'b1;
            i2c_done   <= 1'b0;
            bit_idx    <= 3'd0;
            shift_reg  <= 8'd0;
        end else begin
            i2c_done <= 1'b0;

            // SCL 翻转
            if (state != IDLE && scl_tick)
                scl <= ~scl;

            case (state)
                IDLE: begin
                    scl <= 1'b1;
                    sda_out_en <= 1'b0;
                    if (i2c_start) begin
                        state      <= START;
                        shift_reg  <= {dev_addr, rw, 1'b0};  // 8位: addr(7) + rw(1)
                        bit_idx    <= 3'd0;
                    end
                end

                START: begin
                    // START: SCL=1 时, SDA 从高变低
                    sda_out_en <= 1'b1;
                    sda_out    <= 1'b1;
                    if (scl_tick && scl == 1'b1) begin
                        sda_out    <= 1'b0;  // SDA 拉低 (SCL 仍为高)
                        state      <= SEND_ADDR;
                    end
                end

                SEND_ADDR: begin
                    // 发送 8 位地址 (MSB first)
                    if (scl_fall) begin
                        // SCL 下降沿: 更新 SDA
                        sda_out_en <= 1'b1;
                        sda_out    <= shift_reg[7];
                        shift_reg  <= {shift_reg[6:0], 1'b0};
                        bit_idx    <= bit_idx + 1'b1;
                    end else if (bit_idx == 3'd8 && scl_rise) begin
                        // 发完 8 位, 等待 ACK
                        sda_out_en <= 1'b0;   // 释放 SDA, 等待从机拉低
                        state      <= ACK_ADDR;
                    end
                end

                ACK_ADDR: begin
                    if (scl_fall) begin
                        if (sda_in == 1'b0) begin
                            // ACK 收到
                            state <= rw ? RD_DATA : WR_DATA;
                            bit_idx <= 3'd0;
                            if (!rw) shift_reg <= wr_data;  // 准备写数据
                        end else begin
                            // NAK: 从机无应答, 停止
                            state <= STOP;
                        end
                    end
                end

                WR_DATA: begin
                    if (scl_fall) begin
                        sda_out_en <= 1'b1;
                        sda_out    <= shift_reg[7];
                        shift_reg  <= {shift_reg[6:0], 1'b0};
                        bit_idx    <= bit_idx + 1'b1;
                    end else if (bit_idx == 3'd8 && scl_rise) begin
                        sda_out_en <= 1'b0;
                        state      <= ACK_WR;
                    end
                end

                ACK_WR: begin
                    if (scl_fall) begin
                        // 写完 1 字节, 发 STOP
                        state <= STOP;
                    end
                end

                RD_DATA: begin
                    if (scl_rise) begin
                        // SCL 上升沿: 采样 SDA
                        shift_reg <= {shift_reg[6:0], sda_in};
                        bit_idx   <= bit_idx + 1'b1;
                    end else if (bit_idx == 3'd8 && scl_fall) begin
                        rd_data <= shift_reg;
                        // 发 NAK (主机读完, 通知从机)
                        sda_out_en <= 1'b1;
                        sda_out    <= 1'b1;   // NAK
                        state      <= STOP;
                    end
                end

                STOP: begin
                    // STOP: SCL=1 时, SDA 从低变高
                    sda_out_en <= 1'b1;
                    sda_out    <= 1'b0;
                    if (scl_tick && scl == 1'b1) begin
                        sda_out    <= 1'b1;   // SDA 拉高 (SCL 仍为高)
                        state      <= IDLE;
                        i2c_done   <= 1'b1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
