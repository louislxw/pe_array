`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2020 17:29:10
// Design Name: 
// Module Name: overlay
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

module overlay(
    clk, rst, din_v, din_ld, din_pe, inst_v, inst_in, dout_pe
    );
    
input  clk; 
input  rst;
input  din_v;
input  [`DATA_WIDTH*2-1:0] din_ld;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  inst_v;
input  [`INST_WIDTH-1:0] inst_in;

output [`DATA_WIDTH*2-1:0] dout_pe;     

wire valid_data [`NUM_PE-1:0], valid_inst [`NUM_PE-1:0];
wire [`DATA_WIDTH*2-1:0] pe_in [`NUM_PE-1:0];
wire [`DATA_WIDTH*2-1:0] pe_ld [`NUM_PE-1:0];
wire [`DATA_WIDTH*2-1:0] pe_out [`NUM_PE-1:0];
wire [`INST_WIDTH-1:0] inst_ld [`NUM_PE-1:0];

genvar i;

generate
    for (i = 0; i < `NUM_PE; i = i + 1) begin : array
        pe(
            .clk(clk), 
            .rst(rst), 
            .din_v(valid_data[i]), 
            .din_ld(pe_ld[i]), 
            .din_pe(pe_in[i + 1]), 
            .inst_v(valid_inst[i + 1]), 
            .inst_in(inst_ld[i]), 
            .dout_pe(pe_out[i])
            );
    end
endgenerate    
    
    
endmodule
