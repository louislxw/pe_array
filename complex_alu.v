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
    clk, rst, alumode, inmode, opmode, cea2, ceb2, usemult, din_1, din_2, dout 
    );

input  clk; 
input  rst;
//input  [`INST_WIDTH-1:0] inst;
input  [15:0] alumode; // 4-bit * 4
input  [19:0] inmode; // 5-bit * 4 
input  [27:0] opmode; // 7-bit * 4
input  [3:0] cea2; // 1-bit * 4
input  [3:0] ceb2; // 1-bit * 4
input  [3:0] usemult; // 1-bit * 4
input  [`DATA_WIDTH*2-1:0] din_1; // 32-bit
input  [`DATA_WIDTH*2-1:0] din_2; // 32-bit

output [`DATA_WIDTH*2-1:0] dout; // 32-bit

wire [`PORTBWIDTH-1:0] b_1, b_2, b_3, b_4; // 18-bit
wire [`PORTAWIDTH-1:0] a_1, a_2, a_3, a_4; // 30-bit
wire [`PORTCWIDTH-1:0] c_1, c_2, c_3, c_4; // 48-bit
wire [`PORTPWIDTH-1:0] p_o_1, p_o_2, p_o_3, p_o_4; // 48-bit

assign b_1 = din_1[`DATA_WIDTH*2-1:`DATA_WIDTH];
assign b_2 = din_1[`DATA_WIDTH-1:0];
assign b_3 = din_1[`DATA_WIDTH-1:0];
assign b_4 = din_1[`DATA_WIDTH*2-1:`DATA_WIDTH];
assign a_1 = din_2[`DATA_WIDTH*2-1:`DATA_WIDTH];
assign a_2 = din_2[`DATA_WIDTH-1:0];
assign a_3 = din_2[`DATA_WIDTH*2-1:`DATA_WIDTH];
assign a_4 = din_2[`DATA_WIDTH-1:0];

wire [3:0] alumode_1, alumode_2, alumode_3, alumode_4; // 4-bit
wire [4:0] inmode_1, inmode_2, inmode_3, inmode_4; // 5-bit
wire [6:0] opmode_1, opmode_2, opmode_3, opmode_4; // 7-bit
wire cea2_1, cea2_2, cea2_3, cea2_4;
wire ceb2_1, ceb2_2, ceb2_3, ceb2_4;
wire usemult_1, usemult_2, usemult_3, usemult_4;

assign alumode_1 = alumode[15:12]; assign alumode_2 = alumode[11:8]; assign alumode_3 = alumode[7:4]; assign alumode_4 = alumode[3:0];
assign inmode_1 = inmode[19:15]; assign inmode_2 = inmode[14:10]; assign inmode_3 = inmode[9:5]; assign inmode_4 = inmode[4:0];
assign opmode_1 = opmode[27:21]; assign opmode_2 = opmode[20:14]; assign opmode_3 = opmode[13:7]; assign opmode_4 = opmode[6:0];
assign cea2_1 = cea2[3]; assign cea2_2 = cea2[2]; assign cea2_3 = cea2[1]; assign cea2_4 = cea2[0];
assign ceb2_1 = ceb2[3]; assign ceb2_2 = ceb2[2]; assign ceb2_3 = ceb2[1]; assign ceb2_4 = ceb2[0]; 
assign usemult_1 = usemult[3]; assign usemult_2 = usemult[2]; assign usemult_3 = usemult[1]; assign usemult_4 = usemult[0];

//assign dout = {p_o_1[`DATA_WIDTH-1:0], p_o_2[`DATA_WIDTH-1:0], p_o_3[`DATA_WIDTH-1:0], p_o_4[`DATA_WIDTH-1:0]};
wire [`DATA_WIDTH-1:0] i_out, q_out; 
assign i_out = p_o_1 + p_o_2; // round to 16-bit
assign q_out = p_o_3 - p_o_4; // round to 16-bit
assign dout = {i_out, q_out}; // 32-bit

alu core_1 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_1), // a_i
	.b_i(b_1), // b_i
	.c_i(c_1), // c_i
	.alumode_i(alumode_1), //inst_d2[31:28] 
	.inmode_i(inmode_1), //inst_d2[27:23] 
	.opmode_i(opmode_1), //inst_d2[22:16] 
	.cea2_i(cea2_1), //inst_d2[15] 
	.ceb2_i(ceb2_1), //inst_d2[14] 
	.usemult_i(usemult_1), //inst_d2[13] 
	.p_o(p_o_1)
);
    
alu core_2 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_2), // a_i
	.b_i(b_2), // b_i
	.c_i(c_2), // c_i
	.alumode_i(opmode_2), //inst_d2[31:28] 
	.inmode_i(inmode_2), //inst_d2[27:23] 
	.opmode_i(opmode_2), //inst_d2[22:16] 
	.cea2_i(cea2_2), //inst_d2[15] 
	.ceb2_i(ceb2_2), //inst_d2[14] 
	.usemult_i(usemult_2), //inst_d2[13] 
	.p_o(p_o_2)
);  

alu core_3 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_3), 
	.b_i(b_3), 
	.c_i(c_3), 
	.alumode_i(alumode_3), //inst_d2[31:28] 
	.inmode_i(inmode_3), //inst_d2[27:23] 
	.opmode_i(opmode_3), //inst_d2[22:16] 
	.cea2_i(cea2_3), //inst_d2[15] 
	.ceb2_i(ceb2_3), //inst_d2[14] 
	.usemult_i(usemult_3), //inst_d2[13] 
	.p_o(p_o_3)
);  

alu core_4 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_4), 
	.b_i(b_4), 
	.c_i(c_4), 
	.alumode_i(alumode_4), //inst_d2[31:28] 
	.inmode_i(inmode_4), //inst_d2[27:23] 
	.opmode_i(opmode_4), //inst_d2[22:16] 
	.cea2_i(cea2_4), //inst_d2[15] 
	.ceb2_i(ceb2_4), //inst_d2[14] 
	.usemult_i(usemult_4), //inst_d2[13] 
	.p_o(p_o_4)
); 

endmodule
