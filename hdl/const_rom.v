`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2020 03:33:53 PM
// Design Name: 
// Module Name: const_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: LUT-based ROM to restore the twiddle factors
// 
// Dependencies: 15 LUTs, 31 FFs
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module const_rom(
    clk, en, addr, data_out
    );

input clk;
input en;
input [3:0] addr;
output [`DATA_WIDTH*2-1:0] data_out;

reg [`DATA_WIDTH*2-1:0] data_out;
reg [`DATA_WIDTH*2-1:0] rom_out;
always @(posedge clk)
    data_out <= rom_out; // Add one more pipeline for ROM output

//assign data_out = rom_out;

   always @(posedge clk)
      if (en)
         case (addr) // left shift 15-bit & represented by Hex signed 2's complement
//            4'b0000: rom_out <= 32'h0001_0000; // 1
//            4'b0001: rom_out <= 32'h0002_0004; // 2 + j*4
//            4'b0010: rom_out <= 32'h0003_0005; // 3 + j*5
            4'b0000: rom_out <= 32'h7FFF_0000; // W0 = 1
            4'b0001: rom_out <= 32'h7D8A_E707; // W1 = 0.98078 - j*0.19509
            4'b0010: rom_out <= 32'h7642_CF04; // W2 = 0.92388 - j*0.38268
            4'b0011: rom_out <= 32'h6A6E_B8E3; // W3 = 0.83147 - j*0.55557
            4'b0100: rom_out <= 32'h5A83_A57D; // W4 = 0.70711 - j*0.70711
            4'b0101: rom_out <= 32'h471D_9592; // W5 = 0.55557 - j*0.83147
            4'b0110: rom_out <= 32'h30FC_89BE; // W6 = 0.38268 - j*0.92388
            4'b0111: rom_out <= 32'h18F9_8276; // W7 = 0.19509 - j*0.98078
            4'b1000: rom_out <= 32'h0000_8000; // W8 = -j
            4'b1001: rom_out <= 32'hE707_8276; // W9 = -0.19509 - j*0.98078
            4'b1010: rom_out <= 32'hCF04_89BE; // W10 = -0.38268 - j*0.92388
            4'b1011: rom_out <= 32'hB8E3_9592; // W11 = -0.55557 - j*0.83147
            4'b1100: rom_out <= 32'hA57D_A57D; // W12 = -0.70711 - j*0.70711
            4'b1101: rom_out <= 32'h9592_B8E3; // W13 = -0.83147 - j*0.55557
            4'b1110: rom_out <= 32'h89BE_CF04; // W14 = -0.92388 - j*0.38268
            4'b1111: rom_out <= 32'h8276_E707; // W15 = -0.98078 - j*0.19509
            default: rom_out <= 32'h0000_0000;
         endcase
    
endmodule
