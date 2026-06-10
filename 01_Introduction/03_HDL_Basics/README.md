# 03_HDL_Basics — HDL 语言基础

## 什么是 HDL？

**HDL (Hardware Description Language)** — 硬件描述语言，用于描述数字电路的行为和结构。

两大主流 HDL：
| 语言 | 特点 | 使用率 |
|------|------|--------|
| **Verilog** | 语法类似 C，上手快 | ~60% |
| **VHDL** | 语法严格，类型安全 | ~35% |

本项目使用 **Verilog**，因为：
- 语法简单，学习曲线平缓
- 社区资源丰富
- 工具兼容性好

## Verilog 基本结构

```verilog
module 模块名 (端口列表);
    // 端口声明
    input  wire a;
    output reg  y;

    // 逻辑描述
    always @(...) begin
        ...
    end
endmodule
```

## 核心语法要点

### 1. 端口声明
```verilog
input  wire [7:0] data_in;   // 8位输入, wire 类型
output reg  [7:0] data_out;  // 8位输出, reg 类型
inout  wire [7:0] data_bus;  // 8位双向
```

### 2. wire vs reg
| 类型 | 赋值方式 | 对应硬件 |
|------|----------|----------|
| `wire` | 连续赋值 `assign` | 连线、组合逻辑 |
| `reg` | 过程赋值 `always` | 寄存器、组合/时序逻辑 |

### 3. always 块的两种风格
```verilog
// 组合逻辑: 电平敏感
always @(*) begin  // 或 always @(a, b)
    y = a & b;
end

// 时序逻辑: 边沿敏感
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        y <= 0;
    else
        y <= a & b;
end
```

### 4. 阻塞赋值 vs 非阻塞赋值
| 赋值 | 符号 | 用途 |
|------|------|------|
| 阻塞 `=` | 顺序执行 | 组合逻辑 (always @(*)) |
| 非阻塞 `<=` | 并行执行 | 时序逻辑 (always @(posedge clk)) |

> **黄金法则**: 组合逻辑用 `=`, 时序逻辑用 `<=`，永远不要混用！

## Demo 文件

| 文件 | 内容 | 说明 |
|------|------|------|
| `01_basic_gates.v` | AND/OR/NOT/XOR/NAND 门 | 最基本的逻辑门 |
| `02_mux.v` | 2选1 / 4选1 多路选择器 | 组合逻辑经典 |
| `03_decoder.v` | 3-8 译码器 | 一对多的地址译码 |
| `04_encoder.v` | 8-3 优先编码器 | 多对一的编码 |
