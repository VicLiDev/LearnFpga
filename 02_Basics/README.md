# 02_Basics — Digital Logic Fundamentals

This section is the foundation of all FPGA design. Everything you build later relies on combinational and sequential logic.

## Chapters

| # | Chapter | Key Points | Demo |
|---|---------|-----------|------|
| 01 | [Combinational_Logic](01_Combinational_Logic/) | Encoder, MUX, ALU, adder | 4:1 MUX / Simple ALU / Ripple Carry Adder |
| 02 | [Sequential_Logic](02_Sequential_Logic/) | D flip-flop, counter, shift register | N-bit Counter / Shift Register |
| 03 | [Data_Types](03_Data_Types/) | wire/reg, signed numbers, arithmetic | Data Type Demo / Signed Multiplication |
| 04 | [Modular_Design](04_Modular_Design/) | Instantiation, parameters, hierarchy | Full Adder / 4-bit Adder |

## Key Concepts

### Combinational vs Sequential Logic

```
Combinational Logic                    Sequential Logic
  Input ──→ [Logic] ──→ Output        Input ──→ [Logic] ──→ [FF] ──→ Output
    │          No memory                │           │           │
    └── Output depends only on input    └── Clocked, has memory
```

- **Combinational**: Output depends only on current input. No clock, no state.
- **Sequential**: Output depends on current input + history. Requires clock.

## After This Section

✅ Design any combinational logic circuit
✅ Understand clock, reset, and registers
✅ Write parameterized, reusable modules
