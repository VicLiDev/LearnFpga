# FPGA 从入门到进阶 — Learn FPGA Step by Step

> 系统化 FPGA 学习路径：Verilog HDL、数字逻辑设计、核心电路、高级应用与工程优化。

## 学习路线

```
01 入门 ──→ 02 基础 ──→ 03 核心 ──→ 04 进阶 ──→ 05 精通
      │          │           │           │           │
   什么是FPGA  组合逻辑   状态机      DSP设计     验证方法
   工具安装    时序逻辑   存储器      图像处理     时序约束
   HDL基础     数据类型    时钟域      IP核        设计优化
              模块化设计  通信接口
```

## 目录结构

### 📗 01_Introduction — 入门篇
| 章节                                                      | 内容                                             | 难度   |
|-----------------------------------------------------------|--------------------------------------------------|--------|
| [01_What_Is_FPGA](01_Introduction/01_What_Is_FPGA/)       | 架构原理、LUT/FF、FPGA vs CPU/ASIC、LED 闪烁示例 | ⭐     |
| [02_Toolchain_Setup](01_Introduction/02_Toolchain_Setup/) | Vivado / Quartus 安装与工程创建指南              | ⭐     |
| [03_HDL_Basics](01_Introduction/03_HDL_Basics/)           | Verilog 语法、门电路、多路选择器、译码器         | ⭐⭐   |

### 📘 02_Basics — 基础篇
| 章节                                                        | 内容                            | 难度   |
|-------------------------------------------------------------|---------------------------------|--------|
| [01_Combinational_Logic](02_Basics/01_Combinational_Logic/) | 编码器、多路选择器、ALU、加法器 | ⭐⭐   |
| [02_Sequential_Logic](02_Basics/02_Sequential_Logic/)       | D 触发器、计数器、移位寄存器    | ⭐⭐⭐ |
| [03_Data_Types](02_Basics/03_Data_Types/)                   | wire/reg、有符号运算、状态编码  | ⭐⭐   |
| [04_Modular_Design](02_Basics/04_Modular_Design/)           | 模块实例化、参数化设计          | ⭐⭐⭐ |

### 📙 03_Core — 核心篇
| 章节                                                              | 内容                                   | 难度     |
|-------------------------------------------------------------------|----------------------------------------|----------|
| [01_Finite_State_Machine](03_Core/01_Finite_State_Machine/)       | Moore/Mealy 状态机、交通灯、序列检测器 | ⭐⭐⭐   |
| [02_Memory_Design](03_Core/02_Memory_Design/)                     | 单/双端口 RAM、ROM、异步 FIFO          | ⭐⭐⭐⭐ |
| [03_Clock_Domain](03_Core/03_Clock_Domain/)                       | 分频器、同步器、跨时钟域基础           | ⭐⭐⭐⭐ |
| [04_Communication_Interface](03_Core/04_Communication_Interface/) | UART、SPI、I2C 协议实现                | ⭐⭐⭐⭐ |

### 📕 04_Advanced — 进阶篇
| 章节                                                    | 内容                             | 难度     |
|---------------------------------------------------------|----------------------------------|----------|
| [01_DSP_Design](04_Advanced/01_DSP_Design/)             | FIR 滤波器、FFT 蝶形运算、乘法器 | ⭐⭐⭐⭐ |
| [02_Image_Processing](04_Advanced/02_Image_Processing/) | 灰度转换、Sobel 边缘检测、行缓冲 | ⭐⭐⭐⭐ |
| [03_IP_Core](04_Advanced/03_IP_Core/)                   | BRAM、FIFO IP、PLL IP 使用示例   | ⭐⭐⭐   |

### 📓 05_Expert — 精通篇
| 章节                                                                  | 内容                             | 难度       |
|-----------------------------------------------------------------------|----------------------------------|------------|
| [01_Verification_Methodology](05_Expert/01_Verification_Methodology/) | 测试激励、自校验测试、覆盖率     | ⭐⭐⭐⭐   |
| [02_Timing_Constraints](05_Expert/02_Timing_Constraints/)             | SDC/XDC 基础、时钟约束、I/O 约束 | ⭐⭐⭐⭐⭐ |
| [03_Design_Optimization](05_Expert/03_Design_Optimization/)           | 流水线、资源复用、重定时         | ⭐⭐⭐⭐⭐ |

## 语言

所有示例均使用 **Verilog (IEEE 1364-2001)** 编写，以获得最佳工具兼容性。

## 快速开始 — 软件安装

每个示例目录下都有 `prjBuild.sh` 用于编译、仿真和查看波形。只需安装两个软件包：

```bash
sudo apt install iverilog gtkwave
```

| 工具         | 用途                                                |
|--------------|-----------------------------------------------------|
| **iverilog** | Verilog 编译器 — 将 `.v` 源文件编译为仿真可执行文件 |
| **gtkwave**  | 波形查看器 — 打开 `.vcd` 文件查看信号时序           |

安装完成后即可运行任意示例：

```bash
cd 01_Introduction/01_What_Is_FPGA
./prjBuild.sh wave   # 编译 → 仿真 → 打开波形
```

> `prjBuild.sh` 支持四个命令：`run`（编译 + 仿真）、`build`（仅编译）、`wave`（编译 + 仿真 + 打开 GTKWave）、`clean`（清理输出）。

### 可选工具（用于综合与烧录）

| 软件        | 厂商           | 说明                                                                                                                                                                   |
|-------------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Yosys**   | 开源           | FPGA 综合工具（`sudo apt install yosys`）                                                                                                                              |
| **Vivado**  | Xilinx         | 全功能 IDE，适用于 Zynq / Artix-7 开发板 — 从 [Xilinx](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools.html) 下载 |
| **Quartus** | Intel (Altera) | 全功能 IDE，适用于 Cyclone IV — 从 [Intel FPGA](https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime.html) 下载               |

## 推荐开发板

| 开发板            | FPGA 型号       | 厂商   | 适用阶段       |
|-------------------|-----------------|--------|----------------|
| Zynq Z7010        | xc7z010clg400-1 | Xilinx | 全阶段（推荐） |
| Cyclone IV EP4CE6 | EP4CE6F17C8     | Intel  | 入门 ~ 核心    |
| Artix-7 XC7A35T   | XC7A35TFTG256-1 | Xilinx | 核心 ~ 进阶    |

## 许可证

MIT License
