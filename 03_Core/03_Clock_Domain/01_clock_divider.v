//--------------------------------------------------------------------------------------------------
// 01_clock_divider.v
// 时钟分频器
//
// 注意: 简单分频器产生的时钟毛刺多, 不推荐用于大规模设计!
//       工程中应使用 PLL/MMCM IP 来产生分频时钟。
//       此处仅用于学习理解。
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
// 偶数分频: 占空比 50%
// 分频系数 N = 2, 4, 8, ...
//--------------------------------------------------------------------------------------------------
module clock_divider_even #(
    parameter DIVISOR = 4    // 分频系数 (必须是 2 的幂)
)(
    input  wire clk,         // 原始时钟
    input  wire rst_n,
    output reg  clk_div      // 分频后的时钟
);

    reg [$clog2(DIVISOR)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter  <= 0;
            clk_div  <= 1'b0;
        end else begin
            if (counter == (DIVISOR/2 - 1)) begin
                counter <= 0;
                clk_div <= ~clk_div;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule


//--------------------------------------------------------------------------------------------------
// 奇数分频: 占空比 50%
// 分频系数 N = 3, 5, 7, ...
// 原理: 上升沿产生高电平, 下降沿产生高电平, 两者组合得到 50% 占空比
//--------------------------------------------------------------------------------------------------
module clock_divider_odd #(
    parameter DIVISOR = 3    // 奇数分频系数
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    reg [$clog2(DIVISOR)-1:0] cnt_pos, cnt_neg;
    reg clk_pos, clk_neg;

    // 上升沿计数
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos  <= 0;
            clk_pos  <= 1'b0;
        end else if (cnt_pos == DIVISOR - 1) begin
            cnt_pos  <= 0;
            clk_pos  <= ~clk_pos;
        end else begin
            cnt_pos  <= cnt_pos + 1'b1;
        end
    end

    // 下降沿计数
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg  <= 0;
            clk_neg  <= 1'b0;
        end else if (cnt_neg == DIVISOR - 1) begin
            cnt_neg  <= 0;
            clk_neg  <= ~clk_neg;
        end else begin
            cnt_neg  <= cnt_neg + 1'b1;
        end
    end

    // 组合得到 50% 占空比
    assign clk_div = clk_pos & clk_neg;

endmodule
