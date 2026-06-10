//--------------------------------------------------------------------------------------------------
// 03_pll_ip_example.v
// PLL (Clocking Wizard) IP 核调用示例
//
// 功能: 将 50MHz 输入时钟转换为 100MHz 和 25MHz 两路输出时钟
//
// 配置参考 (Vivado Clocking Wizard):
//   - Input Clock: 50 MHz
//   - Output Clock 1: 100 MHz (用于逻辑)
//   - Output Clock 2: 25 MHz  (用于外设)
//   - Reset Type: Active Low
//--------------------------------------------------------------------------------------------------

module pll_ip_example (
    input  wire        clk_in,      // 50MHz 输入时钟
    input  wire        reset_n,     // 复位
    output wire        locked,      // PLL 锁定标志 (高=稳定)
    output wire        clk_100m,    // 100MHz 输出
    output wire        clk_25m      // 25MHz 输出
);

    // 例化 Clocking Wizard IP
    clk_wiz_0 u_pll (
        .clk_in1  (clk_in),
        .resetn   (reset_n),

        .clk_out1 (clk_100m),
        .clk_out2 (clk_25m),

        .locked   (locked)
    );

    // 实际工程中, 需要等待 locked 信号稳定后再使用输出时钟
    // 通常的做法是: 用 locked 信号作为系统复位的释放条件

endmodule
