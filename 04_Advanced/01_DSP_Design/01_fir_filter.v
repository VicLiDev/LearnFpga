//--------------------------------------------------------------------------------------------------
// 01_fir_filter.v
// 4 阶 FIR 滤波器 (直接型结构)
//
// 公式: y[n] = h[0]*x[n] + h[1]*x[n-1] + h[2]*x[n-2] + h[3]*x[n-3]
//
// 结构:
//   xin ──→ [z⁻¹] ──→ [z⁻¹] ──→ [z⁻¹]
//     │       │         │         │
//     │      x[n-1]   x[n-2]   x[n-3]
//     │       │         │         │
//    [h₀]   [h₁]      [h₂]     [h₃]  → Σ → yout
//--------------------------------------------------------------------------------------------------

module fir_filter #(
    parameter COEFF_WIDTH = 16,       // 系数位宽
    parameter DATA_WIDTH  = 16,       // 数据位宽
    parameter ACC_WIDTH   = 32        // 累加器位宽
)(
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire signed [DATA_WIDTH-1:0]  xin,     // 输入数据 (有符号)
    output reg  signed [ACC_WIDTH-1:0]   yout     // 滤波器输出
);

    // 系数 (可修改, 此处用简单低通滤波器系数)
    // 实际工程中系数由 MATLAB/Python 计算得到
    reg signed [COEFF_WIDTH-1:0] coeff [0:3];
    initial begin
        coeff[0] = 16'sd2048;   // h[0] = 0.0625 (定点: 2048/32768)
        coeff[1] = 16'sd4096;   // h[1] = 0.125
        coeff[2] = 16'sd4096;   // h[2] = 0.125
        coeff[3] = 16'sd2048;   // h[3] = 0.0625
    end

    // 移位寄存器: 保存 x[n], x[n-1], x[n-2], x[n-3]
    reg signed [DATA_WIDTH-1:0] delay_line [0:3];

    // 移位 (打拍)
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                delay_line[i] <= 0;
        end else begin
            delay_line[0] <= xin;
            for (i = 1; i < 4; i = i + 1)
                delay_line[i] <= delay_line[i-1];
        end
    end

    // 乘累加 (MAC)
    reg signed [ACC_WIDTH-1:0] mac;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 0;
        end else begin
            mac = delay_line[0] * coeff[0]
                + delay_line[1] * coeff[1]
                + delay_line[2] * coeff[2]
                + delay_line[3] * coeff[3];
            yout <= mac;
        end
    end

endmodule
