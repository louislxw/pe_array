# pe_array
Layout of this repository:
* **constrs** constraint files
* **doc** documentations and figures
* **hdl** verilog source files
* **header** verilog header files
* **sim** testbench files for simulation

A linear array of PEs with RISC-V ISA working in SIMD fashion. 
One PE targets for 600MHz on ZYNQ UltraScale+; specificially for SCD and CNNs.

The FPGA resource consumption of 1 PE is:
| LUT | FF  | BRAM | DSP |
|-----|-----|------|-----|
| 237 | 372 | 2.0  | 4   |

The FPGA resource consumption of an 8-PE overlay is:
|  LUT  |  FF   | BRAM | DSP |
|-------|-------|------|-----|
| 1,868 | 2,636 | 16.0 | 32  |

The 32-bit shift register logic (SRL) can be implemented by FFs or LUTs: 
|                | LUT |   FF  |
|----------------|-----|-------|
| Register-based |  0  | 1,024 |
|  SLICEM-based  |  32 |   64  |
