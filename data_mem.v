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
//assign raddr0 = rst ? 0 : inst[7:0]; 
//assign raddr1 = rst ? 0 : inst[15:8]; 
//assign waddr = rst ? 0 : inst[23:16]; 

//wire [1:0] sel;
//assign sel = inst[`INST_WIDTH-2:`INST_WIDTH-3];

reg wren_r, rden_r, wben_r; // ADD

always @(posedge clk) begin
    wren_r <= wren;
    rden_r <= rden;
    
    wben_r <= wben;
    
    wb_addr_d1 <= wb_addr; // 
    wb_addr_d2 <= wb_addr_d1; // 
    wb_addr_d3 <= wb_addr_d2; // 
    wb_addr_d4 <= wb_addr_d3; // 
    
end 

wire wb_en;
assign wb_en = wben | wben_r;
//
//parameter INST_DELAY = 5; 
//wire inst_v_d;
//reg [INST_DELAY-1:0] shift_reg = 0;
//always @ (posedge clk) begin 
//    shift_reg <= {shift_reg[INST_DELAY-2:0], inst_v};
//end
//assign inst_v_d = shift_reg[INST_DELAY-1]; // delayed_signal

(* ram_style="block" *)
reg [`DATA_WIDTH*2-1:0] regfile [0:(2**`DM_ADDR_WIDTH)-1];
reg [`DM_ADDR_WIDTH-1:0] raddr0 = 0;
reg [`DM_ADDR_WIDTH-1:0] raddr1 = 0;
reg [`DM_ADDR_WIDTH-1:0] waddr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr_d1, wb_addr_d2, wb_addr_d3, wb_addr_d4;
reg [`DATA_WIDTH*2-1:0] rdata0 = 0;
reg [`DATA_WIDTH*2-1:0] rdata1 = 0;
reg [`DATA_WIDTH*2-1:0] wdata_d1;

always @(posedge clk) begin
    if (rst) begin
        waddr <= 0;
        raddr0 <= 0;
        raddr1 <= 0;
//        rdata0 <= 0;
//        rdata1 <= 0;
    end
    
    if (inst_v) begin
        raddr0 <= inst[7:0]; 
        raddr1 <= inst[15:8]; 
        wb_addr <= inst[23:16]; // write back address
    end
//    else if (inst_v_d) begin // delay a few cycles to align with dout_alu 
//        waddr <= wb_addr_d4; 
//    end
    
    if (wren_r) begin // write enable for load & shift load
        waddr <= waddr + 1;
        regfile[waddr] <= wdata; 
    end
    else if (wb_en) begin // write enable for load & shift load
        waddr <= wb_addr_d4; 
        wdata_d1 <= wdata;
        regfile[waddr] <= wdata_d1;
    end
    
    if (rden_r) begin // rden
        rdata0 <= regfile[raddr0]; 
        rdata1 <= regfile[raddr1];
    end
    
end
    
endmodule
