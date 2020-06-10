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
    clk, rst, wren, rden, inst, wdata, rdata0, rdata1
    );

input clk; 
input rst;
input wren; 
input rden;
input [`INST_WIDTH-1:0] inst;
input [`DATA_WIDTH*2-1:0] wdata;
output reg [`DATA_WIDTH*2-1:0] rdata0;
output reg [`DATA_WIDTH*2-1:0] rdata1;

//wire [`DM_ADDR_WIDTH-1:0] raddr0, raddr1, waddr;
// 8-bit read/write address
//assign raddr0 = inst[7:0]; 
//assign raddr1 = inst[15:8]; 
//assign waddr = inst[23:16]; 

//wire [1:0] sel;
//assign sel = inst[`INST_WIDTH-2:`INST_WIDTH-3];

(* ram_style="block" *)
reg [`DATA_WIDTH*2-1:0] regfile [(2**`DM_ADDR_WIDTH)-1:0];
reg [`DM_ADDR_WIDTH-1:0] raddr0, raddr1, waddr;

always @(posedge clk) begin
    if (rst) begin
        waddr <= 0;
        raddr0 <= 0;
        raddr1 <= 0;
        rdata0 <= 0;
        rdata1 <= 0;
    end
    else begin
        raddr0 <= inst[7:0]; 
        raddr1 <= inst[15:8]; 
        waddr <= inst[23:16];
    end
    if (wren) begin
        regfile[waddr] <= wdata; 
    end
    if (rden) begin
        rdata0 <= regfile[raddr0]; 
        rdata1 <= regfile[raddr1];
    end
end
    
endmodule
