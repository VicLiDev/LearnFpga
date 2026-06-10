//--------------------------------------------------------------------------------------------------
// 01_traffic_light.v
// 交通灯控制器 — Moore 型 FSM
//
// 状态机:
//   RED(5s) → GREEN(5s) → YELLOW(2s) → RED(5s) → ...
//
// 假设时钟 50MHz, 使用计数器实现不同时长
//   5 秒  = 250,000,000 周期
//   2 秒  = 100,000,000 周期
//--------------------------------------------------------------------------------------------------

module traffic_light (
    input  wire clk,
    input  wire rst_n,
    output reg  [2:0] light     // [2]:红, [1]:黄, [0]:绿
);

    // 状态定义 (One-Hot 编码, 3 个状态用 3 位)
    localparam S_RED    = 3'b001;
    localparam S_GREEN  = 3'b010;
    localparam S_YELLOW = 3'b100;

    // 时长参数 (仿真时可缩小)
    localparam RED_TIME   = 250_000_000;   // 5 秒
    localparam GREEN_TIME = 250_000_000;   // 5 秒
    localparam YELLOW_TIME= 100_000_000;   // 2 秒

    reg [2:0]  state, next_state;
    reg [27:0] timer;           // 28 位计数器, 最大 268M
    wire       red_timeout, green_timeout, yellow_timeout;

    assign red_timeout    = (timer == RED_TIME   - 1);
    assign green_timeout = (timer == GREEN_TIME - 1);
    assign yellow_timeout= (timer == YELLOW_TIME- 1);

    // --------------------------------------------------------------------------------------------
    // 1. 状态寄存器 (时序逻辑)
    // --------------------------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S_RED;
        else
            state <= next_state;
    end

    // --------------------------------------------------------------------------------------------
    // 2. 下一状态逻辑 + 计时器 (组合 + 时序混合)
    // --------------------------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            next_state <= S_RED;
            timer      <= 28'd0;
        end else begin
            case (state)
                S_RED: begin
                    if (red_timeout) begin
                        next_state <= S_GREEN;
                        timer      <= 28'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                S_GREEN: begin
                    if (green_timeout) begin
                        next_state <= S_YELLOW;
                        timer      <= 28'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                S_YELLOW: begin
                    if (yellow_timeout) begin
                        next_state <= S_RED;
                        timer      <= 28'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                default: begin
                    next_state <= S_RED;
                    timer      <= 28'd0;
                end
            endcase
        end
    end

    // --------------------------------------------------------------------------------------------
    // 3. 输出逻辑 (Moore 型: 仅取决于当前状态)
    // --------------------------------------------------------------------------------------------
    always @(*) begin
        case (state)
            S_RED:    light = 3'b100;   // 红灯亮
            S_GREEN:  light = 3'b001;   // 绿灯亮
            S_YELLOW: light = 3'b010;   // 黄灯亮
            default: light = 3'b100;
        endcase
    end

endmodule
