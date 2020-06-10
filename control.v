`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2020 16:10:47
// Design Name: 
// Module Name: control
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

module control(
    din_ld, din_pe, din_wb, sel, dout 
    );
    
input [`DATA_WIDTH*2-1:0] din_ld; // 32-bit
input [`DATA_WIDTH*2-1:0] din_pe; // 32-bit
input [`DATA_WIDTH*2-1:0] din_wb; // 32-bit
input [1:0] sel;

output reg [`DATA_WIDTH*2-1:0] dout; // 32-bit

always @ (*)  
case (sel)
    2'b00:   dout <= din_ld; // load data
    2'b01:   dout <= din_pe; // shift data
    2'b10:   dout <= din_wb; // write back
    default: dout <= 0;
endcase
    
endmodule
