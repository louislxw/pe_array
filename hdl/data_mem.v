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
// Dependencies: 21 LUTs, 41 FFs, 1.0 BRAM (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module data_mem(
//    clk, rst, wren, wben, rden, inst_v, inst, wdata, rdata0, rdata1
    clk, rst, wea, web, dina, dinb, wben, rden, inst_v, inst, douta, doutb
    );
 
input clk; 
input rst;
input wea; 
input web; 
input [`DATA_WIDTH*2-1:0] dina;
input [`DATA_WIDTH*2-1:0] dinb;
input wben;
input rden;
input inst_v;
input [`INST_WIDTH-1:0] inst;

output [`DATA_WIDTH*2-1:0] douta;
output [`DATA_WIDTH*2-1:0] doutb;

//wire [`DM_ADDR_WIDTH-1:0] raddra, raddrb, waddra, waddrb;
// 8-bit read/write address
//assign raddrb = rst ? 0 : inst[23:16]; 
//assign raddra = rst ? 0 : inst[15:8]; 
//assign waddra = rst ? 0 : inst[7:0]; 

(* ram_style="block" *)
reg [`DATA_WIDTH*2-1:0] regfile [0:(2**`DM_ADDR_WIDTH)-1];
reg [`DM_ADDR_WIDTH-1:0] raddra = 0;
reg [`DM_ADDR_WIDTH-1:0] raddrb = 0;
reg [`DM_ADDR_WIDTH-1:0] waddra = 0;
reg [`DM_ADDR_WIDTH-1:0] waddrb = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr_d1, wb_addr_d2, wb_addr_d3, wb_addr_d4;
reg [`DATA_WIDTH*2-1:0] douta = 0;
reg [`DATA_WIDTH*2-1:0] doutb = 0;
reg wben_r; // ADD
reg wea_r; // ADD

always @(posedge clk) begin
    wea_r <= wea;
    wben_r <= wben;
    
    wb_addr_d1 <= wb_addr; 
    wb_addr_d2 <= wb_addr_d1; 
    wb_addr_d3 <= wb_addr_d2; 
    wb_addr_d4 <= wb_addr_d3; // write back requires a few delays
    
    if (rst) begin
        waddra <= 0;
        raddra <= 0;
        raddrb <= 0;
    end
    
    if (inst_v) begin
        raddrb <= inst[23:16]; // source 2
        raddra <= inst[15:8]; // source 1
        wb_addr <= inst[7:0]; // destination
    end
    
    if (wea) begin // write enable for load or write back
        waddra <= waddra + 1;
        regfile[waddra] <= dina; 
    end
    
    if (wben) begin // write enable for write back 
        waddra <= wb_addr_d4; 
    end
    
    if (wben_r) begin
        regfile[waddra] <= dina; 
    end
    
    if (rden) begin 
        douta <= regfile[raddra]; 
        doutb <= regfile[raddrb];
    end
    
end
    
endmodule
