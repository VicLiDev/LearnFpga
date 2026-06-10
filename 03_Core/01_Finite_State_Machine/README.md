# 01_Finite_State_Machine — 有限状态机

## 什么是 FSM？

有限状态机（FSM）是 FPGA 设计中最核心的设计模式。任何有"状态"的控制系统都可以用 FSM 描述。

## 两种 FSM 类型

### Moore 型 — 输出只取决于当前状态
```
          ┌──────┐
Input ──→ │ Next │ ──→ State ──→ Output
  │       │State │                  │
  │       └──────┘                  │
  │          ↑                      │
  └──────────┴──────────────────────┘
         输入 + 当前状态决定下一状态
         输出只取决于当前状态
```

### Mealy 型 — 输出取决于当前状态 + 输入
```
          ┌──────┐
Input ──→ │ Next │ ──→ State
  │       │State │        │
  │       └──────┘        │
  │          ↑             ↓
  └──────────┴──→ Output ←┘
         输入 + 当前状态同时决定下一状态和输出
```

| 特性 | Moore | Mealy |
|------|-------|-------|
| 输出依赖 | 仅当前状态 | 当前状态 + 输入 |
| 状态数 | 较多 | 较少 |
| 输出变化 | 仅状态转换时 | 状态或输入变化时 |
| 组合逻辑延迟 | 1 个时钟 | 可能有组合冒险 |

## FSM 编码方式

| 编码 | 位数 | 特点 |
|------|------|------|
| 二进制编码 | ⌈log₂N⌉ | 最省 FF，译码逻辑多 |
| One-Hot | N | 每个 FF 对应一个状态，译码简单 |
| Gray 码 | ⌈log₂N⌉ | 相邻状态只变 1 位，低功耗 |

> **推荐**: 状态数 ≤ 16 用 One-Hot，> 16 用二进制。

## Verilog FSM 编写模板（三段式，推荐）

```verilog
// 1. 状态定义 (用 localparam)
localparam S_IDLE  = 3'b000;
localparam S_RUN   = 3'b001;
localparam S_DONE  = 3'b010;
reg [2:0] state, next_state;

// 2. 状态转移 (时序 always)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S_IDLE;
    else        state <= next_state;
end

// 3. 下一状态逻辑 (组合 always)
always @(*) begin
    next_state = state;  // 默认保持
    case (state)
        S_IDLE: if (start) next_state = S_RUN;
        S_RUN:  if (done)  next_state = S_DONE;
        S_DONE: next_state = S_IDLE;
    endcase
end

// 4. 输出逻辑 (组合 or 时序)
always @(*) begin
    // ...
end
```

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_traffic_light.v` | Moore 型 FSM — 交通灯控制器 |
| `02_sequence_detector.v` | Mealy 型 FSM — 序列检测器 (检测 "1011") |
