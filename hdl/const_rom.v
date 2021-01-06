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
         case (addr) // Be careful about the sign bit and fixed-point values
            4'b0000: rom_out <= 32'h0001_0000; // W0 = 1
            4'b0001: rom_out <= 32'hFB14_31F1; // W1 = 0.98078 - j*0.19509
            4'b0010: rom_out <= 32'hEC83_61F7; // W2 = 0.92388 - j*0.38268
            4'b0011: rom_out <= 32'hD4DB_8E40; // W3 = 0.83147 - j*0.55557
            4'b0100: rom_out <= 32'hB505_B505; // W4 = 0.70711 - j*0.70711
            4'b0101: rom_out <= 32'h8E40_8E40; // W5 = 0.55557 - j*0.83147
            4'b0110: rom_out <= 32'h61F7_EC83; // W6 = 0.38268 - j*0.92388
            4'b0111: rom_out <= 32'h31F1_FB14; // W7 = 0.19509 - j*0.98078
            4'b1000: rom_out <= 32'h0000_0001; // W8 = -j
            4'b1001: rom_out <= 32'h31F1_FB14; // W9 = -0.19509 - j*0.98078
            4'b1010: rom_out <= 32'h61F7_EC83; // W10 = -0.38268 - j*0.92388
            4'b1011: rom_out <= 32'h8E40_0000; // W11 = -0.55557 - j*0.83147
            4'b1100: rom_out <= 32'hB505_B505; // W12 = -0.70711 - j*0.70711
            4'b1101: rom_out <= 32'hD4DB_8E40; // W13 = -0.83147 - j*0.55557
            4'b1110: rom_out <= 32'hEC83_61F7; // W14 = -0.92388 - j*0.38268
            4'b1111: rom_out <= 32'hFB14_31F1; // W15 = -0.98078 - j*0.19509
            default: rom_out <= 32'h0000_0000;
         endcase
    
endmodule
