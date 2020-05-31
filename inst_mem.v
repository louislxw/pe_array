`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2020 15:02:38
// Design Name: 
// Module Name: inst_mem
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

module inst_mem(
    clk, rst, valid, tag, ins, inst, control_d7
    );
    
	parameter DATA_WIDTH = 32;
	parameter INS_WIDTH	= 40;
	parameter INST_WIDTH = 32;
	parameter TAG_WIDTH	= 8;
	
	parameter RAM_WIDTH = 32;
    parameter RAM_ADDR_BITS = 5;

	input clk;
	input rst;
	input valid;
	input [TAG_WIDTH-1:0] tag;
	input [INS_WIDTH-1:0] ins;
	output[RAM_WIDTH-1:0] inst;
	output control_d7;

	reg control = 0;
	reg control_d1, control_d2, control_d3, control_d4, control_d5, control_d6, control_d7, control_d8, control_d9;


/******************** IMEM *************************/	 
	wire ena, wea;
	wire ctrl;
	reg wea_r;
	
	//assign ena  = (ins!=0);
	assign wea  = (ins!=0) & (tag == ins[39:32]) & (~ctrl);	//(tag == ins[39:32])
	assign ctrl = control | control_d1;


	(* RAM_STYLE="BLOCK" *)
//	(* RAM_STYLE="DISTRIBUTED" *)
	reg [RAM_WIDTH-1:0] imem [(2**RAM_ADDR_BITS)-1:0];
	reg [RAM_ADDR_BITS-1:0] inst_addr = 0;
	reg [RAM_WIDTH-1:0] inst, inst_r1;
	reg [RAM_ADDR_BITS-1:0] addr;
	reg [RAM_ADDR_BITS-1:0] pc = 0;

	always @(posedge clk) begin
      if (wea_r) begin	//wea
//				inst_addr <= inst_addr + 1;
//				imem[inst_addr] <= ins[RAM_WIDTH-1:0];
				imem[addr] <= inst_r1;
      end
		inst 	  <= imem[addr];
		
		
		if (ctrl) begin	//control
//			inst_r1 <= imem[pc];
			pc 	  <= pc + 1;
		end
		else
			pc <= 0;
   end
	
	
	always @(posedge clk)
	begin
		wea_r <= wea;
		inst_r1 <= ins[RAM_WIDTH-1:0];
//		imem[addr] <= ins[RAM_WIDTH-1:0];
		addr <= (ctrl) ? pc : inst_addr;
		if (wea)
			inst_addr <= inst_addr + 1;
	end

/******************** IMEM *************************/	


reg valid_d1;
reg valid_d2;
reg valid_d3;
reg valid_d4;
reg valid_d5;
reg valid_d6;
reg valid_d7;
reg valid_d8;
reg valid_d9;
reg valid_d10;
reg valid_d11;
reg valid_d12;
reg valid_d13;
reg valid_d14;
reg valid_d15;
reg valid_d16;

always @(*)
case (inst_addr)
			4'b0000: control <= 0;
			4'b0001: control <= (~valid) & (valid_d1);
			4'b0010: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2));
			4'b0011: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3));
			4'b0100: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4));
			4'b0101: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5));
			4'b0110: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6));
			4'b0111: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7));
			4'b1000: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8));
			4'b1001: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9));
			4'b1010: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9)) | ((~valid_d9) & (valid_d10));
			4'b1011: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9)) | ((~valid_d9) & (valid_d10)) | ((~valid_d10) & (valid_d11));
			4'b1100: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9)) | ((~valid_d9) & (valid_d10)) | ((~valid_d10) & (valid_d11)) | ((~valid_d11) & (valid_d12));
			4'b1101: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9)) | ((~valid_d9) & (valid_d10)) | ((~valid_d10) & (valid_d11)) | ((~valid_d11) & (valid_d12)) | ((~valid_d12) & (valid_d13));
			4'b1110: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9)) | ((~valid_d9) & (valid_d10)) | ((~valid_d10) & (valid_d11)) | ((~valid_d11) & (valid_d12)) | ((~valid_d12) & (valid_d13)) | ((~valid_d13) & (valid_d14));
			4'b1111: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9)) | ((~valid_d9) & (valid_d10)) | ((~valid_d10) & (valid_d11)) | ((~valid_d11) & (valid_d12)) | ((~valid_d12) & (valid_d13)) | ((~valid_d13) & (valid_d14)) | ((~valid_d14) & (valid_d15));
//			5'b10000: control <= ((~valid) & (valid_d1)) | ((~valid_d1) & (valid_d2)) | ((~valid_d2) & (valid_d3)) | ((~valid_d3) & (valid_d4)) | ((~valid_d4) & (valid_d5)) | ((~valid_d5) & (valid_d6)) | ((~valid_d6) & (valid_d7)) | ((~valid_d7) & (valid_d8)) | ((~valid_d8) & (valid_d9)) | ((~valid_d9) & (valid_d10)) | ((~valid_d10) & (valid_d11)) | ((~valid_d11) & (valid_d12)) | ((~valid_d12) & (valid_d13)) | ((~valid_d13) & (valid_d14)) | ((~valid_d14) & (valid_d15)) | ((~valid_d15) & (valid_d16));
endcase


always@(posedge clk)
begin
	if(rst)
	begin
		valid_d1 <= 0;
		valid_d2 <= 0;
		valid_d3 <= 0;
		valid_d4 <= 0;
		valid_d5 <= 0;
		valid_d6 <= 0;
		valid_d7 <= 0;
		valid_d8 <= 0;
		valid_d9 <= 0;	
		valid_d10 <= 0;
		valid_d11 <= 0;
		valid_d12 <= 0;
		valid_d13 <= 0;
		valid_d14 <= 0;
		valid_d15 <= 0;
		valid_d16 <= 0;
   	control_d1 <= 0;
		control_d2 <= 0;
		control_d3 <= 0;
		control_d4 <= 0;
		control_d5 <= 0;
		control_d6 <= 0;
		control_d7 <= 0;
		control_d8 <= 0;
		control_d9 <= 0;
	end
	else
	begin
		valid_d1 <= valid;
		valid_d2 <= valid_d1;
		valid_d3 <= valid_d2;
		valid_d4 <= valid_d3;
		valid_d5 <= valid_d4;
		valid_d6 <= valid_d5;
		valid_d7 <= valid_d6;
		valid_d8 <= valid_d7;
		valid_d9 <= valid_d8;
		valid_d10 <= valid_d9;
		valid_d11 <= valid_d10;
		valid_d12 <= valid_d11;
		valid_d13 <= valid_d12;
		valid_d14 <= valid_d13;
		valid_d15 <= valid_d14;
		valid_d16 <= valid_d15;
		control_d1 <= control;
		control_d2 <= control_d1;
		control_d3 <= control_d2;		
		control_d4 <= control_d3;
		control_d5 <= control_d4;
		control_d6 <= control_d5;
		control_d7 <= control_d6;
		control_d8 <= control_d7;
		control_d9 <= control_d8;
	end
end    
    
    
endmodule
