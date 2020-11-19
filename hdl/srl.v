`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2020 12:06:12
// Design Name: 
// Module Name: srl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit shift register logic (SRL) implemented by 1 LUT in a SLICEM
// 
// Dependencies: 32 LUTs, 64 FFs
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module srl(
    clk, ce, din, dout
    );
    
input clk;
//input rst;
input ce;
input  [`DATA_WIDTH*2-1:0] din; 
output [`DATA_WIDTH*2-1:0] dout; 

// Code Template: Static Shift SRL (bus) --> have some issues when simulating multiple instances
reg [`REG_NUM-1:0] shift_reg [`DATA_WIDTH*2-1:0];

integer srl_index;
initial
    for (srl_index = 0; srl_index < `DATA_WIDTH*2; srl_index = srl_index + 1)
        shift_reg[srl_index] = {`REG_NUM{1'b0}};

genvar i;
generate
    for (i = 0; i < `DATA_WIDTH*2; i = i+1) begin: srl_32
        always @(posedge clk)
            if (ce)
                shift_reg[i] <= {shift_reg[i][`REG_NUM-2:0], din[i]};

        assign dout[i] = shift_reg[i][`REG_NUM-1];
    end
endgenerate

    
endmodule
