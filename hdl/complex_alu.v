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
// Description: An ALU for operations of 32-bit complex numbers
// 
// Dependencies: 44 LUTs, 148 FFs, 4 DSPs (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module complex_alu( 
    clk, rst, opcode, alumode, inmode, opmode, cea2, ceb2, usemult, din_1, din_2, din_3, dout 
    );

input  clk; 
input  rst;
input  [2:0] opcode;
input  [`ALUMODE_WIDTH*4-1:0] alumode; // 4-bit * 4
input  [`INMODE_WIDTH*4-1:0]  inmode;  // 5-bit * 4 
input  [`OPMODE_WIDTH*4-1:0]  opmode;  // 7-bit * 4
input  [3:0] cea2; // 1-bit * 4
input  [3:0] ceb2; // 1-bit * 4
input  [3:0] usemult; // 1-bit * 4
input  [`DATA_WIDTH*2-1:0] din_1; // 32-bit
input  [`DATA_WIDTH*2-1:0] din_2; // 32-bit
input  [`DATA_WIDTH*2-1:0] din_3; // 32-bit

output [`DATA_WIDTH*2-1:0] dout; // 32-bit

/*** Input Map ***/
//reg [`PORTB_WIDTH-1:0] b_1, b_2, b_3, b_4; // 18-bit
//reg [`PORTA_WIDTH-1:0] a_1, a_2, a_3, a_4; // 30-bit
//reg [`PORTC_WIDTH-1:0] c_1, c_2, c_3, c_4; // 48-bit
//reg [`DATA_WIDTH-1:0] i_out, q_out; // 16-bit

//always @(posedge clk)
////always @ *
//    case (opcode)
////        3'b000: <output> <= <input1>;
////        3'b001: <output> <= <input2>;
////        3'b010: <output> <= <input3>;
////        3'b011: <output> <= <input4>;
//        3'b100: begin // COMPEX_MULT
//            b_1 <= din_1[`DATA_WIDTH*2-1:`DATA_WIDTH]; // a
//            a_1 <= din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
//            c_1 <= 0;
//            b_2 <= din_1[`DATA_WIDTH-1:0]; // b
//            a_2 <= din_2[`DATA_WIDTH-1:0]; // d
//            c_2 <= 0;
//            b_3 <= din_1[`DATA_WIDTH-1:0]; // b
//            a_3 <= din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
//            c_3 <= 0;
//            b_4 <= din_1[`DATA_WIDTH*2-1:`DATA_WIDTH]; // a
//            a_4 <= din_2[`DATA_WIDTH-1:0]; // d
//            c_4 <= 0;
//            i_out <= p_o_1 - p_o_2; // a*c - b*d 
//            q_out <= p_o_3 + p_o_4; // b*c + a*d
//         end
//         3'b101: begin // MULADD
//            b_1 <= din_3[`DATA_WIDTH*2-1:`DATA_WIDTH]; // Wi
//            a_1 <= din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
//            c_1 <= din_1[`DATA_WIDTH*2-1:`DATA_WIDTH]; // a
//            b_2 <= din_3[`DATA_WIDTH-1:0]; // Wq
//            a_2 <= din_2[`DATA_WIDTH-1:0]; // d
//            c_2 <= 0;
//            b_3 <= din_3[`DATA_WIDTH-1:0]; // Wq
//            a_3 <= din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
//            c_3 <= din_1[`DATA_WIDTH-1:0]; // b
//            b_4 <= din_3[`DATA_WIDTH*2-1:`DATA_WIDTH]; // Wi
//            a_4 <= din_2[`DATA_WIDTH-1:0]; // d
//            c_4 <= 0;
//            i_out <= p_o_1 - p_o_2; // a + Wi*c - Wq*d
//            q_out <= p_o_3 + p_o_4; // b + Wq*c + Wi*d
//         end
//         3'b110: begin // MULSUB
//            b_1 <= din_3[`DATA_WIDTH*2-1:`DATA_WIDTH]; // Wi
//            a_1 <= din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
//            c_1 <= din_1[`DATA_WIDTH*2-1:`DATA_WIDTH]; // a
//            b_2 <= din_3[`DATA_WIDTH-1:0]; // Wq
//            a_2 <= din_2[`DATA_WIDTH-1:0]; // d
//            c_2 <= 0;
//            b_3 <= din_3[`DATA_WIDTH-1:0]; // Wq
//            a_3 <= din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
//            c_3 <= din_1[`DATA_WIDTH-1:0]; // b
//            b_4 <= din_3[`DATA_WIDTH*2-1:`DATA_WIDTH]; // Wi
//            a_4 <= din_2[`DATA_WIDTH-1:0]; // d
//            c_4 <= 0;
//            i_out <= p_o_1 + p_o_2; // a - Wi*c + Wq*d
//            q_out <= p_o_3 - p_o_4; // b - Wq*c - Wi*d
//         end
////        3'b111: <output> <= <input8>;
//      endcase


wire [`PORTB_WIDTH-1:0] b_1, b_2, b_3, b_4; // 18-bit
wire [`PORTA_WIDTH-1:0] a_1, a_2, a_3, a_4; // 30-bit
wire [`PORTC_WIDTH-1:0] c_1, c_2, c_3, c_4; // 48-bit
wire [`PORTP_WIDTH-1:0] p_o_1, p_o_2, p_o_3, p_o_4; // 48-bit
wire [`DATA_WIDTH-1:0] i_out, q_out; // 16-bit

assign b_1 = din_1[`DATA_WIDTH*2-1:`DATA_WIDTH]; // a
assign a_1 = din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
assign c_1 = din_3;
assign b_2 = din_1[`DATA_WIDTH-1:0]; // b
assign a_2 = din_2[`DATA_WIDTH-1:0]; // d
assign c_2 = din_3;
assign b_3 = din_1[`DATA_WIDTH-1:0]; // b
assign a_3 = din_2[`DATA_WIDTH*2-1:`DATA_WIDTH]; // c
assign c_3 = din_3;
assign b_4 = din_1[`DATA_WIDTH*2-1:`DATA_WIDTH]; // a
assign a_4 = din_2[`DATA_WIDTH-1:0]; // d
assign c_4 = din_3;

assign i_out = (opcode == 3'b110) ? (p_o_1 + p_o_2) : (p_o_1 - p_o_2);
assign q_out = (opcode == 3'b110) ? (p_o_3 - p_o_4) : (p_o_3 + p_o_4);
//assign i_out = p_o_1 - p_o_2; // (a*c - b*d) round to 16-bit 
//assign q_out = p_o_3 + p_o_4; // (b*c + a*d) round to 16-bit 
assign dout = {i_out, q_out}; // 32-bit

reg [`ALUMODE_WIDTH-1:0] alumode_1, alumode_2, alumode_3, alumode_4; // 4-bit
reg [`INMODE_WIDTH-1:0]  inmode_1, inmode_2, inmode_3, inmode_4;     // 5-bit
reg [`OPMODE_WIDTH-1:0]  opmode_1, opmode_2, opmode_3, opmode_4;     // 7-bit
reg cea2_1, cea2_2, cea2_3, cea2_4;
reg ceb2_1, ceb2_2, ceb2_3, ceb2_4;
reg usemult_1, usemult_2, usemult_3, usemult_4;

always @ (posedge clk) begin
    alumode_1 <= alumode[`ALUMODE_WIDTH*4-1:`ALUMODE_WIDTH*3]; 
    alumode_2 <= alumode[`ALUMODE_WIDTH*3-1:`ALUMODE_WIDTH*2]; 
    alumode_3 <= alumode[`ALUMODE_WIDTH*2-1:`ALUMODE_WIDTH]; 
    alumode_4 <= alumode[`ALUMODE_WIDTH-1:0];
    
    inmode_1 <= inmode[`INMODE_WIDTH*4-1:`INMODE_WIDTH*3]; 
    inmode_2 <= inmode[`INMODE_WIDTH*3-1:`INMODE_WIDTH*2]; 
    inmode_3 <= inmode[`INMODE_WIDTH*2-1:`INMODE_WIDTH]; 
    inmode_4 <= inmode[`INMODE_WIDTH-1:0];
    
    opmode_1 <= opmode[`OPMODE_WIDTH*4-1:`OPMODE_WIDTH*3]; 
    opmode_2 <= opmode[`OPMODE_WIDTH*3-1:`OPMODE_WIDTH*2]; 
    opmode_3 <= opmode[`OPMODE_WIDTH*2-1:`OPMODE_WIDTH]; 
    opmode_4 <= opmode[`OPMODE_WIDTH-1:0];
    
    cea2_1 <= cea2[3]; 
    cea2_2 <= cea2[2]; 
    cea2_3 <= cea2[1]; 
    cea2_4 <= cea2[0];
    
    ceb2_1 <= ceb2[3]; 
    ceb2_2 <= ceb2[2]; 
    ceb2_3 <= ceb2[1]; 
    ceb2_4 <= ceb2[0]; 
    
    usemult_1 <= usemult[3]; 
    usemult_2 <= usemult[2]; 
    usemult_3 <= usemult[1]; 
    usemult_4 <= usemult[0]; 
end

alu core_1 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_1), 
	.b_i(b_1), 
	.c_i(c_1), 
	.alumode_i(alumode_1), 
	.inmode_i(inmode_1), 
	.opmode_i(opmode_1), 
	.cea2_i(cea2_1), 
	.ceb2_i(ceb2_1), 
	.usemult_i(usemult_1), 
	.p_o(p_o_1)
); 
    
alu core_2 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_2), 
	.b_i(b_2), 
	.c_i(c_2), 
	.alumode_i(alumode_2), 
	.inmode_i(inmode_2), 
	.opmode_i(opmode_2), 
	.cea2_i(cea2_2), 
	.ceb2_i(ceb2_2), 
	.usemult_i(usemult_2),  
	.p_o(p_o_2)
); 

alu core_3 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_3), 
	.b_i(b_3), 
	.c_i(c_3), 
	.alumode_i(alumode_3),  
	.inmode_i(inmode_3),  
	.opmode_i(opmode_3), 
	.cea2_i(cea2_3), 
	.ceb2_i(ceb2_3), 
	.usemult_i(usemult_3), 
	.p_o(p_o_3)
); 

alu core_4 (
	.clk(clk), 
	.rst(rst), 
	.a_i(a_4), 
	.b_i(b_4), 
	.c_i(c_4), 
	.alumode_i(alumode_4), 
	.inmode_i(inmode_4), 
	.opmode_i(opmode_4), 
	.cea2_i(cea2_4), 
	.ceb2_i(ceb2_4), 
	.usemult_i(usemult_4), 
	.p_o(p_o_4)
); 

endmodule