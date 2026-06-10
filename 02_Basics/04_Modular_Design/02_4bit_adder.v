//--------------------------------------------------------------------------------------------------
// 02_4bit_adder.v
// 4 位加法器 — 演示模块例化和层次化设计
//
// 本模块例化 4 个 full_adder 子模块
// 展示: 按端口名连接、内部连线 (wire)、层次化设计
//--------------------------------------------------------------------------------------------------

module adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);

    // 内部连线: 连接各级进位
    wire c1, c2, c3;

    // 例化 4 个全加器, 按端口名连接 (推荐方式)
    full_adder u_fa_bit0 (
        .a   (a[0]),
        .b   (b[0]),
        .cin (cin),
        .sum (sum[0]),
        .cout(c1)
    );

    full_adder u_fa_bit1 (
        .a   (a[1]),
        .b   (b[1]),
        .cin (c1),
        .sum (sum[1]),
        .cout(c2)
    );

    full_adder u_fa_bit2 (
        .a   (a[2]),
        .b   (b[2]),
        .cin (c2),
        .sum (sum[2]),
        .cout(c3)
    );

    full_adder u_fa_bit3 (
        .a   (a[3]),
        .b   (b[3]),
        .cin (c3),
        .sum (sum[3]),
        .cout(cout)
    );

endmodule
