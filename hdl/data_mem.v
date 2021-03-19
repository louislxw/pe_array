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
// Additional Comments: 2 cycles to write in; 2 cycles to read out
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module data_mem(
    clk, rst, wea, web, wec, wed, dina, dinb, rden, inst_v, inst, shift_v, douta, doutb
    );
 
input clk; 
input rst;
input wea; 
input web; 
input wec;
input wed; // write back
input [`DATA_WIDTH*2-1:0] dina;
input [`DATA_WIDTH*2-1:0] dinb;
input rden;
input inst_v;
input [`INST_WIDTH-1:0] inst;
input shift_v;

output [`DATA_WIDTH*2-1:0] douta;
output [`DATA_WIDTH*2-1:0] doutb;

//wire [`DM_ADDR_WIDTH-1:0] raddra, raddrb, waddra, waddrb;
// 8-bit read/write address
//assign raddrb = rst ? 0 : inst[23:16]; 
//assign raddra = rst ? 0 : inst[15:8]; 
//assign waddra = rst ? 0 : inst[7:0]; 

reg [`DM_ADDR_WIDTH-1:0] raddra = 0;
reg [`DM_ADDR_WIDTH-1:0] raddrb = 0;
reg [`DM_ADDR_WIDTH-1:0] raddrc = 0;
reg [`DM_ADDR_WIDTH-1:0] waddra = 0;
reg [`DM_ADDR_WIDTH-1:0] waddrb = 8'h20; // Y shift address: 32
reg [`DM_ADDR_WIDTH-1:0] waddrc = 8'hA0; // alpha[k-1] address: 160
reg [`DM_ADDR_WIDTH-1:0] waddrd = 8'h40; // write-back address: 64
reg [`DM_ADDR_WIDTH-1:0] wb_addr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr_d1, wb_addr_d2, wb_addr_d3, wb_addr_d4, wb_addr_d5;
reg [`DM_ADDR_WIDTH-1:0] waddr;
reg dina_v, dinb_v;
//reg [`DATA_WIDTH*2-1:0] dinb_r;
reg shift_v_r;

always @(posedge clk) begin
    wb_addr_d1 <= wb_addr; 
    wb_addr_d2 <= wb_addr_d1; 
    wb_addr_d3 <= wb_addr_d2; 
    wb_addr_d4 <= wb_addr_d3; // write back requires a few delays
    wb_addr_d5 <= wb_addr_d4; // write back requires a few delays
//    dinb_r <= dinb;
    shift_v_r <= shift_v;
    
    if (rst) begin
        waddra <= 0;
        waddrb = 8'h20; // Add 
        waddrc = 8'hA0; // Add 
        waddrd = 8'h40; // Add 
        raddra <= 0;
        raddrb <= 0;
        raddrc <= 0;
        dina_v <= 0;
        dinb_v <= 0;
    end
    else begin
        if (wea) begin // write enable for LOAD 
            waddra <= waddra + 1;
            waddr <= waddra;
            dina_v <= 1;
            dinb_v <= 0;
        end
        else if (web) begin // write enable for SHIFT 
            waddrb <= waddrb + 1;
            waddr <= waddrb;
            dina_v <= 1;
            dinb_v <= 0;
        end
        else if (wec) begin // write enable for TX
            waddrc <= waddrc + 1;
            waddr <= waddrc;
            dina_v <= 1;
            dinb_v <= 0;
        end
        else if (wed) begin // write enable for write back 
            waddrd <= wb_addr_d5; // wb_addr_d4
            waddr <= waddrd;
            dina_v <= 0;
            dinb_v <= 1;
        end
        else begin
            waddra <= 0;
            waddrb = 8'h20; // Add 
            waddrc = 8'hA0; // Add 
            waddrd = 8'h40; // Add 
            dina_v <= 0;
            dinb_v <= 0;
        end
           
//        if (inst_v) begin // read ports & write-back address
//            raddrb <= inst[23:16]; // source 2
//            raddra <= inst[15:8]; // source 1
//            wb_addr <= inst[7:0]; // destination
//        end
//        else if (shift_v)
//            raddra <= raddra + 1;
//        else begin
//            raddrb <= 0;
//            raddra <= 0;
//        end
        
        if (~inst_v && ~shift_v) begin 
            raddrb <= 0;
            raddra <= 0;
            raddrc <= 0;
        end
        else if (inst_v) begin // read ports & write-back address
            raddrb <= inst[23:16]; // source 2
            raddra <= inst[15:8]; // source 1
            wb_addr <= inst[7:0]; // destination
        end
        else if (shift_v) begin
            raddrc <= raddrc + 1;
            raddra <= raddrc;
        end

    end 
end

wire wren;
wire [`DATA_WIDTH*2-1:0] din_bram;
assign wren = dina_v | dinb_v;
assign din_bram = dina_v ? dina : (dinb_v ? dinb : 0); // dina is already pipelined by CTRL

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