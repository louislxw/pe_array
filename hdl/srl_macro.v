`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2020 11:48:41
// Design Name: 
// Module Name: srl_macro
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 32 LUTs, 64 FFs (if remove registers for dout, then no FF.)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module srl_macro(
    clk, ce, din, dout
    );
    
input clk;
input ce;
input  [`DATA_WIDTH*2-1:0] din;
output [`DATA_WIDTH*2-1:0] dout;

//reg [`DATA_WIDTH*2-1:0] dout;
//wire [`DATA_WIDTH*2-1:0] srl_out;

// SRLC32E: 32-Bit Shift Register Look-Up Table (LUT)
parameter A = 5'b11111;
genvar i;
generate
    for (i=0; i < `DATA_WIDTH*2; i=i+1) begin: srl_32
       SRLC32E #(
          .INIT(32'h00000000),    // Initial contents of shift register
          .IS_CLK_INVERTED(1'b0)  // Optional inversion for CLK
       )
       SRLC32E_inst (
          .Q(dout[i]), // 1-bit output: SRL Data
          .Q31(Q31), // 1-bit output: SRL Cascade Data
          .A(A),     // 5-bit input: Selects SRL depth
          .CE(ce),   // 1-bit input: Clock enable
          .CLK(clk), // 1-bit input: Clock
          .D(din[i])      // 1-bit input: SRL Data
       );
    end
endgenerate

//always @(posedge clk)
//    dout <= srl_out;

 // End of SRLC32E_inst instantiation    
    
endmodule
