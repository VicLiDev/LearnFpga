//--------------------------------------------------------------------------------------------------
// 04_async_fifo.v
// 异步 FIFO — 跨时钟域数据传输的经典方案
//
// 原理:
//   - 写端: 写时钟域, 管理写指针
//   - 读端: 读时钟域, 管理读指针
//   - 跨域同步: 写指针同步到读时钟域 (格雷码), 读指针同步到写时钟域
//   - 格雷码: 相邻值只变 1 位, 同步后最多差 1, 保证空满判断正确
//
// 关键公式:
//   full  = (wptr_gray_next == {~rptr_gray_sync[N], rptr_gray_sync[N-1:0]})
//   empty = (rptr_gray == wptr_gray_sync)
//--------------------------------------------------------------------------------------------------

module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4           // 深度 = 2^4 = 16
)(
    // 写端 (写时钟域)
    input  wire                      wr_clk,
    input  wire                      wr_rst_n,
    input  wire                      wr_en,
    input  wire [DATA_WIDTH-1:0]     wr_data,
    output wire                      full,

    // 读端 (读时钟域)
    input  wire                      rd_clk,
    input  wire                      rd_rst_n,
    input  wire                      rd_en,
    output wire [DATA_WIDTH-1:0]     rd_data,
    output wire                      empty
);

    localparam DEPTH = 1 << ADDR_WIDTH;

    // --------------------------------------------------------------------------------------------
    // 内部信号
    // --------------------------------------------------------------------------------------------
    reg [ADDR_WIDTH:0] wr_ptr, wr_ptr_gray;      // 写指针 (二进制 + 格雷码)
    reg [ADDR_WIDTH:0] rd_ptr, rd_ptr_gray;       // 读指针 (二进制 + 格雷码)
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;  // 同步到读域
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;  // 同步到写域
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    wire [ADDR_WIDTH-1:0] wr_addr, rd_addr;
    wire [ADDR_WIDTH:0] wr_ptr_gray_next, rd_ptr_gray_next;

    assign wr_addr = wr_ptr[ADDR_WIDTH-1:0];
    assign rd_addr = rd_ptr[ADDR_WIDTH-1:0];

    // --------------------------------------------------------------------------------------------
    // 二进制 → 格雷码 转换
    // --------------------------------------------------------------------------------------------
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    // --------------------------------------------------------------------------------------------
    // 写端逻辑
    // --------------------------------------------------------------------------------------------
    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wr_ptr      <= {(ADDR_WIDTH+1){1'b0}};
            wr_ptr_gray <= {(ADDR_WIDTH+1){1'b0}};
        end else if (wr_en && !full) begin
            wr_ptr      <= wr_ptr + 1'b1;
            wr_ptr_gray <= bin2gray(wr_ptr + 1'b1);
        end
    end

    // 写数据到 RAM
    always @(posedge wr_clk) begin
        if (wr_en && !full)
            mem[wr_addr] <= wr_data;
    end

    // 满判断
    assign full = (wr_ptr_gray_next == {~rd_ptr_gray_sync2[ADDR_WIDTH],
                                        rd_ptr_gray_sync2[ADDR_WIDTH-1:0]});
    assign wr_ptr_gray_next = bin2gray(wr_ptr + 1'b1);

    // --------------------------------------------------------------------------------------------
    // 读端逻辑
    // --------------------------------------------------------------------------------------------
    always @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rd_ptr      <= {(ADDR_WIDTH+1){1'b0}};
            rd_ptr_gray <= {(ADDR_WIDTH+1){1'b0}};
        end else if (rd_en && !empty) begin
            rd_ptr      <= rd_ptr + 1'b1;
            rd_ptr_gray <= bin2gray(rd_ptr + 1'b1);
        end
    end

    // 从 RAM 读数据 (同步读)
    assign rd_data = mem[rd_addr];

    // 空判断
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

    // --------------------------------------------------------------------------------------------
    // 跨时钟域同步 (2 级 FF 同步器)
    // --------------------------------------------------------------------------------------------
    // 写指针格雷码 → 同步到读时钟域
    always @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_ptr_gray_sync1 <= {(ADDR_WIDTH+1){1'b0}};
            wr_ptr_gray_sync2 <= {(ADDR_WIDTH+1){1'b0}};
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    // 读指针格雷码 → 同步到写时钟域
    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_ptr_gray_sync1 <= {(ADDR_WIDTH+1){1'b0}};
            rd_ptr_gray_sync2 <= {(ADDR_WIDTH+1){1'b0}};
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

endmodule
