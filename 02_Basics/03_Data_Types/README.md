# 03_Data_Types — 数据类型与运算

## Verilog 核心数据类型

### wire 和 reg

| 类型 | 特点 | 赋值方式 | 硬件映射 |
|------|------|----------|----------|
| `wire` | 连线型, 不能在 always 块中赋值 | `assign` | 物理连线 |
| `reg` | 寄存器型, 可在 always 块中赋值 | `<=` 或 `=` | 触发器或组合逻辑 |

> **注意**: `reg` 不一定映射为触发器！在 `always @(*)` 中的 reg 实际映射为组合逻辑（latch 除外）。

### 向量声明

```verilog
wire [7:0] data_bus;     // 8 位 wire, 高位 data_bus[7], 低位 data_bus[0]
reg  [15:0] counter;     // 16 位 reg
reg  [31:0] data [0:7];  // 8 个 32 位的存储器数组 (用于 RAM/ROM)
```

### 整数与参数

```verilog
parameter WIDTH = 8;              // 常量参数 (编译时确定)
localparam DEPTH = 256;            // 局部参数 (不可从外部修改)
integer i;                         // 32 位整数 (仅用于仿真)
```

## 有符号运算

```verilog
reg signed [7:0] a, b;            // 有符号数
reg signed [15:0] result;

always @(*) begin
    result = a * b;               // 有符号乘法
end
```

### 运算符优先级（从高到低）

```
!  ~  -  (单目)       // 逻辑非, 按位取反, 负号
*  /  %                // 乘, 除, 取模
+  -                   // 加, 减
<<  >>                 // 左移, 右移 (逻辑)
<<<  >>>               // 左移, 右移 (算术)
<  <=  >  >=           // 比较
==  !=  ===  !==       // 等于, 不等, 全等, 非全等
&                      // 按位与
^  ^~                  // 按位异或, 按位异或非
|                      // 按位或
&&                     // 逻辑与
||                     // 逻辑或
?:                     // 条件运算符
```

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_data_types.v` | wire/reg/vector/parameter 演示 |
| `02_signed_arithmetic.v` | 有符号数运算 |
| `03_operator_demo.v` | 运算符优先级演示 |
