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
// Description: Data Memory implemented by a Block RAM
// 
// Dependencies: 21 LUTs, 42 FFs, 1.0 BRAM (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module data_mem(
    clk, rst, wren, wben, rden, inst_v, inst, wdata, rdata0, rdata1
    );

input clk; 
input rst;
input wren; 
input wben;
input rden;
input inst_v;
input [`INST_WIDTH-1:0] inst;
input [`DATA_WIDTH*2-1:0] wdata;
output [`DATA_WIDTH*2-1:0] rdata0;
output [`DATA_WIDTH*2-1:0] rdata1;

//wire [`DM_ADDR_WIDTH-1:0] raddr0, raddr1, waddr;
// 8-bit read/write address
//assign raddr1 = rst ? 0 : inst[23:16]; 
//assign raddr0 = rst ? 0 : inst[15:8]; 
//assign waddr = rst ? 0 : inst[7:0]; 

(* ram_style="block" *)
reg [`DATA_WIDTH*2-1:0] regfile [0:(2**`DM_ADDR_WIDTH)-1];
reg [`DM_ADDR_WIDTH-1:0] raddr0 = 0;
reg [`DM_ADDR_WIDTH-1:0] raddr1 = 0;
reg [`DM_ADDR_WIDTH-1:0] waddr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr_d1, wb_addr_d2, wb_addr_d3, wb_addr_d4, wb_addr_d5;
reg [`DATA_WIDTH*2-1:0] rdata0 = 0;
reg [`DATA_WIDTH*2-1:0] rdata1 = 0;
reg wren_r, wben_r; // ADD

always @(posedge clk) begin
    wren_r <= wren;
    wben_r <= wben;
    
    wb_addr_d1 <= wb_addr; // 
    wb_addr_d2 <= wb_addr_d1; // 
    wb_addr_d3 <= wb_addr_d2; // 
    wb_addr_d4 <= wb_addr_d3; // 
    wb_addr_d5 <= wb_addr_d4; // 
    
    if (rst) begin
        waddr <= 0;
        raddr0 <= 0;
        raddr1 <= 0;
//        rdata0 <= 0;
//        rdata1 <= 0;
    end
    
    if (inst_v) begin
        raddr1 <= inst[23:16]; // source 2
        raddr0 <= inst[15:8]; // source 1
        wb_addr <= inst[7:0]; // destination
    end
    
    if (wren_r) begin // write enable for load & shift load 
        waddr <= waddr + 1;
        regfile[waddr] <= wdata; 
    end
    
    if (wben) begin // write enable for write back 
        waddr <= wb_addr_d4; 
//        regfile[wb_addr_d5] <= wdata; // waddr
    end
    
    if (wben_r) begin
        regfile[waddr] <= wdata; 
    end
    
    if (rden) begin 
        rdata0 <= regfile[raddr0]; 
        rdata1 <= regfile[raddr1];
    end
    
end
    
endmodule
