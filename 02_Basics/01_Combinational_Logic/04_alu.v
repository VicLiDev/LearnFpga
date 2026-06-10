//--------------------------------------------------------------------------------------------------
// 04_alu.v
// 简易 ALU (Arithmetic Logic Unit)
//
// 支持 4 种运算: ADD, SUB, AND, OR
// 通过 2 位 op 选择运算类型
//
// 运算表:
//   op[1:0] | Operation      | Result
//   00      | ADD (a + b)    | a + b
//   01      | SUB (a - b)    | a - b
//   10      | AND (a & b)    | a & b
//   11      | OR  (a | b)    | a | b
//--------------------------------------------------------------------------------------------------

module simple_alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [1:0] op,       // 运算选择
    output reg  [7:0] result,   // 运算结果
    output reg        zero      // 零标志 (result == 0)
);

    always @(*) begin
        case (op)
            2'b00: result = a + b;      // 加法
            2'b01: result = a - b;      // 减法
            2'b10: result = a & b;      // 按位与
            2'b11: result = a | b;      // 按位或
            default: result = 8'h00;
        endcase

        zero = (result == 8'h00);       // 零标志
    end

endmodule
