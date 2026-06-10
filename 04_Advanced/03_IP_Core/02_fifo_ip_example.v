//--------------------------------------------------------------------------------------------------
// 02_fifo_ip_example.v
// FIFO IP 核调用示例
//
// 本文件展示如何例化 Vivado 的 FIFO Generator IP
// 用于跨时钟域数据缓冲
//
// 配置参考:
//   - FIFO Type: Independent Clocks (异步 FIFO)
//   - Data Width: 8
//   - Depth: 256
//   - Reset Pin: Active Low
//--------------------------------------------------------------------------------------------------

module fifo_ip_example (
    // 写时钟域
    input  wire            wr_clk,
    input  wire            wr_rst_n,
    input  wire [7:0]      wr_data,
    input  wire            wr_en,
    output wire            full,

    // 读时钟域
    input  wire            rd_clk,
    input  wire            rd_rst_n,
    output wire [7:0]      rd_data,
    input  wire            rd_en,
    output wire            empty
);

    // 例化 FIFO Generator IP
    fifo_ip u_fifo (
        .wr_clk   (wr_clk),
        .wr_rst   (~wr_rst_n),
        .din      (wr_data),
        .wr_en    (wr_en),
        .full     (full),

        .rd_clk   (rd_clk),
        .rd_rst   (~rd_rst_n),
        .dout     (rd_data),
        .rd_en    (rd_en),
        .empty    (empty)
    );

endmodule
