`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2020 13:37:06
// Design Name: 
// Module Name: pe
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

module pe( 
    clk, rst, din_ld, din_pe, inst_in, dout 
    );
    
input  clk; 
input  rst;
input  [`DATA_WIDTH*2-1:0] din_ld;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  [`INST_WIDTH-1:0] inst_in;

output [`DATA_WIDTH*4-1:0] dout; 

wire [`INST_WIDTH-1:0] inst_out;

wire [1:0] sel;
wire [`DATA_WIDTH*4-1:0] din_wb;

assign sel = inst_in[`INST_WIDTH-1:`INST_WIDTH-2];
assign din_wb = (sel == 2'b10) ? dout : 0;

// Instruction Memory
inst_mem IMEM(
    .clk(clk), 
    .rst(rst), 
    .valid(valid), 
    .inst_in(inst_in), 
    .inst_out(inst_out) // pc triggered instructions
    ); 

control CTRL(
    .din_ld(din_ld), 
    .din_pe(din_pe), 
    .din_wb(din_wb), 
    .sel(sel), 
    .dout(wdata) 
    );

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wren(wren), 
    .rden(rden), 
    .inst(inst_out), 
    .wdata(wdata), 
    .rdata0(rdata0),
    .rdata1(rdata1)
    );

// ALU for Complex Data
complex_alu ALU( 
    .clk(clk), 
    .rst(rst), 
    .inst(inst_out),
    .din_1(rdata0), 
    .din_2(rdata1), 
    .dout(dout) 
    );    
    
endmodule
