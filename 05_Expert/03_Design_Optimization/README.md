# 03_Design_Optimization — 设计优化

## FPGA 设计三大优化目标

```
     速度 (Timing)
       ↑
       │     ╱  ←─ 理想点: 三者平衡
       │    ╱
       │   ╱
 资源 ←──────→ 功耗
  (Area)      (Power)
```

优化一个维度往往牺牲另一个：
- 提速 → 需要更多资源（流水线）或更高功耗（更高时钟）
- 减资源 → 串行复用（降低速度）
- 降功耗 → 降低电压/时钟门控（可能影响速度）

## 优化技术

### 1. 流水线 (Pipelining)
将长组合逻辑路径切分成多级, 每级之间插入寄存器。

```
优化前 (延迟 = T1 + T2 + T3):
  Input ──→ [Logic1] → [Logic2] → [Logic3] → Output
             (T1)        (T2)       (T3)

优化后 (延迟 = max(T1,T2,T3), 吞吐量提高 3x):
  Input ──→ [Logic1] → [FF] → [Logic2] → [FF] → [Logic3] → Output
             (T1)              (T2)              (T3)
```

### 2. 资源共享 (Resource Sharing)
多个操作共享同一个运算单元, 用时分复用。

```
优化前: 2 个加法器
  a ──→ [ADD] ──→ out1    c ──→ [ADD] ──→ out2
       ↑                          ↑
       b                          d

优化后: 1 个加法器 + MUX
  [MUX] ──→ [ADD] ──→ [DEMUX]
   ↑ ↑                ↑ ↑
  a,c b,d              out1,out2
```

### 3. 寄存器重定时 (Retiming)
移动寄存器的位置, 平衡各级组合逻辑的延迟。

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_pipeline_adder.v` | 流水线加法器对比 |
| `02_resource_sharing.v` | 资源共享示例 |
| `03_clock_gating.v` | 时钟门控 (功耗优化) |
