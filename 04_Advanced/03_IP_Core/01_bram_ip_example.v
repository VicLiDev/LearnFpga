//--------------------------------------------------------------------------------------------------
// 01_bram_ip_example.v
// Block RAM IP 核调用示例
//
// 本文件展示如何例化 Vivado 的 Block Memory Generator IP
// 实际使用时, 需要先在 IP Catalog 中配置并生成 IP
//
// 配置参考:
//   - Memory Type: True Dual Port RAM
//   - Port A Width: 16, Depth: 1024
//   - Port B Width: 16, Depth: 1024
//   - Operating Mode: No Change
//--------------------------------------------------------------------------------------------------

module bram_ip_example (
    input  wire            clk,

    // Port A (写端口)
    input  wire            wea,           // 写使能
    input  wire [9:0]      addra,         // 写地址
    input  wire [15:0]     dina,          // 写数据
    output wire [15:0]     douta,         // 读数据 A

    // Port B (读端口)
    input  wire [9:0]      addrb,         // 读地址
    output wire [15:0]     doutb          // 读数据 B
);

    // 例化 Block Memory Generator IP
    // Vivado 会自动生成以下模块 (名称可能不同)
    bram_ip u_bram_ip (
        .clka   (clk),
        .wea    (wea),
        .addra  (addra),
        .dina   (dina),
        .douta  (douta),

        .clkb   (clk),
        .web    (1'b0),        // Port B 不写
        .addrb  (addrb),
        .dinb   (16'd0),
        .doutb  (doutb)
    );

endmodule

//--------------------------------------------------------------------------------------------------
// 如果没有 IP, 也可以用行为描述实现 (见 03_Core/02_Memory_Design/02_dual_port_ram.v)
//--------------------------------------------------------------------------------------------------
