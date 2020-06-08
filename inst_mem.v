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
input valid;
input [`INST_WIDTH-1:0] inst_in;
output[`INST_WIDTH-1:0] inst_out;
 
wire wr_en, ctrl;
reg  wr_en_r;
	
assign wr_en = (inst_in!=0) & (~ctrl);
    
(* ram_style="block" *)
reg [`INST_WIDTH-1:0] imem [(2**`IM_ADDR_WIDTH)-1:0];
reg [`INST_WIDTH-1:0] inst_out, inst_in_r;
reg [`IM_ADDR_WIDTH-1:0] addr;
reg [`IM_ADDR_WIDTH-1:0] inst_addr = 0;
reg [`IM_ADDR_WIDTH-1:0] pc = 0;

always @(posedge clk) begin 
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
    
endmodule
