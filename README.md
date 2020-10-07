# pe_array
Layout of this repository:
* constrs/ constraint files
* doc/ documentations and figures
* hdl/ verilog source files
* header/ verilog header files
* sim/ testbench files for simulation

A linear array of PEs working in SIMD fashion. 
One PE targets for 600MHz on ZYNQ UltraScale+; specificially for SCD and CNNs.

The FPGA resource consumption of 1 PE is:
| LUT | FF  | BRAM | DSP |
|-----|-----|------|-----|
| 237 | 372 | 2.0  | 4   |

The FPGA resource consumption of an 8-PE overlay is:
| LUT  | FF   | BRAM | DSP |
|------|------|------|-----|
| 1868 | 2636 | 16.0 | 32  |
