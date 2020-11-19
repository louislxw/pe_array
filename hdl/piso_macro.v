`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2020 16:55:10
// Design Name: 
// Module Name: piso_macro
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

module piso_macro(
    clk, rst, load, ce, p_in, s_out
    );

input clk;
input rst;
input load;
input ce;
input [`DATA_WIDTH*2-1:0] p_in;

output s_out;

   parameter piso_shift = `DATA_WIDTH*2;

   reg [piso_shift-2:0] shift_reg = {piso_shift-1{1'b0}};
   reg                      s_out = 1'b0;

   always @(posedge clk)
      if (rst) begin
         shift_reg <= 0;
         s_out     <= 1'b0;
      end
      else if (load) begin
         shift_reg <= p_in[piso_shift-1:1];
         s_out     <= p_in[0];
      end
      else if (ce) begin
         shift_reg <= {1'b0, shift_reg[piso_shift-2:1]};
         s_out     <= shift_reg[0];
      end

endmodule
