//--------------------------------------------------------------------------------------------------
// 03_line_buffer.v
// 行缓冲器 — 为 3x3 邻域操作生成滑动窗口
//
// 功能: 输入连续像素流, 输出 3x3 窗口的 9 个像素
//
// 原理:
//   用 2 条移位寄存器 (长度 = 图像宽度) 存储前 2 行
//   当前行实时输入
//   每个时钟周期输出窗口的 9 个像素
//--------------------------------------------------------------------------------------------------

module line_buffer #(
    parameter IMG_WIDTH = 640,      // 图像宽度 (像素数)
    parameter DATA_WIDTH = 8         // 像素位宽
)(
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire [DATA_WIDTH-1:0]     pixel_in,     // 像素输入
    input  wire                      valid_in,     // 输入有效
    output wire [DATA_WIDTH-1:0]     p00, p01, p02, // 3x3 窗口输出
    output wire [DATA_WIDTH-1:0]     p10, p11, p12,
    output wire [DATA_WIDTH-1:0]     p20, p21, p22,
    output wire                     valid_out     // 窗口有效
);

    // 行缓冲: 存储前两行像素
    // 用 shift register (SRL) 或 BRAM 实现
    reg [DATA_WIDTH-1:0] line0 [0:IMG_WIDTH-1];   // 倒数第 3 行
    reg [DATA_WIDTH-1:0] line1 [0:IMG_WIDTH-1];   // 倒数第 2 行

    // 列计数器
    reg [15:0] col_cnt;
    wire last_pixel = (col_cnt == IMG_WIDTH - 1);

    // 当前行的 3 个像素延迟
    reg [DATA_WIDTH-1:0] d0, d1, d2;  // 当前行: p20, p21, p22

    // 行计数器 (追踪有效行)
    reg [1:0] line_cnt;

    // 有效窗口 (至少填满 2 行 + 3 列后才开始输出)
    assign valid_out = valid_in && (line_cnt >= 2'd2) && (col_cnt >= 16'd1);

    // 当前行的延迟链
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d0 <= {DATA_WIDTH{1'b0}};
            d1 <= {DATA_WIDTH{1'b0}};
            d2 <= {DATA_WIDTH{1'b0}};
        end else if (valid_in) begin
            d0 <= pixel_in;
            d1 <= d0;
            d2 <= d1;
        end
    end

    // 行缓冲写入和列计数
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < IMG_WIDTH; i = i + 1) begin
                line0[i] <= {DATA_WIDTH{1'b0}};
                line1[i] <= {DATA_WIDTH{1'b0}};
            end
            col_cnt  <= 16'd0;
            line_cnt <= 2'd0;
        end else if (valid_in) begin
            // 移位行缓冲
            line1[col_cnt] <= line0[col_cnt];  // 旧第2行 ← 旧第3行
            line0[col_cnt] <= d0;               // 新第3行 ← 当前行

            // 列计数
            if (last_pixel) begin
                col_cnt  <= 16'd0;
                line_cnt <= line_cnt + 1'b1;
            end else begin
                col_cnt <= col_cnt + 1'b1;
            end
        end
    end

    // 3x3 窗口输出
    // p00, p01, p02 = line0 的前一个、当前、下一个像素
    // p10, p11, p12 = line1
    // p20, p21, p22 = 当前行延迟

    assign p00 = line0[col_cnt == 0 ? IMG_WIDTH-1 : col_cnt - 1];
    assign p01 = line0[col_cnt];
    assign p02 = line0[col_cnt == IMG_WIDTH-1 ? 0 : col_cnt + 1];

    assign p10 = line1[col_cnt == 0 ? IMG_WIDTH-1 : col_cnt - 1];
    assign p11 = line1[col_cnt];
    assign p12 = line1[col_cnt == IMG_WIDTH-1 ? 0 : col_cnt + 1];

    assign p20 = d2;
    assign p21 = d1;
    assign p22 = d0;

endmodule
