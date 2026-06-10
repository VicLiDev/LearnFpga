# 04_Modular_Design — 模块化设计

## 为什么需要模块化？

真实 FPGA 项目通常包含成千上万行代码，全部写在一个文件里是不现实的。模块化设计将复杂系统分解为小模块，类似软件工程中的函数/类。

## 层次化设计

```
top_module (顶层)
  ├── sub_module_a
  │     ├── sub_a_1
  │     └── sub_a_2
  ├── sub_module_b
  └── sub_module_c
```

## 模块例化 (Module Instantiation)

### 方式1: 按端口名连接（推荐）
```verilog
full_adder fa0 (
    .a   (a[0]),
    .b   (b[0]),
    .cin (cin),
    .sum (sum[0]),
    .cout(c1)
);
```

### 方式2: 按端口顺序连接（不推荐，容易出错）
```verilog
full_adder fa0 (a[0], b[0], cin, sum[0], c1);
```

> **永远推荐按端口名连接！** 顺序不重要，可读性好，不易出错。

## 参数化设计

使用 `parameter` 使模块可重用：

```verilog
module adder #(parameter WIDTH = 8) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH:0]   sum
);
    assign sum = a + b;
endmodule

// 例化时修改参数
adder #(.WIDTH(16)) u_adder16 (
    .a(a), .b(b), .sum(sum)
);
```

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_full_adder.v` | 全加器（子模块） |
| `02_4bit_adder.v` | 4 位加法器（顶层，例化全加器） |
| `03_param_counter.v` | 参数化计数器 |
| `04_button_led_top.v` | 按键控制 LED（完整小工程） |
