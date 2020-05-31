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
    clk, rst, din, din_v, dout, dout_v, inst_load, inst_forward, ins, ins_out 
    );
    
input  clk; 
input  rst;
input  din_v;
input  [`DATA_WIDTH-1:0] din;
output [`DATA_WIDTH-1:0] dout; 
output dout_v; 

input inst_load;
output reg inst_forward;
input [`IM_ADDR_WIDTH-1:0] ins;
output reg [`IM_ADDR_WIDTH-1:0] ins_out;

// Instruction Memory
inst_mem IMEM(
    .clk(clk), 
    .rst(rst), 
    .valid(valid), 
    .tag(tag), 
    .inst_load(inst_load), 
    .ins(ins), 
    .inst(inst), 
    .valid_out(valid_out), 
    .control_out(control_out)
    ); 

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .valid(valid), 
    .offset_valid(control_out), 
    .dout_v(valid_out), 
    .din(din), 
    .dout(dout[`DATA_WIDTH-1:0]), 
    .inst(inst), 
    .src1(src1), 
    .src2(src2));

// ALU for Complex Data
complex_alu ALU( 
    .clk(clk), 
    .rst(rst), 
    .din_1(din_1), 
    .din_2(din_2), 
    .dout(dout) 
    );    
    
endmodule
