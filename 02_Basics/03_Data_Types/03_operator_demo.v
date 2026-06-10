//--------------------------------------------------------------------------------------------------
// 03_operator_demo.v
// 运算符优先级演示
//
// 展示 Verilog 各种运算符的用法和优先级
//--------------------------------------------------------------------------------------------------

module operator_demo (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] result_add,
    output wire [7:0] result_mul,
    output wire [7:0] result_logic,
    output wire [7:0] result_shift,
    output wire       result_eq,
    output wire       result_gt
);

    // 算术运算
    assign result_add = a + b;           // 加法
    // assign result_sub = a - b;        // 减法
    // assign result_mul = a * b;        // 乘法 (8bit*8bit, 高位截断)

    // 乘法: 使用更宽的中间变量避免溢出
    wire [15:0] mul_wide;
    assign mul_wide    = a * b;
    assign result_mul   = mul_wide[7:0];  // 取低 8 位

    // 位运算
    assign result_logic = (a & b) | (~a ^ b);  // 复合位运算

    // 移位运算
    assign result_shift = a << 2;        // 左移 2 位 (等同于 a * 4)

    // 比较运算
    assign result_eq = (a == b);        // 相等
    assign result_gt = (a > b);         // 大于

endmodule
