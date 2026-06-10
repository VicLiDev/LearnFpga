//--------------------------------------------------------------------------------------------------
// 02_cdc_synchronizer.v
// 2 级 FF 同步器 — 跨时钟域单比特信号同步
//
// 原理:
//   异步信号 → FF1 → FF2 → 同步信号
//   FF1 可能亚稳态, 经过 1 个时钟周期后, FF2 采样时 FF1 输出大概率已稳定
//
// 注意:
//   - 只适用于单比特信号
//   - 多比特信号必须用异步 FIFO
//--------------------------------------------------------------------------------------------------

module cdc_synchronizer #(
    parameter WIDTH = 1    // 同步信号位宽 (推荐 = 1)
)(
    input  wire             dst_clk,      // 目标时钟域时钟
    input  wire             dst_rst_n,    // 目标时钟域复位
    input  wire [WIDTH-1:0] async_in,    // 异步输入 (来自另一个时钟域)
    output reg  [WIDTH-1:0] sync_out     // 同步输出 (安全, 可在 dst_clk 域使用)
);

    reg [WIDTH-1:0] sync_stage1;

    // 第一级同步
    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            sync_stage1 <= {WIDTH{1'b0}};
        end else begin
            sync_stage1 <= async_in;
        end
    end

    // 第二级同步
    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            sync_out <= {WIDTH{1'b0}};
        end else begin
            sync_out <= sync_stage1;
        end
    end

endmodule
