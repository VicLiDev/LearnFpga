//--------------------------------------------------------------------------------------------------
// 03_param_counter.v
// 参数化计数器 — 演示 parameter 的用法
//
// 通过 parameter WIDTH 控制计数器位宽
// 通过 parameter MAX_COUNT 控制计数上限
// 通过 parameter DIR 控制计数方向 (0=递增, 1=递减)
//--------------------------------------------------------------------------------------------------

module param_counter #(
    parameter WIDTH    = 8,         // 计数器位宽
    parameter MAX_VAL  = 255,       // 最大计数值 (2^WIDTH - 1)
    parameter DIR_UP   = 1'b1       // 1=递增, 0=递减
)(
    input  wire              clk,
    input  wire              rst_n,
    input  wire              enable,     // 计数使能
    output reg   [WIDTH-1:0]  count,      // 当前计数值
    output wire              overflow    // 溢出/下溢标志
);

    // 溢出条件
    assign overflow = (DIR_UP) ? (count == MAX_VAL) : (count == {WIDTH{1'b0}});

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= {WIDTH{1'b0}};
        end else if (enable) begin
            if (DIR_UP) begin
                if (overflow)
                    count <= {WIDTH{1'b0}};
                else
                    count <= count + 1'b1;
            end else begin
                if (overflow)
                    count <= MAX_VAL[WIDTH-1:0];
                else
                    count <= count - 1'b1;
            end
        end
    end

endmodule
