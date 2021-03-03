`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2021 10:10:42 AM
// Design Name: 
// Module Name: inst_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module inst_rom(
    clk, en, addr, data_out
    );

input clk;
input en;
input [7:0] addr; // 2^8 = 256 instructions
output [`INST_WIDTH*2-1:0] data_out;

//reg [`INST_WIDTH*2-1:0] data_out;
reg [`INST_WIDTH*2-1:0] rom_out;
//always @(posedge clk) begin
//    data_out <= rom_out; // Add one more pipeline for ROM output
//end

assign data_out = rom_out;

   always @(posedge clk)
      if (en)
         case (addr) // Be careful about the sign bit and fixed-point values
//            8'b00000000: rom_out <= 32'h80_01_00_80; // CMPLX_MULT (opcode = 100)
//            8'b00000001: rom_out <= 32'h80_03_02_81; // CMPLX_MULT (opcode = 100)
//            8'b00000010: rom_out <= 32'h80_05_04_82; // CMPLX_MULT (opcode = 100)
            // 8-pt example
            8'b00000000: rom_out <= 32'h80200040; // mul 
            8'b00000001: rom_out <= 32'h80210141; // mul
            8'b00000010: rom_out <= 32'h80220242; // mul
            8'b00000011: rom_out <= 32'h80230343; // mul
            8'b00000100: rom_out <= 32'h80240444; // mul
            8'b00000101: rom_out <= 32'h80250545; // mul
            8'b00000110: rom_out <= 32'h80260646; // mul
            8'b00000111: rom_out <= 32'h80270747; // mul
            8'b00001000: rom_out <= 32'hB0444048; // muladd
            8'b00001001: rom_out <= 32'hD0444049; // mulsub
            8'b00001010: rom_out <= 32'hB046424A;
            8'b00001011: rom_out <= 32'hD046424B;
            8'b00001100: rom_out <= 32'hB045414C;
            8'b00001101: rom_out <= 32'hD045414D;
            8'b00001110: rom_out <= 32'hB047434E;
            8'b00001111: rom_out <= 32'hD047434F;
            8'b00010000: rom_out <= 32'hB04A4850;
            8'b00010001: rom_out <= 32'hD04A4852;
            8'b00010010: rom_out <= 32'hB24B4951;
            8'b00010011: rom_out <= 32'hD24B4953;
            8'b00010100: rom_out <= 32'hB04E4C54;
            8'b00010101: rom_out <= 32'hD04E4C56;
            8'b00010110: rom_out <= 32'hB24F4D55;
            8'b00010111: rom_out <= 32'hD24F4D57;
            8'b00011000: rom_out <= 32'hB0545058;
            8'b00011001: rom_out <= 32'hD054505C;
            8'b00011010: rom_out <= 32'hB1565259;
            8'b00011011: rom_out <= 32'hD156525D;
            8'b00011100: rom_out <= 32'hB255515A;
            8'b00011101: rom_out <= 32'hD255515E;
            8'b00011110: rom_out <= 32'hB357535B;
            8'b00011111: rom_out <= 32'hD357535F;
            
            8'b00100000: rom_out <= 32'h0000_0000;
            8'b00100001: rom_out <= 32'h0000_0000;
            8'b00100010: rom_out <= 32'h0000_0000;
            8'b00100011: rom_out <= 32'h0000_0000;
            8'b00100100: rom_out <= 32'h0000_0000;
            8'b00100101: rom_out <= 32'h0000_0000;
            8'b00100110: rom_out <= 32'h0000_0000;
            8'b00100111: rom_out <= 32'h0000_0000;
            8'b00101000: rom_out <= 32'h0000_0000;
            8'b00101001: rom_out <= 32'h0000_0000;
            8'b00101010: rom_out <= 32'h0000_0000;
            8'b00101011: rom_out <= 32'h0000_0000;
            8'b00101100: rom_out <= 32'h0000_0000;
            8'b00101101: rom_out <= 32'h0000_0000;
            8'b00101110: rom_out <= 32'h0000_0000;
            8'b00101111: rom_out <= 32'h0000_0000;
            8'b00110000: rom_out <= 32'h0000_0000;
            8'b00110001: rom_out <= 32'h0000_0000;
            8'b00110010: rom_out <= 32'h0000_0000;
            8'b00110011: rom_out <= 32'h0000_0000;
            8'b00110100: rom_out <= 32'h0000_0000;
            8'b00110101: rom_out <= 32'h0000_0000;
            8'b00110110: rom_out <= 32'h0000_0000;
            8'b00110111: rom_out <= 32'h0000_0000;
            8'b00111000: rom_out <= 32'h0000_0000;
            8'b00111001: rom_out <= 32'h0000_0000;
            8'b00111010: rom_out <= 32'h0000_0000;
            8'b00111011: rom_out <= 32'h0000_0000;
            8'b00111100: rom_out <= 32'h0000_0000;
            8'b00111101: rom_out <= 32'h0000_0000;
            8'b00111110: rom_out <= 32'h0000_0000;
            8'b00111111: rom_out <= 32'h0000_0000;
            8'b01000000: rom_out <= 32'h0000_0000; 
            8'b01000001: rom_out <= 32'h0000_0000; 
            8'b01000010: rom_out <= 32'h0000_0000; 
            8'b01000011: rom_out <= 32'h0000_0000;
            8'b01000100: rom_out <= 32'h0000_0000;
            8'b01000101: rom_out <= 32'h0000_0000;
            8'b01000110: rom_out <= 32'h0000_0000;
            8'b01000111: rom_out <= 32'h0000_0000;
            8'b01001000: rom_out <= 32'h0000_0000;
            8'b01001001: rom_out <= 32'h0000_0000;
            8'b01001010: rom_out <= 32'h0000_0000;
            8'b01001011: rom_out <= 32'h0000_0000;
            8'b01001100: rom_out <= 32'h0000_0000;
            8'b01001101: rom_out <= 32'h0000_0000;
            8'b01001110: rom_out <= 32'h0000_0000;
            8'b01001111: rom_out <= 32'h0000_0000;
            8'b01010000: rom_out <= 32'h0000_0000;
            8'b01010001: rom_out <= 32'h0000_0000;
            8'b01010010: rom_out <= 32'h0000_0000;
            8'b01010011: rom_out <= 32'h0000_0000;
            8'b01010100: rom_out <= 32'h0000_0000;
            8'b01010101: rom_out <= 32'h0000_0000;
            8'b01010110: rom_out <= 32'h0000_0000;
            8'b01010111: rom_out <= 32'h0000_0000;
            8'b01011000: rom_out <= 32'h0000_0000;
            8'b01011001: rom_out <= 32'h0000_0000;
            8'b01011010: rom_out <= 32'h0000_0000;
            8'b01011011: rom_out <= 32'h0000_0000;
            8'b01011100: rom_out <= 32'h0000_0000;
            8'b01011101: rom_out <= 32'h0000_0000;
            8'b01011110: rom_out <= 32'h0000_0000;
            8'b01011111: rom_out <= 32'h0000_0000;
            8'b01100000: rom_out <= 32'h0000_0000;
            8'b01100001: rom_out <= 32'h0000_0000;
            8'b01100010: rom_out <= 32'h0000_0000;
            8'b01100011: rom_out <= 32'h0000_0000;
            8'b01100100: rom_out <= 32'h0000_0000;
            8'b01100101: rom_out <= 32'h0000_0000;
            8'b01100110: rom_out <= 32'h0000_0000;
            8'b01100111: rom_out <= 32'h0000_0000;
            8'b01101000: rom_out <= 32'h0000_0000;
            8'b01101001: rom_out <= 32'h0000_0000;
            8'b01101010: rom_out <= 32'h0000_0000;
            8'b01101011: rom_out <= 32'h0000_0000;
            8'b01101100: rom_out <= 32'h0000_0000;
            8'b01101101: rom_out <= 32'h0000_0000;
            8'b01101110: rom_out <= 32'h0000_0000;
            8'b01101111: rom_out <= 32'h0000_0000;
            8'b01110000: rom_out <= 32'h0000_0000;
            8'b01110001: rom_out <= 32'h0000_0000;
            8'b01110010: rom_out <= 32'h0000_0000;
            8'b01110011: rom_out <= 32'h0000_0000;
            8'b01110100: rom_out <= 32'h0000_0000;
            8'b01110101: rom_out <= 32'h0000_0000;
            8'b01110110: rom_out <= 32'h0000_0000;
            8'b01110111: rom_out <= 32'h0000_0000;
            8'b01111000: rom_out <= 32'h0000_0000;
            8'b01111001: rom_out <= 32'h0000_0000;
            8'b01111010: rom_out <= 32'h0000_0000;
            8'b01111011: rom_out <= 32'h0000_0000;
            8'b01111100: rom_out <= 32'h0000_0000;
            8'b01111101: rom_out <= 32'h0000_0000;
            8'b01111110: rom_out <= 32'h0000_0000;
            8'b01111111: rom_out <= 32'h0000_0000;
            8'b10000000: rom_out <= 32'h0000_0000; 
            8'b10000001: rom_out <= 32'h0000_0000; 
            8'b10000010: rom_out <= 32'h0000_0000; 
            8'b10000011: rom_out <= 32'h0000_0000;
            8'b10000100: rom_out <= 32'h0000_0000;
            8'b10000101: rom_out <= 32'h0000_0000;
            8'b10000110: rom_out <= 32'h0000_0000;
            8'b10000111: rom_out <= 32'h0000_0000;
            8'b10001000: rom_out <= 32'h0000_0000;
            8'b10001001: rom_out <= 32'h0000_0000;
            8'b10001010: rom_out <= 32'h0000_0000;
            8'b10001011: rom_out <= 32'h0000_0000;
            8'b10001100: rom_out <= 32'h0000_0000;
            8'b10001101: rom_out <= 32'h0000_0000;
            8'b10001110: rom_out <= 32'h0000_0000;
            8'b10001111: rom_out <= 32'h0000_0000;
            8'b10010000: rom_out <= 32'h0000_0000;
            8'b10010001: rom_out <= 32'h0000_0000;
            8'b10010010: rom_out <= 32'h0000_0000;
            8'b10010011: rom_out <= 32'h0000_0000;
            8'b10010100: rom_out <= 32'h0000_0000;
            8'b10010101: rom_out <= 32'h0000_0000;
            8'b10010110: rom_out <= 32'h0000_0000;
            8'b10010111: rom_out <= 32'h0000_0000;
            8'b10011000: rom_out <= 32'h0000_0000;
            8'b10011001: rom_out <= 32'h0000_0000;
            8'b10011010: rom_out <= 32'h0000_0000;
            8'b10011011: rom_out <= 32'h0000_0000;
            8'b10011100: rom_out <= 32'h0000_0000;
            8'b10011101: rom_out <= 32'h0000_0000;
            8'b10011110: rom_out <= 32'h0000_0000;
            8'b10011111: rom_out <= 32'h0000_0000;
            8'b10100000: rom_out <= 32'h0000_0000;
            8'b10100001: rom_out <= 32'h0000_0000;
            8'b10100010: rom_out <= 32'h0000_0000;
            8'b10100011: rom_out <= 32'h0000_0000;
            8'b10100100: rom_out <= 32'h0000_0000;
            8'b10100101: rom_out <= 32'h0000_0000;
            8'b10100110: rom_out <= 32'h0000_0000;
            8'b10100111: rom_out <= 32'h0000_0000;
            8'b10101000: rom_out <= 32'h0000_0000;
            8'b10101001: rom_out <= 32'h0000_0000;
            8'b10101010: rom_out <= 32'h0000_0000;
            8'b10101011: rom_out <= 32'h0000_0000;
            8'b10101100: rom_out <= 32'h0000_0000;
            8'b10101101: rom_out <= 32'h0000_0000;
            8'b10101110: rom_out <= 32'h0000_0000;
            8'b10101111: rom_out <= 32'h0000_0000;
            8'b10110000: rom_out <= 32'h0000_0000;
            8'b10110001: rom_out <= 32'h0000_0000;
            8'b10110010: rom_out <= 32'h0000_0000;
            8'b10110011: rom_out <= 32'h0000_0000;
            8'b10110100: rom_out <= 32'h0000_0000;
            8'b10110101: rom_out <= 32'h0000_0000;
            8'b10110110: rom_out <= 32'h0000_0000;
            8'b10110111: rom_out <= 32'h0000_0000;
            8'b10111000: rom_out <= 32'h0000_0000;
            8'b10111001: rom_out <= 32'h0000_0000;
            8'b10111010: rom_out <= 32'h0000_0000;
            8'b10111011: rom_out <= 32'h0000_0000;
            8'b10111100: rom_out <= 32'h0000_0000;
            8'b10111101: rom_out <= 32'h0000_0000;
            8'b10111110: rom_out <= 32'h0000_0000;
            8'b10111111: rom_out <= 32'h0000_0000;
            8'b11000000: rom_out <= 32'h0000_0000; 
            8'b11000001: rom_out <= 32'h0000_0000; 
            8'b11000010: rom_out <= 32'h0000_0000; 
            8'b11000011: rom_out <= 32'h0000_0000;
            8'b11000100: rom_out <= 32'h0000_0000;
            8'b11000101: rom_out <= 32'h0000_0000;
            8'b11000110: rom_out <= 32'h0000_0000;
            8'b11000111: rom_out <= 32'h0000_0000;
            8'b11001000: rom_out <= 32'h0000_0000;
            8'b11001001: rom_out <= 32'h0000_0000;
            8'b11001010: rom_out <= 32'h0000_0000;
            8'b11001011: rom_out <= 32'h0000_0000;
            8'b11001100: rom_out <= 32'h0000_0000;
            8'b11001101: rom_out <= 32'h0000_0000;
            8'b11001110: rom_out <= 32'h0000_0000;
            8'b11001111: rom_out <= 32'h0000_0000;
            8'b11010000: rom_out <= 32'h0000_0000;
            8'b11010001: rom_out <= 32'h0000_0000;
            8'b11010010: rom_out <= 32'h0000_0000;
            8'b11010011: rom_out <= 32'h0000_0000;
            8'b11010100: rom_out <= 32'h0000_0000;
            8'b11010101: rom_out <= 32'h0000_0000;
            8'b11010110: rom_out <= 32'h0000_0000;
            8'b11010111: rom_out <= 32'h0000_0000;
            8'b11011000: rom_out <= 32'h0000_0000;
            8'b11011001: rom_out <= 32'h0000_0000;
            8'b11011010: rom_out <= 32'h0000_0000;
            8'b11011011: rom_out <= 32'h0000_0000;
            8'b11011100: rom_out <= 32'h0000_0000;
            8'b11011101: rom_out <= 32'h0000_0000;
            8'b11011110: rom_out <= 32'h0000_0000;
            8'b11011111: rom_out <= 32'h0000_0000;
            8'b11100000: rom_out <= 32'h0000_0000;
            8'b11100001: rom_out <= 32'h0000_0000;
            8'b11100010: rom_out <= 32'h0000_0000;
            8'b11100011: rom_out <= 32'h0000_0000;
            8'b11100100: rom_out <= 32'h0000_0000;
            8'b11100101: rom_out <= 32'h0000_0000;
            8'b11100110: rom_out <= 32'h0000_0000;
            8'b11100111: rom_out <= 32'h0000_0000;
            8'b11101000: rom_out <= 32'h0000_0000;
            8'b11101001: rom_out <= 32'h0000_0000;
            8'b11101010: rom_out <= 32'h0000_0000;
            8'b11101011: rom_out <= 32'h0000_0000;
            8'b11101100: rom_out <= 32'h0000_0000;
            8'b11101101: rom_out <= 32'h0000_0000;
            8'b11101110: rom_out <= 32'h0000_0000;
            8'b11101111: rom_out <= 32'h0000_0000;
            8'b11110000: rom_out <= 32'h0000_0000;
            8'b11110001: rom_out <= 32'h0000_0000;
            8'b11110010: rom_out <= 32'h0000_0000;
            8'b11110011: rom_out <= 32'h0000_0000;
            8'b11110100: rom_out <= 32'h0000_0000;
            8'b11110101: rom_out <= 32'h0000_0000;
            8'b11110110: rom_out <= 32'h0000_0000;
            8'b11110111: rom_out <= 32'h0000_0000;
            8'b11111000: rom_out <= 32'h0000_0000;
            8'b11111001: rom_out <= 32'h0000_0000;
            8'b11111010: rom_out <= 32'h0000_0000;
            8'b11111011: rom_out <= 32'h0000_0000;
            8'b11111100: rom_out <= 32'h0000_0000;
            8'b11111101: rom_out <= 32'h0000_0000;
            8'b11111110: rom_out <= 32'h0000_0000;
            8'b11111111: rom_out <= 32'h0000_0000;
            default: rom_out <= 32'h0000_0000;
         endcase

endmodule
