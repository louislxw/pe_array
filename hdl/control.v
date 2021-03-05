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
// Description: Instruction Decoder & Feedback Logics
// 
// Dependencies: 36 LUTs, 83 FFs (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module control(
//    clk, din_ld_v, din_ld, din_wb, inst_v, opcode, 
    clk, din_pe_v, din_pe, din_shift_v, din_shift, din_tx_v, din_tx, inst_v, opcode, 
    dout_v, dout, alumode, inmode, opmode, cea2, ceb2, usemult
    );
    
input clk;
//input din_ld_v;
//input [`DATA_WIDTH*2-1:0] din_ld; // 32-bit data
input din_pe_v;
input [`DATA_WIDTH*2-1:0] din_pe; // 32-bit data
input din_shift_v;
input [`DATA_WIDTH*2-1:0] din_shift; // 32-bit data
input din_tx_v;
input [`DATA_WIDTH*2-1:0] din_tx; // 32-bit data
//input [`DATA_WIDTH*2-1:0] din_wb; // 32-bit data
input inst_v;
input [2:0] opcode;

output dout_v;
output [`DATA_WIDTH*2-1:0] dout; // 32-bit
output [`ALUMODE_WIDTH*4-1:0] alumode; // 4-bit * 4
output [`INMODE_WIDTH*4-1:0] inmode;   // 5-bit * 4 
output [`OPMODE_WIDTH*4-1:0] opmode;   // 7-bit * 4
output [3:0] cea2;    // 1-bit * 4
output [3:0] ceb2;    // 1-bit * 4
output [3:0] usemult; // 1-bit * 4

reg [`DATA_WIDTH*2-1:0] dout; // 32-bit

/*** Control Logics for Data Ouput Valid Signal ***/
parameter DELAY = 6; // 6-stage pipeline
reg [DELAY-1:0] inst_v_reg = 0; 

always @ (posedge clk) begin 
    inst_v_reg <= {inst_v_reg[DELAY-2:0], inst_v};
end

assign dout_v = inst_v_reg[DELAY-1]; // delayed_signal

//always @ (posedge clk) begin
//    if (din_ld_v)
//        dout <= din_ld; // load data
//    if (dout_v)
//        dout <= din_wb; // write back
//end

always @ (posedge clk) begin
    if (din_pe_v)
        dout <= din_pe; // load 
    else if (din_shift_v)
        dout <= din_shift; // shift 
    else if (din_tx_v)
        dout <= din_tx; // transmit 
//    else if (dout_v)
//        dout <= din_wb; // write back
end

/***************** INSTRUCTION DECODE***************/	 
//wire[2:0] opcode;
//assign opcode = inst[31:29]; // inst[26:24]; 

//reg [2:0] opcode;
//always @ (posedge clk) 
//    opcode <= inst[31:29]; // inst[26:24]; 

reg [`ALUMODE_WIDTH*4-1:0] alumode = 0; // 4-bit * 4
reg [`INMODE_WIDTH*4-1:0]  inmode = 0;  // 5-bit * 4
reg [`OPMODE_WIDTH*4-1:0]  opmode = 0;  // 7-bit * 4
reg [3:0]  cea2 =  0;
reg [3:0]  ceb2 = 0;
reg [3:0]  usemult = 0;

always @ (posedge clk) 
case (opcode)
/*`ADD*/ 3'b001: begin 
	            alumode <= 16'b0000_0000_0000_0000; 
	            inmode <= 20'b00000_00000_00000_00000; 
	            opmode <= 28'b0110011_0110011_0110011_0110011; 
	            cea2 <= 4'b1111; ceb2 <= 4'b1111; usemult <= 4'b0000; 
             end
/*`SUB*/ 3'b010: begin 
	            alumode <= 16'b0011_0011_0011_0011; 
	            inmode <= 20'b00000_00000_00000_00000; 
	            opmode <= 28'b0110011_0110011_0110011_0110011; 
	            cea2 <= 4'b1111; ceb2 <= 4'b1111; usemult <= 4'b0000; 
	         end
/*`MUL*/ 3'b100: begin  // (MUL, MUL, MUL, MUL) verified!
	            alumode <= 16'b0000_0000_0000_0000; 
	            inmode <= 20'b10001_10001_10001_10001; 
	            opmode <= 28'b0000101_0000101_0000101_0000101; 
	            cea2 <= 4'b0000; 
	            ceb2 <= 4'b0000; 
	            usemult <= 4'b1111; 
	         end
/*`MULADD*/ 3'b101: begin  // (MULADD, MUL, MULADD, MUL) verified!
	            alumode <= 16'b0000_0000_0000_0000; 
	            inmode <= 20'b10001_10001_10001_10001; 
	            opmode <= 28'b0110101_0000101_0110101_0000101; 
	            cea2 <= 4'b0000; 
	            ceb2 <= 4'b0000; 
	            usemult <= 4'b1111; 
	          end
/*`MULSUB*/ 3'b110: begin  // (MULSUB, MUL, MULSUB, MUL) verified!
	            alumode <= 16'b0011_0000_0011_0000; 
	            inmode <= 20'b10001_10001_10001_10001; 
	            opmode <= 28'b0110101_0000101_0110101_0000101; 
	            cea2 <= 4'b0000; 
	            ceb2 <= 4'b0000; 
	            usemult <= 4'b1111; 
	          end
/*`MAX*/ 3'b111: begin // to be tested!
	            alumode <= 16'b1100_1100_1100_1100; 
	            inmode <= 20'b00000_00000_00000_00000; 
	            opmode <= 28'b0110011_0110011_0110011_0110011; 
	            cea2 <= 4'b0000; ceb2 <= 4'b0000; usemult <= 4'b1111; 
	          end
/*`LOAD*/ default: begin 
	            alumode <= 16'b0000_0000_0000_0000; 
	            inmode <= 20'b00000_00000_00000_00000; 
	            opmode <= 28'b0000000_0000000_0000000_0000000; 
	            cea2 <= 4'b0000; ceb2 <= 4'b0000; usemult <= 4'b0000; 
	          end
endcase
    
endmodule