//--------------------------------------------------------------------------------------------------
// 02_counter_nbit.v
// 参数化 N 位计数器
//
// 功能: 0 计数到 (2^N - 1), 然后回到 0
// 带同步复位和使能
//
// 特点:
//   - N 可参数化 (默认 8 位, 计数 0~255)
//   - 同步复位 (sync_rst)
//   - 使能信号 (cnt_en)
//   - 溢出信号 (ovf), 当计满时输出一个时钟周期的高电平
//--------------------------------------------------------------------------------------------------

module counter_nbit #(
    parameter N = 8          // 计数器位宽
)(
    input  wire            clk,
    input  wire            rst_n,     // 异步复位
    input  wire            cnt_en,    // 计数使能
    output reg  [N-1:0]    cnt,       // 计数值
    output wire            ovf        // 溢出 (计满标志)
);

    // 溢出条件: 计数值达到最大值
    assign ovf = (cnt == {N{1'b1}});

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {N{1'b0}};           // 复位清零
        end else if (cnt_en) begin
            if (ovf)
                cnt <= {N{1'b0}};       // 计满归零
            else
                cnt <= cnt + 1'b1;      // 正常计数
        end
        // cnt_en 无效时保持当前值 (寄存器特性)
    end

endmodule
