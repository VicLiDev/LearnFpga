//--------------------------------------------------------------------------------------------------
// 02_fft_butterfly.v
// FFT 基-2 蝶形运算单元 (Radix-2 DIT Butterfly)
//
// 蝶形运算:
//   A' = A + W × B
//   B' = A - W × B
//
// 其中 W = W_N^k = exp(-j * 2πk/N) 是旋转因子 (twiddle factor)
//
// 在硬件实现中, 复数运算拆分为实部和虚部:
//   W = (wr + j*wi)
//   B = (br + j*bi)
//   W × B = (wr*br - wi*bi) + j*(wr*bi + wi*br)
//--------------------------------------------------------------------------------------------------

module fft_butterfly (
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire signed [15:0]        ar, ai,    // 输入 A (实部, 虚部)
    input  wire signed [15:0]        br, bi,    // 输入 B (实部, 虚部)
    input  wire signed [15:0]        wr, wi,    // 旋转因子 W (实部, 虚部)
    input  wire                      valid_in,  // 输入有效
    output reg  signed [15:0]        ar_out, ai_out,  // 输出 A' (实部, 虚部)
    output reg  signed [15:0]        br_out, bi_out,  // 输出 B' (实部, 虚部)
    output reg                       valid_out  // 输出有效
);

    // 复数乘法: W × B
    wire signed [31:0] mult_real = wr * br - wi * bi;   // 实部
    wire signed [31:0] mult_imag = wr * bi + wi * br;   // 虚部

    // 取高 16 位 (右移 15 位, 近似除以 32768 归一化)
    wire signed [15:0] wb_r = mult_real[30:15];
    wire signed [15:0] wb_i = mult_imag[30:15];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ar_out   <= 16'sd0;
            ai_out   <= 16'sd0;
            br_out   <= 16'sd0;
            bi_out   <= 16'sd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
            // A' = A + W*B
            ar_out <= ar + wb_r;
            ai_out <= ai + wb_i;
            // B' = A - W*B
            br_out <= ar - wb_r;
            bi_out <= ai - wb_i;
        end
    end

endmodule
