//--------------------------------------------------------------------------------------------------
// 02_sobel_edge.v
// Sobel 边缘检测 — 3x3 邻域操作
//
// Sobel 算子:
//   Gx = [[-1, 0, 1],        Gy = [[-1, -2, -1],
//         [-2, 0, 2],               [ 0,  0,  0],
//         [-1, 0, 1]]               [ 1,  2,  1]]
//
//   G = |Gx| + |Gy|  (近似梯度幅值, 省去开方)
//--------------------------------------------------------------------------------------------------

module sobel_edge (
    input  wire            clk,
    input  wire            rst_n,
    input  wire [7:0]      p00, p01, p02,   // 3x3 窗口像素 (来自行缓冲)
    input  wire [7:0]      p10, p11, p12,
    input  wire [7:0]      p20, p21, p22,
    input  wire            valid_in,
    output reg  [7:0]      edge_out,       // 边缘强度
    output reg             valid_out
);

    // Gx 计算 (水平梯度)
    reg signed [11:0] gx;
    always @(*) begin
        gx = {4'b0, p02} + {4'b0, p12} + {4'b0, p22}
           - {4'b0, p00} - {4'b0, p10} - {4'b0, p20};
    end

    // Gy 计算 (垂直梯度)
    reg signed [11:0] gy;
    always @(*) begin
        gy = {4'b0, p20} + {4'b0, p21} + {4'b0, p22}
           - {4'b0, p00} - {4'b0, p01} - {4'b0, p02};
    end

    // 梯度幅值近似: |Gx| + |Gy| (省去开方运算)
    reg [11:0] abs_gx;
    reg [11:0] abs_gy;
    always @(*) begin
        abs_gx = gx[11] ? -gx : gx;
        abs_gy = gy[11] ? -gy : gy;
    end

    wire [11:0] magnitude = abs_gx + abs_gy;
    wire edge_detected = (magnitude > 12'd128);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_out  <= 8'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_in;
            edge_out  <= edge_detected ? 8'd255 : 8'd0;
        end
    end

endmodule
