//--------------------------------------------------------------------------------------------------
// 03_spi_master.v
// SPI 主机控制器 (Mode 0: CPOL=0, CPHA=0)
//
// 接口:
//   - 支持可配置的数据位宽 (8/16/32)
//   - 支持 LSB/MSB first
//   - CPOL=0, CPHA=0: 空闲 SCK=0, 上升沿采样
//
// 时序 (Mode 0):
//   CS# ───┐                         ┌────────────
//           └─────────────────────────┘
//   SCK  ──┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐
//           └─┘ └─┘ └─┘ └─┘ └─┘ └─┘
//   MOSI ───<d7><d6><d5><d4><d3><d2><d1><d0>  (MSB first)
//   MISO ───<d7><d6><d5><d4><d3><d2><d1><d0>  (simultaneously)
//--------------------------------------------------------------------------------------------------

module spi_master #(
    parameter CLK_FREQ   = 50_000_000,
    parameter SPI_FREQ    = 1_000_000,       // SPI 时钟频率 (1MHz)
    parameter BIT_WIDTH   = 8,              // 数据位宽
    parameter MSB_FIRST   = 1               // 1=MSB first, 0=LSB first
)(
    input  wire                      clk,
    input  wire                      rst_n,
    // SPI 接口
    output wire                      sck,
    output reg                       cs_n,
    output reg                       mosi,
    input  wire                      miso,
    // 用户接口
    input  wire [BIT_WIDTH-1:0]      tx_data,      // 待发送数据
    input  wire                      spi_start,    // 启动传输 (脉冲)
    output wire [BIT_WIDTH-1:0]     rx_data,      // 接收到的数据
    output reg                      spi_done,     // 传输完成脉冲
    output wire                     spi_busy      // 忙标志
);

    // 时钟分频
    localparam SPI_DIV = CLK_FREQ / (2 * SPI_FREQ);  // SCK 需要翻转 2 次产生 1 个周期

    reg [$clog2(SPI_DIV)-1:0] clk_cnt;
    reg sck_reg;
    wire clk_tick;

    assign clk_tick = (clk_cnt == SPI_DIV - 1);

    // SCK 分频
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt <= 0;
            sck_reg <= 1'b0;
        end else if (spi_busy && clk_tick) begin
            clk_cnt <= 0;
            sck_reg <= ~sck_reg;
        end else begin
            clk_cnt <= clk_cnt + 1'b1;
        end
    end
    assign sck = sck_reg;

    // 移位计数
    reg [$clog2(BIT_WIDTH)-1:0] bit_cnt;
    reg [BIT_WIDTH-1:0] shift_reg;
    reg active;

    assign spi_busy = active;
    assign rx_data   = shift_reg;

    // 主逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active    <= 1'b0;
            cs_n      <= 1'b1;
            mosi      <= 1'b0;
            bit_cnt   <= 0;
            shift_reg <= {BIT_WIDTH{1'b0}};
        end else begin
            spi_done <= 1'b0;

            if (!active) begin
                cs_n    <= 1'b1;     // 空闲时 CS# 高
                sck_reg <= 1'b0;
                if (spi_start) begin
                    active    <= 1'b1;
                    cs_n      <= 1'b0;   // 拉低 CS#
                    shift_reg <= tx_data;
                    bit_cnt   <= 0;
                end
            end else begin
                // Mode 0: 上升沿采样 (SCK 从 0 变 1 时)
                if (clk_tick && sck_reg == 1'b0) begin
                    // SCK 即将变高, 先输出 MOSI
                    if (MSB_FIRST)
                        mosi <= shift_reg[BIT_WIDTH-1];
                    else
                        mosi <= shift_reg[0];
                end

                if (clk_tick && sck_reg == 1'b1) begin
                    // SCK 下降沿: 采样 MISO, 移位
                    if (MSB_FIRST)
                        shift_reg <= {shift_reg[BIT_WIDTH-2:0], miso};
                    else
                        shift_reg <= {miso, shift_reg[BIT_WIDTH-1:1]};

                    bit_cnt <= bit_cnt + 1'b1;

                    if (bit_cnt == BIT_WIDTH - 1) begin
                        // 最后一位收完
                        active  <= 1'b0;
                        cs_n    <= 1'b1;
                        spi_done <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
