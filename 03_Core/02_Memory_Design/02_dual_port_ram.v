//--------------------------------------------------------------------------------------------------
// 02_dual_port_ram.v
// 简易双端口 RAM — 两套独立的读写端口
//
// 端口 A: 读写端口 (clk_a 驱动)
// 端口 B: 只读端口 (clk_b 驱动, 跨时钟域读)
//
// 典型应用: 一个时钟域写, 另一个时钟域读
//--------------------------------------------------------------------------------------------------

module dual_port_ram #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    // 端口 A (写)
    input  wire                      clk_a,
    input  wire [ADDR_WIDTH-1:0]     addr_a,
    input  wire [DATA_WIDTH-1:0]     din_a,
    input  wire                      we_a,
    output wire [DATA_WIDTH-1:0]     dout_a,

    // 端口 B (只读)
    input  wire                      clk_b,
    input  wire [ADDR_WIDTH-1:0]     addr_b,
    output wire [DATA_WIDTH-1:0]     dout_b
);

    reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];

    // 端口 A: 同步写
    always @(posedge clk_a) begin
        if (we_a)
            ram[addr_a] <= din_a;
    end

    // 端口 A: 异步读
    assign dout_a = ram[addr_a];

    // 端口 B: 异步读
    assign dout_b = ram[addr_b];

endmodule
