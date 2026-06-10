# 01_basic_constraints.xdc
# 基础时序约束模板
#
# 适用: Xilinx 7 系列 FPGA (Artix-7, Kintex-7, Zynq)
# 工具: Vivado
#
# 使用方法: 将此文件添加到 Vivado 工程的 Constraints 源中

#=============================================================================================
# 1. 时钟约束
#=============================================================================================

# 主时钟: 50MHz, 连接到 FPGA 的 clk 引脚
# -period 10.000 = 10ns 周期 = 100MHz
# 注意: [get_ports clk] 中的 clk 是顶层模块的端口名, 需要和代码一致
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]

#=============================================================================================
# 2. IO 约束 (引脚分配)
#=============================================================================================

# 这些约束将顶层端口映射到 FPGA 物理引脚
# 具体引脚号需要查阅开发板原理图或用户手册

## 时钟引脚
# set_property PACKAGE_PIN E3 [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]

## LED 引脚
# set_property PACKAGE_PIN H17 [get_ports {led[0]}]
# set_property PACKAGE_PIN K15 [get_ports {led[1]}]
# set_property PACKAGE_PIN J13 [get_ports {led[2]}]
# set_property PACKAGE_PIN N14 [get_ports {led[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports led]

## 按键引脚
# set_property PACKAGE_PIN D18 [get_ports {btn[0]}]
# set_property PACKAGE_PIN P16 [get_ports {btn[1]}]
# set_property PACKAGE_PIN V2  [get_ports {btn[2]}]
# set_property IOSTANDARD LVCMOS33 [get_ports btn]

## UART 引脚
# set_property PACKAGE_PIN D10 [get_ports uart_tx]
# set_property PACKAGE_PIN A9  [get_ports uart_rx]
# set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
# set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]

#=============================================================================================
# 3. 输入/输出延迟约束
#=============================================================================================

# 输入延迟: 外部芯片到 FPGA 输入引脚的延迟
# 假设外部器件在时钟上升沿后最多 2ns 输出数据
set_input_delay -clock sys_clk -max 2.000 [get_ports data_in]
set_input_delay -clock sys_clk -min 0.500 [get_ports data_in]

# 输出延迟: FPGA 输出引脚到外部器件的建立时间
# 假设外部器件需要至少 3ns 的建立时间
# set_output_delay -clock sys_clk -max 3.000 [get_ports data_out]

#=============================================================================================
# 4. 复位信号的虚假路径
#=============================================================================================

# 复位信号是异步的, 不需要做时序分析
# set_false_path -from [get_ports rst_n]

#=============================================================================================
# 5. 未约束路径警告抑制 (可选)
#=============================================================================================

# 如果确认某些路径不需要约束, 可以抑制 warning
# set_false_path -to [get_ports unused_port]
