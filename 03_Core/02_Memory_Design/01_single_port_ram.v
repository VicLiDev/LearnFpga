//--------------------------------------------------------------------------------------------------
// 01_single_port_ram.v
// 单端口 RAM — 同步写, 异步读
//
// 接口:
//   clk   — 时钟
//   addr  — 地址
//   din   — 写数据
//   dout  — 读数据 (异步, 组合逻辑)
//   we    — 写使能 (高电平有效)
//
// 特点:
//   - 1 个读/写端口 (共用地址)
//   - 同步写: 数据在时钟上升沿写入
//   - 异步读: 地址变化后 dout 立即变化 (通过 LUT)
//--------------------------------------------------------------------------------------------------

module single_port_ram #(
    parameter ADDR_WIDTH = 6,          // 地址位宽 (2^6 = 64 个存储单元)
    parameter DATA_WIDTH = 8           // 数据位宽
)(
    input  wire                      clk,
    input  wire [ADDR_WIDTH-1:0]     addr,
    input  wire [DATA_WIDTH-1:0]     din,
    input  wire                      we,
    output wire [DATA_WIDTH-1:0]     dout
);

    // 存储器数组: 2^ADDR_WIDTH 个 DATA_WIDTH 位的存储单元
    reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];

    // 同步写
    always @(posedge clk) begin
        if (we)
            ram[addr] <= din;
    end

    // 异步读 (连续赋值, 无需时钟)
    assign dout = ram[addr];

endmodule
