# 03_Core — Essential Design Skills

This section covers the most frequently used design patterns in FPGA engineering: state machines, memories, clock domains, and communication interfaces.

## Chapters

| # | Chapter | Key Points | Demo |
|---|---------|-----------|------|
| 01 | [Finite_State_Machine](01_Finite_State_Machine/) | Moore/Mealy FSM, encoding styles | Traffic Light / Sequence Detector |
| 02 | [Memory_Design](02_Memory_Design/) | RAM/ROM/FIFO in Verilog | Single-Port RAM / Dual-Port RAM / Async FIFO |
| 03 | [Clock_Domain](03_Clock_Domain/) | Clock divider, synchronizer, CDC | Divider / 2-stage Synchronizer |
| 04 | [Communication_Interface](04_Communication_Interface/) | UART/SPI/I2C protocols | UART Tx+Rx / SPI Master / I2C Master |

## Why These Are Core?

- **FSM**: The backbone of all control logic in FPGA
- **Memory**: Data buffering, lookup tables, queues — everywhere
- **Clock Domain**: Multi-clock systems are common; mishandling causes metastability
- **Interfaces**: Essential for communicating with external chips

## Design Principles

```
1. FSM: Use parameter constants for state encoding (One-Hot or binary)
2. Memory: Use reg arrays or vendor Block RAM IP
3. Clock Domain: Always synchronize cross-domain data — never sample directly
4. Interface: Draw timing diagram first, then write code
```

## After This Section

✅ Design FSMs of any complexity
✅ Implement various memory structures
✅ Handle cross-clock-domain data correctly
✅ Implement UART/SPI/I2C from scratch
