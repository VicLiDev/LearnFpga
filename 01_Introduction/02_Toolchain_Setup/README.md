# 02_Toolchain_Setup — 开发环境搭建

## FPGA 开发全景

一个完整的 FPGA 项目需要三类核心要素：**硬件描述语言**、**开发工具链**和**仿真验证环境**。

### 一、硬件描述语言

#### 传统 HDL（行业主流）

| 语言              | 特点                                   | 使用率   | 适用场景             |
|-------------------|----------------------------------------|----------|----------------------|
| **Verilog**       | 语法类似 C，上手快，生态最广           | ~60%     | 本项目采用，入门首选 |
| **SystemVerilog** | Verilog 超集，支持面向对象和验证方法学 | ~25%     | 大型项目、UVM 验证   |
| **VHDL**          | 语法严格，类型安全，强契约             | ~15%     | 航空航天、欧洲市场   |

#### 新一代 HDL（新兴趋势）

| 语言                     | 基于语言   | 特点                                                          | 状态                    |
|--------------------------|------------|---------------------------------------------------------------|-------------------------|
| **Chisel**               | Scala      | 硬件构造语言，UC Berkeley/RISC-V 社区广泛使用，生态最丰富     | 成熟，学术/开源芯片首选 |
| **SpinalHDL**            | Scala      | 类 Chisel 但更强类型，用于多个知名 RISC-V 核                  | 活跃开发中              |
| **Amaranth (原 nMigen)** | Python     | 开源工具链，语法简洁，对软件工程师最友好，搭配 F4PGA 开源流程 | 活跃开发中              |
| **Clash**                | Haskell    | 函数式硬件描述，纯函数语义                                    | 小众但活跃              |

> **当前现状**：Verilog/VHDL 仍是工业界绝对主流。新一代 HDL 在 RISC-V 和开源硬件社区快速普及，但尚未大规模进入传统 FPGA 企业。

### 二、综合与实现工具链

#### 商用工具（主流选择）

| 工具                     | 厂商                   | 支持 FPGA                | 最新版本   | 操作系统       | 备注                            |
|--------------------------|------------------------|--------------------------|------------|----------------|---------------------------------|
| **Vivado**               | AMD (Xilinx)           | 7 系列、UltraScale、Zynq | 2025.2     | Windows、Linux | 最常用，推荐                    |
| **Vivado ML Edition**    | AMD (Xilinx)           | Versal (ACAP)            | 2025.2     | Windows、Linux | 新一代自适应计算平台            |
| **Quartus Prime**        | Altera (原 Intel FPGA) | Cyclone、Stratix、Agilex | 25.3       | Windows、Linux | Intel 已将 FPGA 品牌回归 Altera |
| **Lattice Radiant**      | Lattice                | Avant-G、Nexus           | 2025.1     | Windows、Linux | 新架构专用                      |
| **Lattice Diamond**      | Lattice                | MachXO2/3、iCE40         | 持续维护   | Windows、Linux | 成熟产品线，低功耗              |
| **云源软件 (Gowin EDA)** | 高云半导体             | GW1N/GW2A/GW3S/Arora     | 持续更新   | Windows、Linux | 国产 FPGA，自主可控             |
| **Tangent IDE**          | 安路科技               | Eagle、ELF、PH1P         | 持续更新   | Windows、Linux | 国产 FPGA，出货量最大           |

#### 开源工具链（完整替代方案）

```
HDL 源码 (Verilog/SystemVerilog)
        │
        ▼
    ┌─────────┐
    │  Yosys  │  ← 综合 (HDL → 网表)
    └────┬────┘
         ▼
    ┌──────────┐
    │  nextpnr │  ← 布局布线 (网表 → 物理布局)
    └────┬─────┘
         ▼
    ┌─────────────────────┐
    │ icestorm/prjtrellis │  ← 比特流生成
    └─────────────────────┘
         ▼
    烧录到 FPGA
```

| 工具                     | 功能                           | 支持 FPGA 系列     |
|--------------------------|--------------------------------|--------------------|
| **Yosys**                | 综合工具，将 HDL 转为网表      | 通用               |
| **nextpnr**              | 布局布线，将网表映射到物理单元 | iCE40、ECP5、Nexus |
| **Project IceStorm**     | iCE40 比特流生成               | Lattice iCE40      |
| **prjtrellis**           | ECP5 比特流生成                | Lattice ECP5       |
| **F4PGA (原 Symbiflow)** | 完整开源 FPGA 工具链框架       | 多系列             |
| **apicula**              | 高云 FPGA 比特流生成           | Gowin GW2/GW5      |
| **FuseSoC**              | IP 包管理与构建系统            | 通用               |

> **注意**：开源工具链目前对 Lattice iCE40 和 ECP5 支持最完善。对 Xilinx/Altera 等商业 FPGA 的支持仍在快速发展中（如 XRay/Symbiflow 项目）。

### 三、仿真与验证工具

| 工具                          | 类型            | 特点                                                       | 适用场景                     |
|-------------------------------|-----------------|------------------------------------------------------------|------------------------------|
| **iverilog (Icarus Verilog)** | 开源仿真器      | 轻量、兼容性好、安装简单，本项目使用                       | 学习入门、快速验证           |
| **Verilator**                 | 开源仿真器      | 编译型仿真（Verilog→C++），**速度最快**，大规模设计首选    | 大型设计、开源芯片项目       |
| **cocotb**                    | Python 验证框架 | 不独立仿真，通过 VPI 调用仿真器，用 Python 编写 testbench  | Python 生态驱动验证          |
| **ModelSim**                  | 商用仿真器      | 功能最全，支持 VHDL+Verilog 混合仿真，波形/覆盖率/调试完备 | 企业级项目                   |
| **Vivado xsim**               | 商用仿真器      | Vivado 自带，与 Vivado 深度集成                            | 入门够用                     |
| **QuestaSim**                 | 商用仿真器      | Siemens EDA 旗舰，企业级验证平台                           | 大型商业项目                 |
| **GTKWave**                   | 波形查看器      | 开源免费，查看 VCD/FST 波形文件                            | 搭配 iverilog/Verilator 使用 |

> **2025-2026 社区趋势**：`Verilator + cocotb` 组合成为开源验证的主流方案——Verilator 提供极致仿真性能，cocotb 提供 Python 生态的灵活验证。

### 四、开发环境选择

#### 按学习阶段推荐

| 阶段           | 推荐组合                    | 理由                                    |
|----------------|-----------------------------|-----------------------------------------|
| **入门学习**   | iverilog + GTKWave          | 本项目采用，安装简单，一行命令编译仿真  |
| **进阶实践**   | Vivado + xsim               | 综合+仿真+烧录全流程，支持实际开发板    |
| **开源爱好者** | Yosys + nextpnr + Verilator | 全开源工具链，搭配 Lattice iCE40 开发板 |

#### 按开发板推荐工具

| 开发板             | FPGA    | 推荐工具链                 |
|--------------------|---------|----------------------------|
| Nexys A7 / Basys 3 | Artix-7 | Vivado                     |
| Zynq Z7010 开发板  | Zynq    | Vivado + Vitis             |
| Cyclone IV 开发板  | EP4CE6  | Quartus Prime              |
| Tang Nano          | GW1N    | 云源软件 (Gowin EDA)       |
| iCEBreaker         | iCE40   | Yosys + nextpnr + IceStorm |
| TinyFPGA BX        | iCE40   | Yosys + nextpnr + IceStorm |

#### 按国产化需求推荐

| 厂商           | 工具               | 代表产品              | 适用领域                     |
|----------------|--------------------|-----------------------|------------------------------|
| **安路科技**   | Tangent IDE        | ELF3/ELF5、飞龙 SoC   | 工业控制、LED 显示、国产替代 |
| **高云半导体** | 云源软件           | Arora V、GW3S、车规级 | 消费电子、汽车电子           |
| **紫光同创**   | Pango Design Suite | Titan、Logos          | 通信、国防                   |
| **复旦微电**   | Procise IDE        | JFM 系列              | 军工、航天                   |

## Vivado 安装指南（推荐）

### 系统要求
- **磁盘**: 30~50 GB（完全安装）
- **内存**: ≥ 8 GB（推荐 16 GB）
- **OS**: Windows 10/11 或 Ubuntu 20.04+

### 安装步骤

```bash
# 1. 下载 (需要注册 AMD/Xilinx 账号)
#    https://www.amd.com/en/support/downloads/adaptive-socs-and-fpgas/development-tools.html

# 2. 安装 (Windows 运行 xsetup.exe, Linux:)
chmod +x Xilinx_Unified_2024*_Lin64.bin
./Xilinx_Unified_2024*_Lin64.bin

# 3. 安装选项
#    - Vivado Design Suite (必选)
#    - Devices: 选择你开发板对应的 FPGA 系列 (如 7 Series)
#    - 不要安装所有设备, 太大了

# 4. 安装 cable driver (用于下载到开发板)
# Linux:
cd ~/.Xilinx/xilinx vivado-2024.x/data/xicom/cable_drivers/lin64/install_script/install_drivers/
sudo ./install_drivers
# Windows: Vivado 安装时自动安装
```

### Vivado 工程创建

```
1. 打开 Vivado → Create Project
2. Project Name: my_first_project
3. Project Location: 选择你的工作目录
4. Project Type: RTL Project
5. Add Sources:
   - Add or create design sources → 添加 .v 文件
   - Add or create constraints → 添加 .xdc 文件 (引脚约束)
6. Parts: 选择开发板的 FPGA 型号
   - 例如: xc7a35tcpg236-1 (Artix-7)
   - 提示: 如果用开发板, 可以选 "Boards" 标签页直接选板子
7. Finish
```

### Vivado 基本流程

```
编写 Verilog (.v)
       │
       ▼
  Run Synthesis (综合)
       │   ──→ 查看综合报告 (资源使用)
       ▼
  Run Implementation (实现)
       │   ──→ 包含: Optimize → Place → Route
       ▼
  Generate Bitstream (生成比特流)
       │
       ▼
  Open Hardware Manager → Program Device (下载到 FPGA)
```

## Quartus Prime 安装指南（Altera FPGA）

### 安装步骤
1. 下载: https://www.altera.com/downloads/fpga-development-tools.html
2. 选择 Lite 版本（免费）或 Pro（付费）
3. 安装时选择目标器件系列

> **注意**: 2025 年起 Intel 将 FPGA 品牌回归 **Altera**，工具仍为 Quartus Prime。

## 仿真工具安装

### Icarus Verilog + GTKWave（本项目使用）

```bash
# Ubuntu/Debian
sudo apt install iverilog gtkwave

# macOS
brew install icarus-verilog gtkwave

# 编译 & 仿真
iverilog -o tb led_blink.v led_blink_tb.v   # 编译
vvp tb                                       # 运行仿真
gtkwave tb.vcd                               # 查看波形
```

### Verilator（高性能仿真）

```bash
# Ubuntu/Debian
sudo apt install verilator

# 编译为 C++ 并执行
verilator --cc --exe --build -j 0 tb.cpp top.v
obj_dir/Vtb
```

### cocotb + Python 验证

```bash
# 安装
pip install cocotb

# 使用 pytest 并行运行多个测试
pip install cocotb pytest pytest-xdist
```

## 推荐开发板

| 开发板 | FPGA | 价格区间 | 适合阶段 |
|--------|------|----------|----------|
| Nexys A7 (Digilent) | Artix-7 XC7A100T | ¥2000+ | 入门~进阶 |
| Basys 3 (Digilent) | Artix-7 XC7A35T | ¥800+ | 入门~核心 |
| Zynq Z7010 开发板 | Zynq xc7z010 | ¥500+ | 全阶段(带ARM) |
| Cyclone IV 开发板 | EP4CE6 | ¥200+ | 入门(性价比) |
| Tang Nano | 高云 GW1N | ¥30+ | 入门(超低价) |
| iCEBreaker | iCE40HX8K | ¥100+ | 入门(开源工具链) |

## 下一步

完成环境搭建后，进入 [03_HDL_Basics](../03_HDL_Basics/) 学习 Verilog 语法。
