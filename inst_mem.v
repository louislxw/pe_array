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
    clk, rst, valid, inst_in, inst_out
    );

input clk;
input rst;
input valid; // instruction valid signal
input [`INST_WIDTH-1:0] inst_in;
output[`INST_WIDTH-1:0] inst_out;

wire wr_en, ctrl;
reg  wr_en_r;
reg  control, control_d1;
	
assign wr_en = valid & (~ctrl);
assign ctrl = control | control_d1;
//wire [`IM_ADDR_WIDTH-1:0] addr;
//assign addr = ctrl ? pc : inst_addr; // read or write

(* ram_style="block" *)
reg [`INST_WIDTH-1:0] imem [(2**`IM_ADDR_WIDTH)-1:0];
reg [`INST_WIDTH-1:0] inst_in_r;
reg [`INST_WIDTH-1:0] inst_out = 0;
reg [`IM_ADDR_WIDTH-1:0] addr;
reg [`IM_ADDR_WIDTH-1:0] inst_addr = 0;
reg [`IM_ADDR_WIDTH-1:0] pc = 0;

always @(posedge clk) begin 
    if (rst) begin
        pc <= 0;
//        addr <= 0;
//        inst_out <= 0;
    end
    if (wr_en_r) begin 
        imem[addr] <= inst_in_r;
    end
    inst_out <= imem[addr];
	
    // program counter
    if (ctrl) 
        pc <= pc + 1;
    else
        pc <= 0;
end

always @(posedge clk) begin
    wr_en_r <= wr_en;
    inst_in_r <= inst_in;
    addr <= ctrl ? pc : inst_addr; // read or write
    if (wr_en)
        inst_addr <= inst_addr + 1;
end

/*** Control Logics for Instruction Memory ***/
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
endcase

always@(posedge clk) begin
	if(rst) begin
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
		control_d1 <= 0;
	end
	else begin
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
		control_d1 <= control;
	end
end

endmodule
