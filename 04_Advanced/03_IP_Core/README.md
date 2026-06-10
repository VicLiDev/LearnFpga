# 03_IP_Core — IP 核应用

## 什么是 IP 核？

IP 核 (Intellectual Property Core) 是预先设计好的、可复用的硬件模块。就像软件中的库函数一样。

## FPGA 厂商常用 IP 核

| IP 核 | 功能 | 典型用途 |
|-------|------|----------|
| **Block Memory Generator** | BRAM/ROM/FIFO | 数据存储 |
| **Clocking Wizard / PLL** | 时钟管理 | 产生所需时钟频率 |
| **FIFO Generator** | 同步/异步 FIFO | 跨时钟域缓冲 |
| **XDMA / AXI DMA** | DMA 传输 | 大数据搬运 |
| **FFT / FIR Compiler** | 数字信号处理 | DSP 应用 |
| **Ethernet MAC** | 网络通信 | 以太网接口 |
| **PCIe** | 高速串行 | PCIe 接口 |

## Vivado 中创建 IP 核的步骤

```
1. Flow Navigator → IP Catalog
2. 搜索 IP 名称 (如 "Block Memory Generator")
3. 双击 → 打开配置界面
4. 配置参数:
   - Memory Type: True Dual Port RAM
   - Write Width: 16
   - Write Depth: 1024
   - ...
5. Generate → 生成 IP 文件
6. 在设计中例化 (右键 IP → Generate Instantiation Template)
```

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_bram_ip_example.v` | Block RAM IP 核调用示例 |
| `02_fifo_ip_example.v` | FIFO IP 核调用示例 |
| `03_pll_ip_example.v` | PLL (Clocking Wizard) IP 核调用示例 |
