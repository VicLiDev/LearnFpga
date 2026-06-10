# 01_DSP_Design — DSP 设计

## 为什么在 FPGA 上做 DSP？

```
传统 DSP 处理器                    FPGA
  串行: 一条指令处理一个数据         并行: 多个处理单元同时工作
  瓶颈: 时钟频率                    突破时钟瓶颈, 靠并行提高吞吐
  灵活性: 固定的乘加器              可定制任意拓扑的数据通路
  
性能对比 (FIR 滤波器, 256 阶):
  TI C66x DSP: ~1.2 GHz, 8 MAC/周期 → ~38 MACs/ns
  Xilinx UltraScale+: 600 MHz, ~3000 DSP slices → ~1800 MACs/ns
```

## DSP 基础公式

### FIR 滤波器
```
y[n] = Σ(h[k] × x[n-k]), k = 0, 1, ..., N-1

结构:
  x[n] → [z⁻¹] → [z⁻¹] → [z⁻¹]
    │       │       │       │
    ↓       ↓       ↓       ↓
   [h₀]   [h₁]   [h₂]   [h₃]   → Σ → y[n]
```

### FFT 蝶形运算
```
蝶形 (Radix-2):
      A ──→ [+] ──→ A' = A + W×B
               │
      B ──→ [×W] → [-] ──→ B' = A - W×B
```

## FPGA DSP Slice

Xilinx 7 系列的 DSP48E1:
- 预加器: A + D (25-bit)
- 乘法器: 25×18 bit signed
- 累加器: 48-bit
- 模式检测
- 可级联, 形成 MAC 链

## Demo 文件

| 文件 | 内容 |
|------|------|
| `01_fir_filter.v` | 4 阶 FIR 滤波器 |
| `02_fft_butterfly.v` | FFT 基-2 蝶形运算单元 |
| `03_mac_unit.v` | 乘累加 (MAC) 单元 |
