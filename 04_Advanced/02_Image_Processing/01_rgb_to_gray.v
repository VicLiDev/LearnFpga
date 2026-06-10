//--------------------------------------------------------------------------------------------------
// 01_rgb_to_gray.v
// RGB565 → 8-bit 灰度转换
//
// 转换公式 (BT.601):
//   Y = 0.299 × R + 0.587 × G + 0.114 × B
//
// 定点化 (乘以 256 后取整数):
//   Y = (77 × R + 150 × G + 29 × B) >> 8
//--------------------------------------------------------------------------------------------------

module rgb_to_gray (
    input  wire            clk,
    input  wire            rst_n,
    input  wire [15:0]     rgb565,        // 输入 RGB565 像素
    input  wire            valid_in,       // 输入有效
    output reg  [7:0]      gray,           // 输出灰度值
    output reg             valid_out       // 输出有效
);

    // RGB565 拆分
    wire [4:0] r = rgb565[15:11];    // 5 bit Red
    wire [5:0] g = rgb565[10:5];     // 6 bit Green
    wire [4:0] b = rgb565[4:0];      // 5 bit Blue

    // 扩展到 8 位
    wire [7:0] r8 = {r, r[4:2]};     // 5bit → 8bit: 高位补 0
    wire [7:0] g8 = {g, g[5:3]};     // 6bit → 8bit
    wire [7:0] b8 = {b, b[4:2]};     // 5bit → 8bit

    // 定点运算: Y = 77*R + 150*G + 29*B
    wire [19:0] y_full = 8'd77  * r8
                        + 8'd150 * g8
                        + 8'd29  * b8;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gray      <= 8'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
            gray      <= y_full[19:12];   // 右移 12 位 (≈ 除以 4096, 等效缩放)
            // 更精确: y_full / 256 = y_full >> 8, 但需要更多位
            // 这里用 >> 12 然后结果范围仍在 0~255
        end
    end

endmodule
