//--------------------------------------------------------------------------------------------------
// 01_basic_gates.v
// 基本逻辑门演示 — AND, OR, NOT, XOR, NAND, NOR
//--------------------------------------------------------------------------------------------------

module basic_gates (
    input  wire a,
    input  wire b,
    output wire y_and,    // a AND b
    output wire y_or,     // a OR b
    output wire y_not,    // NOT a
    output wire y_xor,    // a XOR b
    output wire y_nand,   // a NAND b
    output wire y_nor     // a NOR b
);

    // 使用 assign (连续赋值) 描述组合逻辑
    // assign 语句对应实际的硬件连线

    assign y_and  = a & b;     // AND:  与门
    assign y_or   = a | b;     // OR:   或门
    assign y_not  = ~a;        // NOT:  非门
    assign y_xor  = a ^ b;     // XOR:  异或门
    assign y_nand = ~(a & b);  // NAND: 与非门
    assign y_nor  = ~(a | b);  // NOR:  或非门

    // 真值表 (a=0, b=0 → 1):
    // a b | AND OR NOT XOR NAND NOR
    // 0 0 |  0  0   1   0    1    1
    // 0 1 |  0  1   1   1    1    0
    // 1 0 |  0  1   0   1    1    0
    // 1 1 |  1  1   0   0    0    0

endmodule
