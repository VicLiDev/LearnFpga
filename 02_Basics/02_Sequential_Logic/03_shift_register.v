//--------------------------------------------------------------------------------------------------
// 03_shift_register.v
// N 位移位寄存器
//
// 功能: 每个时钟周期将数据向左移一位
//       串行输入 → 经过 N 个周期 → 从并行端口读出
//
// 应用:
//   - 串并转换 (SPI 接收)
//   - 延迟线
//   - 数据流缓冲
//--------------------------------------------------------------------------------------------------

module shift_register #(
    parameter N = 8          // 寄存器深度/位宽
)(
    input  wire            clk,
    input  wire            rst_n,
    input  wire            ser_in,        // 串行输入
    input  wire            shift_en,      // 移位使能
    input  wire            parallel_load, // 并行加载
    input  wire [N-1:0]    parallel_in,   // 并行输入
    output reg  [N-1:0]    shift_reg,    // 移位寄存器当前值
    output wire            ser_out        // 串行输出 (最高位)
);

    assign ser_out = shift_reg[N-1];  // 串行输出 = MSB

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= {N{1'b0}};
        end else if (parallel_load) begin
            shift_reg <= parallel_in;         // 并行加载
        end else if (shift_en) begin
            shift_reg <= {shift_reg[N-2:0], ser_in};  // 左移: 高位丢弃, 低位补 ser_in
        end
    end

endmodule
