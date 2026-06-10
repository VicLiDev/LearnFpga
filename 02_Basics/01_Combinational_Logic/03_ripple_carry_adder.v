//--------------------------------------------------------------------------------------------------
// 03_ripple_carry_adder.v
// 4位行波进位加法器 (Ripple Carry Adder, RCA)
//
// 原理: 将 4 个全加器级联, 低位进位连接到高位的 cin
//
//  a[3] b[3]       a[2] b[2]       a[1] b[1]       a[0] b[0]
//    \   /          \   /          \   /          \   /
//     FA3     ←     FA2     ←     FA1     ←     FA0
//    / | \           / | \          / | \          / | \
//  s[3]cout          s[2]           s[1]           s[0]
//
// 优缺点:
//   优点: 结构简单, 面积小
//   缺点: 进位逐级传递, 速度慢 (延迟 = N × T_full_adder)
//--------------------------------------------------------------------------------------------------

module ripple_carry_adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);

    // 级联进位信号
    wire c1, c2, c3;

    // 例化 4 个全加器
    full_adder fa0 (
        .a   (a[0]),
        .b   (b[0]),
        .cin (cin),
        .sum (sum[0]),
        .cout(c1)
    );

    full_adder fa1 (
        .a   (a[1]),
        .b   (b[1]),
        .cin (c1),
        .sum (sum[1]),
        .cout(c2)
    );

    full_adder fa2 (
        .a   (a[2]),
        .b   (b[2]),
        .cin (c2),
        .sum (sum[2]),
        .cout(c3)
    );

    full_adder fa3 (
        .a   (a[3]),
        .b   (b[3]),
        .cin (c3),
        .sum (sum[3]),
        .cout(cout)
    );

endmodule
