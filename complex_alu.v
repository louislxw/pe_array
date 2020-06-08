`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2020 10:03:57
// Design Name: 
// Module Name: complex_alu
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

module complex_alu( 
    clk, rst, inst, din_1, din_2, dout 
    );

input  clk; 
input  rst;
input  [`INST_WIDTH-1:0] inst;
input  [`DATA_WIDTH*2-1:0] din_1; // 32-bit
input  [`DATA_WIDTH*2-1:0] din_2; // 32-bit

output [`DATA_WIDTH*4-1:0] dout; // 64-bit

reg [`PORTBWIDTH-1:0]	b_1, b_2, b_3, b_4; // 18-bit
reg [`PORTAWIDTH-1:0]	a_1, a_2, a_3, a_4; // 30-bit
reg [`PORTCWIDTH-1:0]	c_1, c_2, c_3, c_4; // 48-bit

wire[`PORTPWIDTH-1:0] p_o_1, p_o_2, p_o_3, p_o_4; // 48-bit

assign dout = {p_o_1[`DATA_WIDTH-1:0], p_o_2[`DATA_WIDTH-1:0], p_o_3[`DATA_WIDTH-1:0], p_o_4[`DATA_WIDTH-1:0]}; 

alu core_1 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_1), // a_i
	.b_i(b_1), // b_i
	.c_i(c_1), // c_i
	.alumode_i(alumode_i), //inst_d2[31:28] 
	.inmode_i(inmode_i), //inst_d2[27:23] 
	.opmode_i(opmode_i), //inst_d2[22:16] 
	.cea2_i(cea2_i), //inst_d2[15] 
	.ceb2_i(ceb2_i), //inst_d2[14] 
	.usemult_i(usemult_i), //inst_d2[13] 
	.p_o(p_o_1)
);
    
alu core_2 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_2), // a_i
	.b_i(b_2), // b_i
	.c_i(c_2), // c_i
	.alumode_i(alumode_i), //inst_d2[31:28] 
	.inmode_i(inmode_i), //inst_d2[27:23] 
	.opmode_i(opmode_i), //inst_d2[22:16] 
	.cea2_i(cea2_i), //inst_d2[15] 
	.ceb2_i(ceb2_i), //inst_d2[14] 
	.usemult_i(usemult_i), //inst_d2[13] 
	.p_o(p_o_2)
);  

alu core_3 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_3), 
	.b_i(b_3), 
	.c_i(c_3), 
	.alumode_i(alumode_i), //inst_d2[31:28] 
	.inmode_i(inmode_i), //inst_d2[27:23] 
	.opmode_i(opmode_i), //inst_d2[22:16] 
	.cea2_i(cea2_i), //inst_d2[15] 
	.ceb2_i(ceb2_i), //inst_d2[14] 
	.usemult_i(usemult_i), //inst_d2[13] 
	.p_o(p_o_3)
);  

alu core_4 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_4), 
	.b_i(b_4), 
	.c_i(c_4), 
	.alumode_i(alumode_i), //inst_d2[31:28] 
	.inmode_i(inmode_i), //inst_d2[27:23] 
	.opmode_i(opmode_i), //inst_d2[22:16] 
	.cea2_i(cea2_i), //inst_d2[15] 
	.ceb2_i(ceb2_i), //inst_d2[14] 
	.usemult_i(usemult_i), //inst_d2[13] 
	.p_o(p_o_4)
);  
   
endmodule
