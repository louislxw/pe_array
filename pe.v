`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2020 13:37:06
// Design Name: 
// Module Name: pe
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

module pe( 
    clk, rst, din_v, din_pe, inst_in_v, inst_in, dout_v, dout_pe, inst_out_v, inst_out
    );
    
input  clk;
input  rst;
input  din_v;
//input  [`DATA_WIDTH*2-1:0] din_ld;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  inst_in_v;
input  [`INST_WIDTH-1:0] inst_in;

output dout_v;
output [`DATA_WIDTH*2-1:0] dout_pe;
output inst_out_v;
output [`INST_WIDTH-1:0] inst_out;

reg inst_out_v;
reg [`INST_WIDTH-1:0] inst_out;

wire [`INST_WIDTH-1:0] inst_pc; // instructions triggered by program counter

wire [`ALUMODE_WIDTH*4-1:0] alumode; // 4-bit * 4
wire [`INMODE_WIDTH*4-1:0] inmode;   // 5-bit * 4 
wire [`OPMODE_WIDTH*4-1:0] opmode;   // 7-bit * 4
wire [3:0] cea2;    // 1-bit * 4
wire [3:0] ceb2;    // 1-bit * 4
wire [3:0] usemult; // 1-bit * 4

wire [`DATA_WIDTH*2-1:0] wdata, rdata0, rdata1; 

wire rden;
assign rden = inst_pc[`INST_WIDTH-5]; // bit: 59

always @ (posedge clk) begin
    inst_out_v <= inst_in_v;
    inst_out <= inst_in;
end

// Instruction Memory
inst_mem IMEM(
    .clk(clk), 
    .rst(rst), 
    .inst_v(inst_in_v), 
    .inst_in(inst_in), 
    .inst_out(inst_pc) // instructions triggered by program counter
    ); 

// Control Logics & Decoder
control CTRL(
    .clk(clk),
//    .din_ld(din_ld), 
    .din_pe(din_pe), 
    .din_wb(dout_pe), 
    .inst(inst_pc), // instructions triggered by program counter
    .dout_v(dout_v),
    .dout(wdata), // data_in for DMEM
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult)
    );

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wren(din_v), 
    .rden(rden), 
    .inst(inst_pc), // instructions triggered by program counter
    .wdata(wdata), 
    .rdata0(rdata0),
    .rdata1(rdata1)
    );

// ALU for Complex Data
complex_alu ALU( 
    .clk(clk), 
    .rst(rst), 
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult),
    .din_1(rdata0), 
    .din_2(rdata1), 
    .dout(dout_pe) 
    );    
    
endmodule
