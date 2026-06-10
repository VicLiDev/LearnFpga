//--------------------------------------------------------------------------------------------------
// 01_full_adder.v
// 全加器子模块 — 被 02_4bit_adder.v 例化
//--------------------------------------------------------------------------------------------------

module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));

endmodule
