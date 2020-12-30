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
// Dependencies: 70 LUTs, 49 FFs, 1.0 BRAM (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module data_mem(
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

reg [`DM_ADDR_WIDTH-1:0] raddra = 0;
reg [`DM_ADDR_WIDTH-1:0] raddrb = 0;
reg [`DM_ADDR_WIDTH-1:0] waddra = 0;
reg [`DM_ADDR_WIDTH-1:0] waddrb = 8'h8F;
reg [`DM_ADDR_WIDTH-1:0] wb_addr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr_d1, wb_addr_d2, wb_addr_d3, wb_addr_d4;
reg wben_r; // ADD

always @(posedge clk) begin
    wben_r <= wben;
    wb_addr_d1 <= wb_addr; 
    wb_addr_d2 <= wb_addr_d1; 
    wb_addr_d3 <= wb_addr_d2; 
    wb_addr_d4 <= wb_addr_d3; // write back requires a few delays
    
    if (rst) begin
        waddra <= 0;
        waddrb = 8'h8F; // Add 
        raddra <= 0;
        raddrb <= 0;
    end
    else begin
        if (wea) begin // write enable for load or write back
            waddra <= waddra + 1;
        end
        else if (wben) begin // write enable for write back 
            waddra <= wb_addr_d4; 
        end
        else if (inst_v) begin
            raddrb <= inst[23:16]; // source 2
            raddra <= inst[15:8]; // source 1
            wb_addr <= inst[7:0]; // destination
        end
        
        if (web) begin
            waddrb <= waddrb + 1;
        end
    end 
end

wire wea_real;
assign wea_real = wea | wben_r;

/*** Block RAM for din_pe & dout_alu ***/
//(* ram_style="block" *)
//reg [`DATA_WIDTH*2-1:0] regfile [0:(2**`DM_ADDR_WIDTH)-1];
//reg [`DATA_WIDTH*2-1:0] douta = 0;

//always @(posedge clk) begin
//    if (wea_real) begin // write enable for load or write back
//        regfile[waddra] <= dina; 
//    end
//    else if (web) begin
//        regfile[waddrb] <= dinb; 
//    end
//    if (rden) begin 
//        douta <= regfile[raddra]; 
//    end
//end

/*** ADD another Block RAM for din_tx ***/
//(* ram_style="block" *)
//reg [`DATA_WIDTH*2-1:0] regfile1 [0:(2**`DM_ADDR_WIDTH)-1];
//reg [`DATA_WIDTH*2-1:0] doutb = 0;

//always @(posedge clk) begin
//    if (wea_real) begin
//        regfile1[waddra] <= dina;
//    end 
//    else if (web) begin // write enable for transfer data
//        regfile1[waddrb] <= dinb; 
//    end
//    if (rden) begin 
//        doutb <= regfile1[raddrb];
//    end
//end

wire wren;
assign wren = wea | wben_r | web;
wire [`DATA_WIDTH*2-1:0] din_bram;
assign din_bram = wea_real ? dina : (web ? dinb : 0);
wire [`DM_ADDR_WIDTH-1:0] waddr;
assign waddr = wea_real ? waddra : (web ? waddrb : 0);

//  Xilinx Simple Dual Port Single Clock RAM (RAMB18E2)
  sdp_bram #(
    .RAM_WIDTH(32),                       // Specify RAM data width
    .RAM_DEPTH(256),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) data_bram_0 (
    .addra(waddr),   // Write address bus, width determined from RAM_DEPTH
    .addrb(raddra),   // Read address bus, width determined from RAM_DEPTH
    .dina(din_bram),     // RAM input data, width determined from RAM_WIDTH
    .clka(clk),     // Clock
    .wea(wren),       // Write enable
    .enb(rden),	     // Read Enable, for additional power savings, disable when not in use
    .rstb(rst),     // Output reset (does not affect memory contents)
    .regceb(1), // Output register enable
    .doutb(douta)    // RAM output data, width determined from RAM_WIDTH
  );

//  Xilinx Simple Dual Port Single Clock RAM (RAMB18E2)
  sdp_bram #(
    .RAM_WIDTH(32),                       // Specify RAM data width
    .RAM_DEPTH(256),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) data_bram_1 (
    .addra(waddr),   // Write address bus, width determined from RAM_DEPTH
    .addrb(raddrb),   // Read address bus, width determined from RAM_DEPTH
    .dina(din_bram),     // RAM input data, width determined from RAM_WIDTH
    .clka(clk),     // Clock
    .wea(wren),       // Write enable
    .enb(rden),	     // Read Enable, for additional power savings, disable when not in use
    .rstb(rst),     // Output reset (does not affect memory contents)
    .regceb(1), // Output register enable
    .doutb(doutb)    // RAM output data, width determined from RAM_WIDTH
  );
    
endmodule