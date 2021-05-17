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
    clk, rst, wea, web, wec, wed, dina, dinb, inst, rea, rec, douta, doutb, doutc, doutd
    );
 
input clk; 
input rst;
input wea; 
input web; 
input wec;
input wed; // write back
input [`DATA_WIDTH*2-1:0] dina;
input [`DATA_WIDTH*2-1:0] dinb;
//input rden;
//input inst_v;
input [`INST_WIDTH-1:0] inst;
input rea;
input rec;

output [`DATA_WIDTH*2-1:0] douta;
output [`DATA_WIDTH*2-1:0] doutb;
output [`DATA_WIDTH*2-1:0] doutc;
output [`DATA_WIDTH*2-1:0] doutd;

//wire [`DM_ADDR_WIDTH-1:0] raddra, raddrb, waddra, waddrb;
// 8-bit read/write address
//assign raddrb = rst ? 0 : inst[23:16]; 
//assign raddra = rst ? 0 : inst[15:8]; 
//assign waddra = rst ? 0 : inst[7:0]; 

reg [`DM_ADDR_WIDTH-1:0] raddra = 0;
reg [`DM_ADDR_WIDTH-1:0] raddrb = 0;
reg [`DM_ADDR_WIDTH-1:0] raddrc = 0;
reg [`DM_ADDR_WIDTH-1:0] raddrd = 8'h20; // Y shift address: 32
reg [`DM_ADDR_WIDTH-1:0] waddra = 0;
reg [`DM_ADDR_WIDTH-1:0] waddrb = 8'h20; // Y shift address: 32
reg [`DM_ADDR_WIDTH-1:0] waddrc = 8'h90; // alpha[k-1] address: 144
reg [`DM_ADDR_WIDTH-1:0] waddrd = 8'h40; // write-back address: 64
reg [`DM_ADDR_WIDTH-1:0] wb_addr = 0;
reg [`DM_ADDR_WIDTH-1:0] wb_addr_d1, wb_addr_d2, wb_addr_d3, wb_addr_d4, wb_addr_d5;
//reg [`DM_ADDR_WIDTH-1:0] waddr;
reg [`DM_ADDR_WIDTH-1:0] waddr0, waddr1;
reg dina_v, dinb_v;
reg load_v, shift_v, wb_v, tx_v;
//reg [`DATA_WIDTH*2-1:0] dinb_r;
//reg shift_v_r;
reg rea_r, rec_r;

always @(posedge clk) begin
    wb_addr_d1 <= wb_addr; 
    wb_addr_d2 <= wb_addr_d1; 
    wb_addr_d3 <= wb_addr_d2; 
    wb_addr_d4 <= wb_addr_d3; 
    wb_addr_d5 <= wb_addr_d4; // write back requires a few delays
//    dinb_r <= dinb;
//    shift_v_r <= shift_v;
    rea_r <= rea;
    rec_r <= rec;
    
    if (rst) begin
        waddra <= 0;
        waddrb = 8'h20; // will be changed 
        waddrc = 8'h90; // Add 
        waddrd = 8'h40; // Add 
        raddra <= 0;
        raddrb <= 0;
        raddrc <= 0;
        raddrd <= 8'h20;
//        dina_v <= 0;
//        dinb_v <= 0;
        load_v <= 0;
        shift_v <= 0;
        wb_v <= 0;
        tx_v <= 0;
    end
    else begin
        if (wea) begin // write enable for LOAD 
            waddra <= waddra + 1;
//            waddr <= waddra;
            waddr0 <= waddra;
            waddr1 <= waddra;
//            dina_v <= 1;
//            dinb_v <= 0;
            load_v <= 1;
            shift_v <= 0;
            wb_v <= 0;
//            tx_v <= 0;
        end
        else if (web) begin // write enable for slave_shift 
            waddrb <= waddrb + 1;
//            waddr <= waddrb;
            waddr0 <= waddrb;
            waddr1 <= waddrb;
//            dina_v <= 1;
//            dinb_v <= 0;
            load_v <= 0;
            shift_v <= 1;
            wb_v <= 0;
//            tx_v <= 0;
        end
        else if (wed) begin // write enable for write back 
            waddrd <= wb_addr_d5; // wb_addr_d4
//            waddr <= waddrd;
            waddr0 <= waddrd;
//            dina_v <= 0;
//            dinb_v <= 1;
            load_v <= 0;
            shift_v <= 0;
            wb_v <= 1;
//            tx_v <= 0;
        end
        else begin
            waddra <= 0;
            waddrb = 8'h20; // will be changed  
            waddrd = 8'h40; // Add 
//            dina_v <= 0;
//            dinb_v <= 0;
            load_v <= 0;
            shift_v <= 0;
            wb_v <= 0;
//            tx_v <= 0;
        end
        
        if (wec) begin // write enable for TX
            waddrc <= waddrc + 1;
//            waddr <= waddrc;
            waddr1 <= waddrc;
//            dina_v <= 1;
//            dinb_v <= 0;
            tx_v <= 1;
        end
        else begin
            waddrc = 8'h90; 
            tx_v <= 0;
        end
         
        if (rea) begin // read ports & write-back address 
            raddrb <= inst[23:16]; // source 2
            raddra <= inst[15:8]; // source 1
            wb_addr <= inst[7:0]; // destination
        end
        else begin
            raddrb <= 0;
            raddra <= 0;
        end
                
        if (inst[31:29] == 3'b111) // MAX instruction
            raddrc <= inst[23:16]; // source 2
        else 
            raddrc <= 0;
        
        if (rec_r) // SHIFT OUT
            raddrd <= raddrd + 1;
        else 
            raddrd <= 8'h20;
        
    end 
end

wire wren, wren1;
wire [`DATA_WIDTH*2-1:0] din_bram, din_bram1;
//assign wren = dina_v | dinb_v; // write enable is same for BRAM0 to BRAM2
//assign din_bram = dina_v ? dina : (dinb_v ? dinb : 0);
assign wren = load_v | shift_v | wb_v; // write enable is same for BRAM0 & BRAM1
assign wren1 = load_v | shift_v | tx_v; // write enable for BRAM2
assign din_bram = (load_v | shift_v) ? dina : (wb_v ? dinb : 0);
assign din_bram1 = wren1 ? dina : 0;

wire ren1, ren2;
assign ren1 = (inst[31:29] == 3'b111) ? 1 : 0;
assign ren2 = rec_r;
//assign ren1 = rec_r | inst[31:29] == 3'b111; // rec_r | (~rec_r & rea_r);

//  A 3-port RAM which supports 2 reads and 1 write in a single cycle? (Two more RAMB18E2s are added to support 4 reads and 2 write concurrently.)
//  solution -> https://forums.xilinx.com/t5/Virtex-Family-FPGAs-Archived/3-port-BRAM/td-p/133954

  //  Xilinx Simple Dual Port Single Clock RAM (RAMB18E2)
  sdp_bram #(
    .RAM_WIDTH(32),                       // Specify RAM data width
    .RAM_DEPTH(256),                      // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) data_bram_0 (
    .addra(waddr0),   // Write address bus, width determined from RAM_DEPTH
    .addrb(raddra),   // Read address bus, width determined from RAM_DEPTH
    .dina(din_bram),  // RAM input data, width determined from RAM_WIDTH
    .clka(clk),       // Clock
    .wea(wren),       // Write enable
    .enb(rea_r),	  // Read Enable, for additional power savings, disable when not in use
    .rstb(rst),       // Output reset (does not affect memory contents)
    .regceb(1),       // Output register enable
    .doutb(douta)     // RAM output data, width determined from RAM_WIDTH
  );
  //  Xilinx Simple Dual Port Single Clock RAM (RAMB18E2)
  sdp_bram #(
    .RAM_WIDTH(32),                       // Specify RAM data width
    .RAM_DEPTH(256),                      // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) data_bram_1 (
    .addra(waddr0),   // Write address bus, width determined from RAM_DEPTH
    .addrb(raddrb),   // Read address bus, width determined from RAM_DEPTH
    .dina(din_bram),  // RAM input data, width determined from RAM_WIDTH
    .clka(clk),       // Clock
    .wea(wren),       // Write enable
    .enb(rea_r),	  // Read Enable, for additional power savings, disable when not in use
    .rstb(rst),       // Output reset (does not affect memory contents)
    .regceb(1),       // Output register enable
    .doutb(doutb)     // RAM output data, width determined from RAM_WIDTH
  );
  //  Xilinx Simple Dual Port Single Clock RAM (RAMB18E2)
  sdp_bram #(
    .RAM_WIDTH(32),                       // Specify RAM data width
    .RAM_DEPTH(256),                      // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) data_bram_2 (
    .addra(waddr1),   // Write address bus, width determined from RAM_DEPTH
    .addrb(raddrc),   // Read address bus, width determined from RAM_DEPTH
    .dina(din_bram1), // RAM input data, width determined from RAM_WIDTH
    .clka(clk),       // Clock
    .wea(wren1),      // Write enable
    .enb(ren1), 	  // Read Enable, for additional power savings, disable when not in use
    .rstb(rst),       // Output reset (does not affect memory contents)
    .regceb(1),       // Output register enable
    .doutb(doutc)     // RAM output data, width determined from RAM_WIDTH
  );
  //  Xilinx Simple Dual Port Single Clock RAM (RAMB18E2)
  sdp_bram #(
    .RAM_WIDTH(32),                       // Specify RAM data width
    .RAM_DEPTH(256),                      // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) data_bram_3 (
    .addra(waddr1),   // Write address bus, width determined from RAM_DEPTH
    .addrb(raddrd),   // Read address bus, width determined from RAM_DEPTH
    .dina(din_bram1), // RAM input data, width determined from RAM_WIDTH
    .clka(clk),       // Clock
    .wea(wren1),      // Write enable
    .enb(ren2), 	  // Read Enable, for additional power savings, disable when not in use
    .rstb(rst),       // Output reset (does not affect memory contents)
    .regceb(1),       // Output register enable
    .doutb(doutd)     // RAM output data, width determined from RAM_WIDTH
  );

//  //  Xilinx True Dual Port RAM, No Change, Single Clock
//  tdp_bram #(
//    .RAM_WIDTH(32),                       // Specify RAM data width
//    .RAM_DEPTH(256),                      // Specify RAM depth (number of entries)
//    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
//    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
//  ) data_bram_2 (
//    .addra(addra),   // Port A address bus, width determined from RAM_DEPTH
//    .addrb(addrb),   // Port B address bus, width determined from RAM_DEPTH
//    .dina(dina),     // Port A RAM input data, width determined from RAM_WIDTH
//    .dinb(dinb),     // Port B RAM input data, width determined from RAM_WIDTH
//    .clka(clka),     // Clock
//    .wea(wea),       // Port A write enable
//    .web(web),       // Port B write enable
//    .ena(ena),       // Port A RAM Enable, for additional power savings, disable port when not in use
//    .enb(enb),       // Port B RAM Enable, for additional power savings, disable port when not in use
//    .rsta(rsta),     // Port A output reset (does not affect memory contents)
//    .rstb(rstb),     // Port B output reset (does not affect memory contents)
//    .regcea(1), // Port A output register enable
//    .regceb(1), // Port B output register enable
//    .douta(douta),   // Port A RAM output data, width determined from RAM_WIDTH
//    .doutb(doutb)    // Port B RAM output data, width determined from RAM_WIDTH
//  );
    
endmodule