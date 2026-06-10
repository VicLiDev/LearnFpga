//--------------------------------------------------------------------------------------------------
// 04_encoder.v
// 8-3 优先编码器 — 8 位输入, 3 位输出
//
// 优先编码器是"多对一"的电路, 当多个输入同时有效时,
// 只有最高优先级的输入被编码输出。
//
// 常用于: 中断控制器、仲裁器
//--------------------------------------------------------------------------------------------------

module encoder_8to3 (
    input  wire [7:0] d,       // 8 位输入
    output reg  [2:0] y,      // 3 位编码输出
    output reg        valid    // 有效信号 (任意输入为1时有效)
);

    // 优先级: d[7] > d[6] > ... > d[0]
    // 用 if-else if 实现优先级 (从高到低检查)
    always @(*) begin
        valid = 1'b0;
        y = 3'b000;

        if (d[7]) begin
            y     = 3'b111;
            valid = 1'b1;
        end else if (d[6]) begin
            y     = 3'b110;
            valid = 1'b1;
        end else if (d[5]) begin
            y     = 3'b101;
            valid = 1'b1;
        end else if (d[4]) begin
            y     = 3'b100;
            valid = 1'b1;
        end else if (d[3]) begin
            y     = 3'b011;
            valid = 1'b1;
        end else if (d[2]) begin
            y     = 3'b010;
            valid = 1'b1;
        end else if (d[1]) begin
            y     = 3'b001;
            valid = 1'b1;
        end else if (d[0]) begin
            y     = 3'b000;
            valid = 1'b1;
        end
        // else: 保持 default (valid=0, y=000)
    end

endmodule
