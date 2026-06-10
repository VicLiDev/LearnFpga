//--------------------------------------------------------------------------------------------------
// 02_signed_arithmetic.v
// 有符号数运算
//
// 关键点:
//   1. 用 `signed` 关键字声明有符号数
//   2. 有符号乘法: result 位宽 = operand_a_width + operand_b_width
//   3. 右移时: >> 是逻辑右移 (补0), >>> 是算术右移 (补符号位)
//--------------------------------------------------------------------------------------------------

module signed_arithmetic (
    input  wire               clk,
    input  wire               rst_n,
    input  wire signed [7:0]  a,         // 有符号 8 位输入
    input  wire signed [7:0]  b,         // 有符号 8 位输入
    output reg  signed [15:0] mul_result, // 乘法结果 (16位)
    output reg  signed [7:0]  add_result, // 加法结果 (8位, 可能溢出)
    output reg  signed [7:0]  sub_result, // 减法结果 (8位)
    output reg  signed [7:0]  asr_result  // 算术右移结果
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_result <= 16'd0;
            add_result <= 8'd0;
            sub_result <= 8'd0;
            asr_result <= 8'd0;
        end else begin
            mul_result <= a * b;              // 有符号乘法: 8bit * 8bit = 16bit
            add_result <= a + b;              // 有符号加法 (注意溢出)
            sub_result <= a - b;              // 有符号减法
            asr_result <= a >>> 2;            // 算术右移 2 位 (保留符号位)
        end
    end

endmodule
