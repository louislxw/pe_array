# pe_array
Layout of this repository:
* **constrs** constraint files
* **doc** documentations and figures
* **hdl** verilog source files
* **header** verilog header files
* **sim** testbench files for simulation

A linear array of PEs with RISC-V ISA working in SIMD fashion. 
One PE targets for 600MHz on ZYNQ UltraScale+; specificially for SCD and CNNs. 
The available hardware resources on Xilinx ZCU111 platform are:
|   LUT   |   FF    |  BRAM |  DSP  |
|---------|---------|-------|-------|
| 425,280 | 850,560 | 1,080 | 42,72 |

The FPGA resource usage of 1 PE (running at 600MHz) is:
| LUT | FF  | BRAM | DSP |
|-----|-----|------|-----|
| 224 | 290 |  1.5 |  4  |

The FPGA resource usage of an 32-PE overlay (running at 600MHz) is:
|   LUT  |   FF   | BRAM | DSP |
|--------|--------|------|-----|
| 10,080 | 11,138 | 48.0 | 128 |

The FPGA resource usage of an 64-PE overlay (running at 550MHz) is:
|  LUT   |   FF   | BRAM | DSP |
|--------|--------|------|-----|
| 18,056 | 21,222 | 96.0 | 256 |

The FPGA resource usage of an 128-PE overlay (running at 500MHz) is:
|  LUT   |   FF   | BRAM  |  DSP  |
|--------|--------|-------|-------|
| 30,198 | 31,495 | 192.0 |  512  |
|  7.1%  |  3.7%  | 17.8% | 12.0% |

The 32-bit shift register logic (SRL) can be implemented by FFs or LUTs: 
|                | LUT |   FF  |
|----------------|-----|-------|
| Register-based |  0  | 1,024 |
|  SLICEM-based  |  32 |   64  |

DSP48E2 configuration:
| Operation | INMODE |   OPMODE  | ALUMODE |
|-----------|--------|-----------|---------|
|    ADD    |  00000 | XX0110011 |   0000  |
|    SUB    |  00000 | XX0110011 |   0011  |
|    MUL    |  10001 | XX0000101 |   0000  |
|  MULADD   |  10001 | XX0110101 |   0000  |
|  MULSUB   |  10001 | XX0110101 |   0011  |
|  COMPARE  |  00000 | XX0110011 |   1100  |

