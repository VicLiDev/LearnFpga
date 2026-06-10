# 02_Toolchain_Setup — 开发环境搭建

## 主流 FPGA 工具链

| 工具 | 厂商 | 支持 FPGA | 操作系统 | 备注 |
|------|------|-----------|----------|------|
| **Vivado** | Xilinx (AMD) | 7 系列, UltraScale, Zynq | Windows, Linux | 最常用，推荐 |
| **Vivado ML Edition** | Xilinx (AMD) | Versal (ACAP) | Windows, Linux | 新一代 |
| **Quartus Prime** | Intel (Altera) | Cyclone, Stratix, Arria | Windows, Linux | Intel FPGA |
| **Diamond** | Lattice | iCE40, ECP, MachXO | Windows, Linux | 低功耗 FPGA |
| **gowin EDA** | 高云 | GW2/GW5 系列 | Windows, Linux | 国产 FPGA |
| **Tang Dynasty** | 唐都 | AGM 系列 | Windows | 国产 FPGA |

## Vivado 安装指南（推荐）

### 系统要求
- **磁盘**: 30~50 GB（完全安装）
- **内存**: ≥ 8 GB（推荐 16 GB）
- **OS**: Windows 10/11 或 Ubuntu 20.04+

### 安装步骤

```bash
# 1. 下载 (需要注册 Xilinx 账号)
#    https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools.html

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

## Quartus Prime 安装指南（Intel FPGA）

### 安装步骤
1. 下载: https://www.intel.com/content/www/us/en/programmable/downloads.html
2. 选择 Lite 版本（免费）或 Standard/Pro（付费）
3. 安装时选择目标器件系列

## 仿真工具

| 工具 | 说明 | 推荐 |
|------|------|------|
| Vivado Simulator (xsim) | Vivado 自带, 入门够用 | ⭐⭐⭐ |
| ModelSim | 独立仿真器, 功能更强大 | ⭐⭐⭐⭐ |
| Icarus Verilog | 开源仿真器, 轻量级 | ⭐⭐ |
| Verilator | 开源, 速度极快 | ⭐⭐⭐⭐ |

### Icarus Verilog 安装（轻量级选择）

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

## 推荐开发板

| 开发板 | FPGA | 价格区间 | 适合阶段 |
|--------|------|----------|----------|
| Nexys A7 (Digilent) | Artix-7 XC7A100T | ¥2000+ | 入门~进阶 |
| Basys 3 (Digilent) | Artix-7 XC7A35T | ¥800+ | 入门~核心 |
| Zynq Z7010 开发板 | Zynq xc7z010 | ¥500+ | 全阶段(带ARM) |
| Cyclone IV 开发板 | EP4CE6 | ¥200+ | 入门(性价比) |
| iCE40HX8K 开发板 | iCE40HX8K | ¥100+ | 入门(开源工具链) |

## 下一步

完成环境搭建后，进入 [03_HDL_Basics](../03_HDL_Basics/) 学习 Verilog 语法。
