//--------------------------------------------------------------------------------------------------
// 02_full_adder.v
// 全加器 (Full Adder)
//
// 功能: 计算 1 位二进制加法 (带低位进位)
//       sum  = a XOR b XOR cin
//       cout = (a AND b) OR (cin AND (a XOR b))
//
// 真值表:
//   a  b  cin | sum  cout
//   0  0   0  |  0    0
//   0  0   1  |  1    0
//   0  1   0  |  1    0
//   0  1   1  |  0    1
//   1  0   0  |  1    0
//   1  0   1  |  0    1
//   1  1   0  |  0    1
//   1  1   1  |  1    1
//--------------------------------------------------------------------------------------------------

module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,    // 低位进位输入
    output wire sum,
    output wire cout
);

    assign sum  = a ^ b ^ cin;                              // 三输入 XOR
    assign cout = (a & b) | (cin & (a ^ b));               // 进位逻辑

endmodule
