# 02_Timing_Constraints — 时序约束

## 什么是时序约束？

时序约束告诉综合/布线工具你的设计需要满足的时序要求。没有约束，工具会尽可能快地布线，但不会检查是否满足建立/保持时间。

## 核心概念

### 建立时间 (Setup Time) 和保持时间 (Hold Time)

```
                    ┌───┐
           ────────│   │───────
    Data ──X───X────│ D │
              ↑     │   │──────→ Q (下一周期)
          t_su      │>  │
                    └───┘
          ◄──────►
         Setup Time  数据必须在时钟沿之前稳定 t_su 时间

                    ┌───┐
           ────────│   │───────
    Data ──X────────│ D │──────→
          │         │>  │
          │         └───┘
          t_h              ◄──► Hold Time
                               数据必须在时钟沿之后稳定 t_h 时间
```

### 时序路径

```
Source Clock       Destination Clock
    |                    |
    v                    v
[FF1]───[组合逻辑]───→[FF2]
  |                      |
  Launch                Capture
  FF                    FF

时序分析:
  T_data_max = T_clk - T_setup - T_skew
  即: 组合逻辑的最大延迟 < 时钟周期 - 建立时间 - 时钟偏斜
```

## SDC/XDC 常用约束

### XDC (Xilinx Design Constraints) 语法

```tcl
# 1. 主时钟
create_clock -period 10.000 -name sys_clk [get_ports clk]

# 2. 时钟周期: 10ns = 100MHz

# 3. 派生时钟 (PLL/MMCM 输出)
create_generated_clock -name clk_100m -source [get_pins pll/clk_in1] \
    -divide_by 1 [get_pins pll/clk_out1]

# 4. 输入延迟 (芯片外到 FF 的延迟)
set_input_delay -clock sys_clk -max 2.0 [get_ports data_in]

# 5. 输出延迟 (FF 到芯片外的延迟)
set_output_delay -clock sys_clk -max 3.0 [get_ports data_out]

# 6. 虚假路径 (不做时序分析的路径)
set_false_path -from [get_pins rst_reg/C]

# 7. 多周期路径 (允许超过 1 个周期)
set_multicycle_path 2 -setup -from [get_pins reg_a/Q] -to [get_pins reg_b/D]
```

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_basic_constraints.xdc` | 基础约束模板 (时钟 + IO) |
| `02_advanced_constraints.xdc` | 进阶约束 (多周期路径 + 虚假路径) |
