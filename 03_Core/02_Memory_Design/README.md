# 02_Memory_Design — 存储器设计

## FPGA 中的存储器类型

| 类型 | 特点 | FPGA 资源 | 典型用途 |
|------|------|-----------|----------|
| **分布式 RAM** | 用 LUT 实现, 小容量, 异步读 | LUT | 少量寄存器/查找表 |
| **Block RAM (BRAM)** | 专用存储块, 大容量, 同步读 | BRAM | 数据缓冲、帧缓冲 |
| **移位寄存器** | SRL16/SRL32, 用 LUT 实现 | LUT | 延迟线、FIFO |
| **寄存器文件** | 用 FF 实现 | FF | 小型高速存储 |

## FPGA 存储资源（以 Xilinx 7 系列为例）

```
Artix-7 XC7A35T:
  - LUT: 20,800 个
  - FF:  41,600 个
  - BRAM: 50 个 (每个 36Kb = 4.5KB, 共 225KB)
  - 总可用 BRAM 容量: 约 225 KB

Zynq xc7z010:
  - BRAM: 60 个 (共 270 KB)
```

## 存储器实现的两种方式

### 1. Verilog 行为描述（推荐学习用）
```verilog
reg [7:0] mem [0:63];  // 64x8 RAM
always @(posedge clk) begin
    if (we) mem[addr] <= din;
end
assign dout = mem[addr];  // 分布式 RAM (异步读)
```

### 2. 调用 IP 核（推荐工程用）
在 Vivado 中通过 IP Catalog 配置 Block RAM Generator，选择端口数、位宽、深度、初始化文件等。

## 异步 FIFO — 跨时钟域的关键

FIFO (First In First Out) 是跨时钟域数据传输的标准方案。

核心组件：
- **双端口 RAM**: 存储数据
- **写指针 + 同步器**: 同步到读时钟域
- **读指针 + 同步器**: 同步到写时钟域
- **空/满判断**: 基于格雷码指针比较

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_single_port_ram.v` | 单端口 RAM (同步写, 异步读) |
| `02_dual_port_ram.v` | 双端口 RAM (两套独立端口) |
| `03_simple_rom.v` | ROM (查表实现) |
| `04_async_fifo.v` | 异步 FIFO (格雷码指针) |
