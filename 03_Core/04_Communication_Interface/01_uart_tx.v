//--------------------------------------------------------------------------------------------------
// 01_uart_tx.v
// UART 发送器
//
// 参数: 波特率 (通过时钟分频实现)
// 帧格式: 1 起始位 + 8 数据位 + 1 停止位 = 10 bits (8N1)
//
// 时序:
//   空闲(TX=1) → 起始位(0) → b0 → b1 → ... → b7 → 停止位(1) → 空闲
//
// 波特率分频: clk_freq / baud_rate
//   50MHz / 115200 = 434
//--------------------------------------------------------------------------------------------------

module uart_tx #(
    parameter CLK_FREQ  = 50_000_000,    // 系统时钟频率
    parameter BAUD_RATE = 115200         // 波特率
)(
    input  wire            clk,
    input  wire            rst_n,
    input  wire [7:0]      tx_data,      // 待发送数据
    input  wire            tx_start,     // 发送使能 (脉冲, 高 1 个时钟周期)
    output reg             tx_out,        // 串行输出
    output reg             tx_busy       // 忙标志 (发送中为高)
);

    // 波特率分频计数器
    localparam BAUD_DIV = CLK_FREQ / BAUD_RATE;
    localparam HALF_BAUD = BAUD_DIV / 2;

    reg [$clog2(BAUD_DIV)-1:0] baud_cnt;
    wire baud_tick;                      // 每个波特周期产生一个 tick
    reg [3:0] bit_cnt;                   // 当前发送到第几个 bit (0~9)
    reg [9:0] shift_reg;                 // 移位寄存器: [停止位|数据8位|起始位]

    // 波特率 tick: 计数到 BAUD_DIV 的一半 (居中采样)
    assign baud_tick = (baud_cnt == HALF_BAUD - 1);

    // 状态定义
    localparam IDLE  = 1'b0;
    localparam SENDING = 1'b1;
    reg state;

    // 波特率计数器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            baud_cnt <= 0;
        else if (state == SENDING) begin
            if (baud_tick)
                baud_cnt <= 0;
            else
                baud_cnt <= baud_cnt + 1'b1;
        end else begin
            baud_cnt <= 0;
        end
    end

    // 主状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx_out    <= 1'b1;          // 空闲为高
            tx_busy   <= 1'b0;
            bit_cnt   <= 4'd0;
            shift_reg <= 10'd0;
        end else begin
            case (state)
                IDLE: begin
                    tx_out  <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        shift_reg <= {1'b1, tx_data, 1'b0};  // [停止|数据|起始]
                        bit_cnt   <= 4'd0;
                        state     <= SENDING;
                        tx_busy   <= 1'b1;
                    end
                end

                SENDING: begin
                    if (baud_tick) begin
                        tx_out    <= shift_reg[0];    // LSB first
                        shift_reg <= shift_reg >> 1;
                        bit_cnt   <= bit_cnt + 1'b1;

                        if (bit_cnt == 4'd9) begin      // 发完 10 位 (1起始+8数据+1停止)
                            state   <= IDLE;
                            tx_busy <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end

endmodule
