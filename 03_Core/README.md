# 03_Core — 核心篇

本章节涵盖 FPGA 工程中最常用的设计模式：状态机、存储器、时钟域和通信接口。

## 章节列表

| # | 章节 | 要点 | 示例 |
|---|------|------|------|
| 01 | [Finite_State_Machine](01_Finite_State_Machine/) | Moore/Mealy FSM、编码方式 | 交通灯 / 序列检测器 |
| 02 | [Memory_Design](02_Memory_Design/) | Verilog 实现 RAM/ROM/FIFO | 单端口 RAM / 双端口 RAM / 异步 FIFO |
| 03 | [Clock_Domain](03_Clock_Domain/) | 分频器、同步器、跨时钟域处理 | 分频器 / 2 级同步器 |
| 04 | [Communication_Interface](04_Communication_Interface/) | UART/SPI/I2C 协议 | UART 收发 / SPI 主机 / I2C 主机 |

## 为什么这些是核心？

- **状态机**：FPGA 中所有控制逻辑的骨架
- **存储器**：数据缓冲、查找表、队列 — 无处不在
- **时钟域**：多时钟系统非常常见；处理不当会导致亚稳态
- **通信接口**：与外部芯片通信的必备技能

## 设计原则

```
1. 状态机: 用 parameter 常量进行状态编码（One-Hot 或二进制）
2. 存储器: 用 reg 数组或厂商 Block RAM IP
3. 时钟域: 跨时钟域数据必须同步 — 永远不要直接采样
4. 通信接口: 先画时序图，再写代码
```

## 学完本章节后

✅ 能设计任意复杂度的状态机
✅ 能实现各种存储结构
✅ 能正确处理跨时钟域数据传输
✅ 能从零实现 UART/SPI/I2C
