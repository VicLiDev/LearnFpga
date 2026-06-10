# 01_Verification_Methodology — 验证方法论

## 为什么验证如此重要？

业界统计：**70% 的芯片 bug 来自验证不足，而非设计错误。**

```
验证金字塔:
                    ┌───┐
                   │检查 │     少量, 复杂
                  │ 表格  │
                │ 形式验证 │
               │   /  │
              │ 随机测试 │
             │ /      │
            │ 功能仿真 │    大量, 基础
           └──────────┘
```

## Testbench 编写规范

### 基本结构
```verilog
module tb;
    // 1. 信号声明
    reg  clk;
    wire [7:0] data;

    // 2. 例化被测模块 (DUT)
    dut u_dut (.clk(clk), .data(data));

    // 3. 时钟生成
    initial clk = 0;
    always #5 clk = ~clk;

    // 4. 测试激励
    initial begin
        // ...
        $finish;
    end

    // 5. 波形转储
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end
endmodule
```

### 最佳实践
1. **自校验**: Testbench 自动判断对错，不要人眼看波形
2. **覆盖率**: 确保所有状态/分支/条件都被测试到
3. **边界测试**: 全0、全1、随机值
4. **独立可重复**: 每次运行结果一致

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_tb_basic.v` | 基础 Testbench 模板 |
| `02_tb_self_checking.v` | 自校验 Testbench |
| `03_tb_coverage.v` | 简易功能覆盖率框架 |
