//--------------------------------------------------------------------------------------------------
// 03_mac_unit.v
// 乘累加单元 (Multiply-Accumulate, MAC)
//
// MAC 是 DSP 运算的核心: out = out + a × b
// FIR 滤波、FFT、相关运算、矩阵乘法都基于 MAC
//
// 在 Xilinx FPGA 中, 1 个 DSP48E1 可以完成 1 次 MAC 操作/周期
//--------------------------------------------------------------------------------------------------

module mac_unit #(
    parameter A_WIDTH = 16,
    parameter B_WIDTH = 16,
    parameter ACC_WIDTH = 48
)(
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire signed [A_WIDTH-1:0] a,         // 操作数 A
    input  wire signed [B_WIDTH-1:0] b,         // 操作数 B
    input  wire                      valid,     // 数据有效
    input  wire                      clear,     // 累加器清零
    output reg  signed [ACC_WIDTH-1:0] result    // 累加结果
);

    // 乘法结果 (位宽 = A_WIDTH + B_WIDTH)
    wire signed [A_WIDTH+B_WIDTH-1:0] product;
    assign product = a * b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {ACC_WIDTH{1'b0}};
        end else if (clear) begin
            result <= {ACC_WIDTH{1'b0}};
        end else if (valid) begin
            result <= result + product;   // 累加
        end
    end

endmodule
