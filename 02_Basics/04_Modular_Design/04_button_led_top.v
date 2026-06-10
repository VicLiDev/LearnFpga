//--------------------------------------------------------------------------------------------------
// 04_button_led_top.v
// 按键控制 LED — 完整小工程演示
//
// 功能:
//   - 按键 1: LED 全亮
//   - 按键 2: LED 全灭
//   - 按键 3: LED 流水灯模式
//   - 按键 4: LED 呼吸灯模式
//
// 展示: 顶层模块设计, 子模块例化, 状态机初步概念
//--------------------------------------------------------------------------------------------------

module button_led_top (
    input  wire       clk,        // 系统时钟 50MHz
    input  wire       rst_n,      // 复位
    input  wire [3:0] btn,        // 4 个按键 (假设已消抖)
    output reg  [7:0] led         // 8 个 LED
);

    // 状态参数 (简易状态编码)
    localparam S_ALL_ON    = 2'b00;
    localparam S_ALL_OFF   = 2'b01;
    localparam S_RUNNING   = 2'b10;
    localparam S_BREATHING = 2'b11;

    reg [1:0] mode;                // 当前模式
    reg [23:0] tick_cnt;          // 慢时钟计数器
    wire       tick;               // 慢时钟滴答 (~2Hz)
    reg [7:0]  shift_reg;         // 流水灯移位寄存器

    assign tick = (tick_cnt == 24'd25_000_000);  // ~0.5s at 50MHz

    // 慢时钟计数器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tick_cnt <= 24'd0;
        else if (tick)
            tick_cnt <= 24'd0;
        else
            tick_cnt <= tick_cnt + 1'b1;
    end

    // 模式切换 (按键优先级: btn[0] > btn[1] > btn[2] > btn[3])
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mode <= S_ALL_OFF;
        else if (btn[0])
            mode <= S_ALL_ON;
        else if (btn[1])
            mode <= S_ALL_OFF;
        else if (btn[2])
            mode <= S_RUNNING;
        else if (btn[3])
            mode <= S_BREATHING;
    end

    // LED 输出逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led <= 8'h00;
            shift_reg <= 8'h01;
        end else begin
            case (mode)
                S_ALL_ON: begin
                    led <= 8'hFF;
                    shift_reg <= 8'h01;
                end

                S_ALL_OFF: begin
                    led <= 8'h00;
                    shift_reg <= 8'h01;
                end

                S_RUNNING: begin
                    if (tick) begin
                        shift_reg <= {shift_reg[6:0], shift_reg[7]};
                    end
                    led <= shift_reg;
                end

                S_BREATHING: begin
                    // 简易呼吸: 用 tick_cnt 的某些位来模拟亮度
                    led <= {tick_cnt[23], tick_cnt[23], tick_cnt[23], tick_cnt[23],
                            tick_cnt[23], tick_cnt[23], tick_cnt[23], tick_cnt[23]};
                end

                default: led <= 8'h00;
            endcase
        end
    end

endmodule
