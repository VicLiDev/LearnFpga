# 04_Advanced — Professional Applications

This section focuses on typical FPGA application domains: digital signal processing, image processing, and IP core usage.

## Chapters

| # | Chapter | Key Points | Demo |
|---|---------|-----------|------|
| 01 | [DSP_Design](01_DSP_Design/) | FIR filter, FFT butterfly, multiplier | 4-tap FIR / Butterfly Unit |
| 02 | [Image_Processing](02_Image_Processing/) | Grayscale, edge detection, frame buffer | Grayscale Convert / Sobel Edge |
| 03 | [IP_Core](03_IP_Core/) | BRAM / FIFO / PLL IP configuration | IP Core integration examples |

## DSP on FPGA Advantage

```
Traditional DSP Chip              FPGA
  Single instruction stream        Massive parallel execution
  Sequential processing            Custom data paths
  Fixed compute units              Flexible topology
  Bottlenecked by clock            Breaks through clock limits

Applications: Radar, Communications, Audio, Motor Control
```

## After This Section

✅ Implement FIR filters and FFT on FPGA
✅ Design basic image processing pipelines
✅ Confidently use vendor IP cores
