//--------------------------------------------------------------------------------------------------
// 02_sequence_detector.v
// 序列检测器 — Mealy 型 FSM
//
// 功能: 检测输入比特流中的 "1011" 序列
//       当检测到序列 "1011" 时, 输出 found = 1
//
// Mealy 特点: 输出取决于当前状态 + 当前输入
//   → 响应更快 (在收到最后一个比特的同一周期就能输出)
//
// 状态转移图:
//   IDLE ──(1)──→ S1 ──(0)──→ S10 ──(1)──→ S101 ──(1)──→ [found=1] ──→ S1
//     ↑              │                         │
//     └──(0)─────────┴───(0)──────────────────┘
//--------------------------------------------------------------------------------------------------

module sequence_detector (
    input  wire clk,
    input  wire rst_n,
    input  wire din,       // 串行数据输入 (每时钟 1 bit)
    output reg  found      // 检测到 "1011" 时输出 1
);

    // 状态定义
    localparam S_IDLE = 2'd0;  // 初始/已匹配 ""
    localparam S_1    = 2'd1;  // 已匹配 "1"
    localparam S_10   = 2'd2;  // 已匹配 "10"
    localparam S_101  = 2'd3;  // 已匹配 "101"

    reg [1:0] state, next_state;

    // --------------------------------------------------------------------------------------------
    // 1. 状态寄存器
    // --------------------------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // --------------------------------------------------------------------------------------------
    // 2. 下一状态逻辑 (Mealy: 也包含输出)
    // --------------------------------------------------------------------------------------------
    always @(*) begin
        // 默认值
        next_state = state;
        found      = 1'b0;

        case (state)
            S_IDLE: begin
                if (din) next_state = S_1;    // 收到 "1"
            end

            S_1: begin
                if (!din) next_state = S_10;   // 收到 "10"
                // din=1: 保持 S_1 (重叠匹配: "...11" 中第二个 1 是新的起点)
            end

            S_10: begin
                if (din)  next_state = S_101;  // 收到 "101"
                else      next_state = S_IDLE; // 收到 "100" → 失败, 回到初始
            end

            S_101: begin
                if (din) begin
                    found      = 1'b1;        // 收到 "1011" → 检测成功!
                    next_state = S_1;          // 最后的 "1" 可以是新序列的起点
                end else begin
                    next_state = S_10;         // 收到 "1010" → "10" 是有效前缀
                end
            end

            default: begin
                next_state = S_IDLE;
                found      = 1'b0;
            end
        endcase
    end

endmodule
