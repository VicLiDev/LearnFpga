# 05_Expert — Engineering Excellence

The critical step from "can write code" to "can ship products". This section covers verification, timing constraints, and design optimization.

## Chapters

| # | Chapter | Key Points | Demo |
|---|---------|-----------|------|
| 01 | [Verification_Methodology](01_Verification_Methodology/) | Testbench, self-checking, coverage | Basic TB / Self-Checking TB / Coverage |
| 02 | [Timing_Constraints](02_Timing_Constraints/) | SDC/XDC syntax, clock & I/O constraints | Basic Clock Constraints / IO Constraints |
| 03 | [Design_Optimization](03_Design_Optimization/) | Pipeline, resource sharing, retiming | Pipelined Adder / Resource Sharing |

## Why This Matters?

```
Can write code ≠ Works correctly ≠ Meets timing ≠ Can manufacture

Verification  → Ensures functional correctness (70% of bugs from poor verification)
Constraints   → Ensures timing closure (no constraints = no closure)
Optimization  → Ensures resource/power/performance targets met
```

## Engineer vs Hobbyist

| Dimension | Hobbyist | Engineer |
|-----------|----------|----------|
| Workflow | Write → Flash | Write → Simulate → Verify → Flash |
| Timing | Ignored | 100% timing closure |
| Design | "It works" | Resource/power/performance balanced |
| Documentation | None | Design doc + constraints doc + verification report |

## After This Section

✅ Write professional Testbenches for functional verification
✅ Understand and write timing constraint files
✅ Apply pipelining and resource sharing to optimize designs
