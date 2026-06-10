//--------------------------------------------------------------------------------------------------
// 01_data_types.v
// Verilog 数据类型演示
//
// 展示 wire, reg, 向量, parameter 的用法
//--------------------------------------------------------------------------------------------------

module data_types_demo (
    input  wire            clk,
    input  wire            rst_n,
    // wire 示例
    input  wire [7:0]      wire_input,
    output wire [7:0]      wire_output,
    // reg 示例
    input  wire [7:0]      reg_input,
    output reg  [7:0]      reg_output,
    // 向量位选择
    output wire            bit_sel,
    output wire [3:0]      part_sel
);

    // Parameter: 编译时常量
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    parameter MAX_COUNT = (1 << ADDR_WIDTH) - 1;  // 15

    // wire: 连续赋值
    assign wire_output = wire_input + 8'd1;

    // reg: 在 always 块中赋值 (此处为时序逻辑)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            reg_output <= {DATA_WIDTH{1'b0}};
        else
            reg_output <= reg_input;
    end

    // 位选择: 取第 3 位
    assign bit_sel = wire_input[3];

    // 部分选择: 取高 4 位 [7:4]
    assign part_sel = wire_input[7:4];

    // 内部 reg: 计数器
    reg [3:0] counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 4'd0;
        else if (counter >= MAX_COUNT)
            counter <= 4'd0;
        else
            counter <= counter + 1'b1;
    end

endmodule
