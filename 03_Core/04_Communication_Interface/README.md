# 04_Communication_Interface — 通信接口

## 常见通信协议对比

| 协议 | 线数 | 速度 | 方式 | 典型应用 |
|------|------|------|------|----------|
| **UART** | 2 (TX+RX) | 115.2K~1Mbps | 异步, 点对点 | 串口调试, GPS, 蓝牙模块 |
| **SPI** | 4 (SCK+MOSI+MISO+CS) | 1~50MHz | 同步, 主从 | Flash, ADC, 屏幕驱动 |
| **I2C** | 2 (SCL+SDA) | 100K~3.4Mbps | 同步, 多主多从 | 传感器, EEPROM, RTC |

## UART 协议详解

```
空闲 (高电平) → 起始位(0) → 8位数据 [LSB first] → 校验位(可选) → 停止位(1) → ...

波特率: 9600, 19200, 38400, 57600, 115200, ...
帧格式: 1 起始位 + 8 数据位 + N 停止位 (N=1 或 2)

时间线 (115200, 8N1):
  |--- 起始 ---|--- b0 ---|--- b1 ---| ... |--- b7 ---|--- 停止 ---|
  |  8.68us   |  8.68us  |  8.68us  |     |  8.68us  |  8.68us   |

每个 bit 的持续时间 = 1 / 波特率
115200 bps → 1 bit ≈ 8.68μs
```

## SPI 协议详解

```
Master                    Slave
  MOSI ──────────────────→ MOSI   (主出从入)
  MISO ←────────────────── MISO   (主入从出)
  SCK  ──────────────────→ SCK    (时钟, 主机产生)
  CS#  ──────────────────→ CS#    (片选, 低电平有效)

时序模式 (CPOL, CPHA):
  Mode 0: CPOL=0, CPHA=0 → SCK 空闲低, 上升沿采样 (最常用)
  Mode 1: CPOL=0, CPHA=1 → SCK 空闲低, 下降沿采样
  Mode 2: CPOL=1, CPHA=0 → SCK 空闲高, 下降沿采样
  Mode 3: CPOL=1, CPHA=1 → SCK 空闲高, 上升沿采样
```

## I2C 协议详解

```
SDA: 数据线 (双向, 开漏)
SCL: 时钟线 (双向, 开漏)

帧格式:
  [START][7-bit Addr][R/W][ACK][Data0][ACK]...[DataN][ACK/NAK][STOP]

START:  SCL=1 时, SDA 从高变低
STOP:   SCL=1 时, SDA 从低变高
ACK:    接收方拉低 SDA (应答)
NAK:    接收方释放 SDA (非应答)
地址:   7 位地址 + R/W 位 = 8 位
```

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_uart_tx.v` | UART 发送器 |
| `02_uart_rx.v` | UART 接收器 |
| `03_spi_master.v` | SPI 主机 (Mode 0) |
| `04_i2c_master.v` | I2C 主机 (读写操作) |
