//--------------------------------------------------------------------------------------------------
// 01_half_adder.v
// 半加器 (Half Adder)
//
// 功能: 计算 1 位二进制加法
//       sum  = a XOR b   (本位和)
//       cout = a AND b    (进位)
//
// 真值表:
//   a  b | sum  cout
//   0  0 |  0    0
//   0  1 |  1    0
//   1  0 |  1    0
//   1  1 |  0    1
//--------------------------------------------------------------------------------------------------

module half_adder (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

    assign sum  = a ^ b;  // XOR: 本位和
    assign cout = a & b;  // AND: 进位

endmodule
