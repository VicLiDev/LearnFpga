//--------------------------------------------------------------------------------------------------
// 03_pulse_sync.v
// 脉冲同步 — 将一个时钟域的脉冲信号同步到另一个时钟域
//
// 应用场景: 一个时钟域的 "事件" 需要触发另一个时钟域的动作
//
// 快时钟 → 慢时钟: 直接同步可能漏脉冲
// 慢时钟 → 快时钟: 直接同步即可 (快时钟一定能采样到)
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
// 快时钟域 → 慢时钟域
// 原理: 将脉冲展宽为电平, 同步后再检测上升沿
//--------------------------------------------------------------------------------------------------
module pulse_sync_fast2slow (
    input  wire src_clk,
    input  wire src_rst_n,
    input  wire src_pulse,         // 源域脉冲 (1 个 src_clk 周期宽)
    output reg  dst_pulse,          // 目标域脉冲
    input  wire dst_clk,
    input  wire dst_rst_n
);

    // 源域: 脉冲 → 展宽电平
    reg src_level;
    always @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n)
            src_level <= 1'b0;
        else if (src_pulse)
            src_level <= 1'b1;     // 脉冲到来, 电平置高
        else if (dst_pulse)        // 收到确认, 电平拉低
            src_level <= 1'b0;
    end

    // 跨域同步: 2 级 FF
    reg sync1, sync2;
    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            sync1 <= 1'b0;
            sync2 <= 1'b0;
        end else begin
            sync1 <= src_level;
            sync2 <= sync1;
        end
    end

    // 目标域: 检测上升沿 → 产生脉冲
    reg sync2_d;
    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            sync2_d <= 1'b0;
        end else begin
            sync2_d <= sync2;
        end
    end

    // 上升沿检测
    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n)
            dst_pulse <= 1'b0;
        else
            dst_pulse <= sync2 & ~sync2_d;  // 上升沿 = 当前高 & 上一周期低
    end

endmodule
