//--------------------------------------------------------------------------------------------------
// 02_uart_rx.v
// UART 接收器
//
// 帧格式: 1 起始位 + 8 数据位 + 1 停止位 (8N1)
// 采样策略: 每个位中间采样 1 次 (波特率 tick 居中)
//--------------------------------------------------------------------------------------------------

module uart_rx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire            clk,
    input  wire            rst_n,
    input  wire            rx_in,        // 串行输入
    output reg  [7:0]      rx_data,      // 接收到的数据
    output reg             rx_done,      // 接收完成脉冲 (1 个时钟周期)
    output wire            rx_busy       // 接收中标志
);

    localparam BAUD_DIV  = CLK_FREQ / BAUD_RATE;
    localparam HALF_BAUD = BAUD_DIV / 2;

    reg [$clog2(BAUD_DIV)-1:0] baud_cnt;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;

    // 起始位检测: 检测 rx_in 的下降沿 (空闲→起始)
    reg rx_in_d;
    wire start_detect;
    assign start_detect = ~rx_in & rx_in_d;  // 下降沿

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rx_in_d <= 1'b1;     // 空闲为高
        else
            rx_in_d <= rx_in;
    end

    // 接收状态
    reg rx_active;
    assign rx_busy = rx_active;

    // 波特率计数
    wire mid_bit_tick;
    assign mid_bit_tick = (baud_cnt == HALF_BAUD - 1);

    // 主接收逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_active  <= 1'b0;
            baud_cnt   <= 0;
            bit_cnt    <= 4'd0;
            shift_reg  <= 8'd0;
            rx_data    <= 8'd0;
            rx_done    <= 1'b0;
        end else begin
            rx_done <= 1'b0;  // 默认清除

            if (!rx_active) begin
                // 等待起始位
                if (start_detect) begin
                    rx_active <= 1'b1;
                    baud_cnt  <= 0;
                    bit_cnt   <= 4'd0;
                end
            end else begin
                // 接收中
                if (mid_bit_tick) begin
                    baud_cnt <= 0;

                    if (bit_cnt == 0) begin
                        // 中点采样起始位 (验证是否真为低)
                        if (rx_in == 1'b0) begin
                            bit_cnt <= bit_cnt + 1'b1;
                        end else begin
                            rx_active <= 1'b0;  // 假起始位, 放弃
                        end
                    end else if (bit_cnt >= 4'd1 && bit_cnt <= 4'd8) begin
                        // 采样数据位
                        shift_reg <= {rx_in, shift_reg[7:1]};
                        bit_cnt   <= bit_cnt + 1'b1;
                    end else if (bit_cnt == 4'd9) begin
                        // 采样停止位
                        rx_data   <= shift_reg;     // 已经收到完整 8 位
                        rx_done   <= 1'b1;
                        rx_active <= 1'b0;
                    end
                end else begin
                    baud_cnt <= baud_cnt + 1'b1;
                end
            end
        end
    end

endmodule
