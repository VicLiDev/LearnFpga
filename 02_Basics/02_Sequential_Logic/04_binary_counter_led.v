//--------------------------------------------------------------------------------------------------
// 04_binary_counter_led.v
// LED 二进制计数器 — 实用 Demo
//
// 功能: 4 个 LED 以二进制显示 0~15 的计数
//       每 0.5 秒计数 +1
//
// 时钟: 假设 50MHz
// 慢时钟: 需要分频得到约 1Hz 的使能信号
//--------------------------------------------------------------------------------------------------

module binary_counter_led (
    input  wire       clk,      // 50MHz 系统时钟
    input  wire       rst_n,    // 复位
    output reg  [3:0] led       // 4 个 LED (二进制 0~15)
);

    // 参数: 50MHz, 0.5 秒 = 25,000,000 周期
    parameter SLOW_CLK_MAX = 25_000_000;

    reg [24:0] slow_cnt;         // 慢时钟计数器
    wire       slow_tick;       // 慢时钟 "滴答" (每 0.5 秒一次)

    assign slow_tick = (slow_cnt == SLOW_CLK_MAX - 1);

    // 慢时钟计数器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            slow_cnt <= 25'd0;
        end else if (slow_tick) begin
            slow_cnt <= 25'd0;
        end else begin
            slow_cnt <= slow_cnt + 1'b1;
        end
    end

    // 4 位 LED 计数器 (每收到一个 slow_tick 就 +1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led <= 4'd0;
        end else if (slow_tick) begin
            led <= led + 1'b1;  // 计满 15 后自动归 0 (4 位溢出)
        end
    end

endmodule
