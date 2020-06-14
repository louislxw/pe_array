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
    clk, rst, din_v, din_ld, din_pe, inst_in, dout_pe 
    );
    
input  clk; 
input  rst;
input  din_v;
input  [`DATA_WIDTH*2-1:0] din_ld;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  [`INST_WIDTH-1:0] inst_in;

output [`DATA_WIDTH*2-1:0] dout_pe; 

wire [`INST_WIDTH-1:0] inst_out;

wire [15:0] alumode; // 4-bit * 4
wire [19:0] inmode; // 5-bit * 4 
wire [27:0] opmode; // 7-bit * 4
wire [3:0] cea2; // 1-bit * 4
wire [3:0] ceb2; // 1-bit * 4
wire [3:0] usemult; // 1-bit * 4

wire [1:0] sel;
wire [`DATA_WIDTH*2-1:0] din_wb;

assign sel = inst_out[`INST_WIDTH-1:`INST_WIDTH-2];
assign din_wb = (sel == 2'b10) ? dout_pe : 0;

// Instruction Memory
inst_mem IMEM(
    .clk(clk), 
    .rst(rst), 
    .valid(din_v), 
    .inst_in(inst_in), 
    .inst_out(inst_out) // pc triggered instructions
    ); 

// Control Logics & Decoder
control CTRL(
    .din_ld(din_ld), 
    .din_pe(din_pe), 
    .din_wb(din_wb), 
//    .sel(sel), 
    .inst(inst_out),
    .dout(wdata), 
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult)
    );

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wren(din_v), 
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
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult),
    .din_1(rdata0), 
    .din_2(rdata1), 
    .dout(dout_pe) 
    );    
    
endmodule
