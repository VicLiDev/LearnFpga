# 01_Combinational_Logic — 组合逻辑

## 什么是组合逻辑？

组合逻辑的输出**仅取决于当前输入**，没有记忆功能，不需要时钟。

```
输入 ──→ [组合逻辑电路] ──→ 输出
  │                          │
  └── 输出 = f(当前输入)       └── 没有时钟，没有状态
```

## 常见组合逻辑电路

| 电路 | 功能 | 典型应用 |
|------|------|----------|
| 编码器 | 多输入 → 少输出编码 | 中断控制器 |
| 译码器 | 少输入 → 多输出选择 | 地址译码 |
| 多路选择器 MUX | 从多路输入中选一路 | 数据通路 |
| 加法器 | 二进制加法 | ALU 核心 |
| 比较器 | 大小/相等比较 | 条件判断 |
| ALU | 多种运算 | CPU 数据通路 |

## Verilog 编写组合逻辑的 3 种方式

```verilog
// 方式1: assign 语句 (适合简单逻辑)
assign y = (a & b) | c;

// 方式2: always @(*) + if-else (适合有优先级的逻辑)
always @(*) begin
    if (sel) y = d1; else y = d0;
end

// 方式3: always @(*) + case (适合多路选择)
always @(*) begin
    case (sel)
        2'b00: y = d0;
        2'b01: y = d1;
        // ...
    endcase
end
```

## ⚠️ Latch 警告

组合逻辑的 always 块必须覆盖所有输入条件，否则综合工具会推断出 **latch**（锁存器），这是组合逻辑设计中常见的 bug：

```verilog
// ❌ 错误: 产生 latch (没有 else 分支)
always @(*) begin
    if (sel)
        y = d1;
    // sel=0 时 y 保持旧值 → latch!
end

// ✅ 正确: 覆盖所有条件
always @(*) begin
    if (sel)
        y = d1;
    else
        y = d0;
    // 或者加上 default
end
```

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_half_adder.v` | 半加器 — 最基本的加法 |
| `02_full_adder.v` | 全加器 — 考虑进位的加法 |
| `03_ripple_carry_adder.v` | 行波进位加法器 — 多位加法 |
| `04_alu.v` | 简易 ALU — 多种运算单元 |
