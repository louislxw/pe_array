`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2020 15:03:06
// Design Name: 
// Module Name: data_mem
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

module data_mem(
    clk, en, valid, din, inst, src1, src2
    );
    
	parameter DATA_WIDTH = 32;
	parameter INS_WIDTH	= 40;
	parameter INST_WIDTH	= 32;
	parameter TAG_WIDTH	= 8;
	
	parameter RAM_WIDTH = 32;
	parameter RAM_ADDR_BITS = 5;

	input clk; 
	input en;
	input valid;
	input [`DATA_WIDTH-1:0] din;
	input [INST_WIDTH-1:0] inst;
	output reg[`DM_ADDR_WIDTH-1:0] src1;
	output reg[`DM_ADDR_WIDTH-1:0] src2;

	reg [`DM_ADDR_WIDTH-1:0] count = 0;
	wire [`DM_ADDR_WIDTH-1:0] src1_addr;
	
	
	(* ram_style="block" *)
	reg [`DATA_WIDTH-1:0] regfile [(2**`DM_ADDR_WIDTH)-1:0];
	reg [`DM_ADDR_WIDTH-1:0] addra, src2_addr;
	reg [`DATA_WIDTH-1:0] din_r;
	reg valid_r;

	always @(posedge clk) begin
      if (en) begin
         if (valid_r)	//valid
            begin
				regfile[addra] <= din_r; //din
				end
         src1 <= regfile[addra];
      end
      if (en)
		begin
			src2 <= regfile[src2_addr];
		end
   end


	always @(posedge clk) 
	begin
		src2_addr <= inst[5:1];
		addra <= (valid) ? count : src1_addr;
		din_r <= din;
		valid_r <= valid;
		if (valid)
			count <= count + 1;
		else 
			count <= 0;
   end
	
	assign src1_addr = inst[10:6];    
    
endmodule
