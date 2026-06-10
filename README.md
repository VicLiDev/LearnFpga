# FPGA 从入门到进阶 — Learn FPGA Step by Step

> Systematic FPGA learning path: Verilog HDL, digital logic design, core circuits, advanced applications and engineering optimization.

## Learning Roadmap

```
01 Introduction ──→ 02 Basics ──→ 03 Core ──→ 04 Advanced ──→ 05 Expert
      │                │             │             │             │
   What is FPGA   Combi Logic   FSM         DSP Design    Verification
   Tool Setup     Seq Logic      Memory      Image Proc    Timing
   HDL Basics     Data Types    Clock Dom   IP Core       Optimization
                   Modular       Interfaces
```

## Directory Structure

### 📗 01_Introduction — Getting Started
| Chapter | Content | Difficulty |
|---------|---------|------------|
| [01_What_Is_FPGA](01_Introduction/01_What_Is_FPGA/) | Architecture, LUT/FF, FPGA vs CPU/ASIC, LED blink demo | ⭐ |
| [02_Toolchain_Setup](01_Introduction/02_Toolchain_Setup/) | Vivado / Quartus installation & project creation guide | ⭐ |
| [03_HDL_Basics](01_Introduction/03_HDL_Basics/) | Verilog syntax, gates, mux, decoder | ⭐⭐ |

### 📘 02_Basics — Digital Logic Fundamentals
| Chapter | Content | Difficulty |
|---------|---------|------------|
| [01_Combinational_Logic](02_Basics/01_Combinational_Logic/) | Encoder, MUX, ALU, adder | ⭐⭐ |
| [02_Sequential_Logic](02_Basics/02_Sequential_Logic/) | D flip-flop, counter, shift register | ⭐⭐⭐ |
| [03_Data_Types](02_Basics/03_Data_Types/) | wire/reg, signed arithmetic, state encoding | ⭐⭐ |
| [04_Modular_Design](02_Basics/04_Modular_Design/) | Module instantiation, parameterized design | ⭐⭐⭐ |

### 📙 03_Core — Essential Design Skills
| Chapter | Content | Difficulty |
|---------|---------|------------|
| [01_Finite_State_Machine](03_Core/01_Finite_State_Machine/) | Moore/Mealy FSM, traffic light, sequence detector | ⭐⭐⭐ |
| [02_Memory_Design](03_Core/02_Memory_Design/) | Single/dual port RAM, ROM, async FIFO | ⭐⭐⭐⭐ |
| [03_Clock_Domain](03_Core/03_Clock_Domain/) | Divider, synchronizer, CDC basics | ⭐⭐⭐⭐ |
| [04_Communication_Interface](03_Core/04_Communication_Interface/) | UART, SPI, I2C protocol implementation | ⭐⭐⭐⭐ |

### 📕 04_Advanced — Professional Applications
| Chapter | Content | Difficulty |
|---------|---------|------------|
| [01_DSP_Design](04_Advanced/01_DSP_Design/) | FIR filter, FFT butterfly, multiplier | ⭐⭐⭐⭐ |
| [02_Image_Processing](04_Advanced/02_Image_Processing/) | Grayscale, Sobel edge detection, frame buffer | ⭐⭐⭐⭐ |
| [03_IP_Core](04_Advanced/03_IP_Core/) | BRAM, FIFO IP, PLL IP usage examples | ⭐⭐⭐ |

### 📓 05_Expert — Engineering Excellence
| Chapter | Content | Difficulty |
|---------|---------|------------|
| [01_Verification_Methodology](05_Expert/01_Verification_Methodology/) | Testbench, self-checking tests, coverage | ⭐⭐⭐⭐ |
| [02_Timing_Constraints](05_Expert/02_Timing_Constraints/) | SDC/XDC basics, clock constraints, I/O constraints | ⭐⭐⭐⭐⭐ |
| [03_Design_Optimization](05_Expert/03_Design_Optimization/) | Pipeline, resource sharing, retiming | ⭐⭐⭐⭐⭐ |

## Language

All demos use **Verilog (IEEE 1364-2001)** for maximum tool compatibility.

## Recommended Boards

| Board | FPGA | Vendor | Best For |
|-------|------|--------|----------|
| Zynq Z7010 | xc7z010clg400-1 | Xilinx | All stages (Recommended) |
| Cyclone IV EP4CE6 | EP4CE6F17C8 | Intel | Intro ~ Core |
| Artix-7 XC7A35T | XC7A35TFTG256-1 | Xilinx | Core ~ Advanced |

## License

MIT License
