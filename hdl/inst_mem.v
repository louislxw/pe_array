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
// Description: Instruction Memory implemented by half a Block RAM
// 
// Dependencies: 25 LUTs, 18 FFs, 0.5 BRAM (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module inst_mem(
    clk, rst, inst_in_v, inst_in, inst_out_v, inst_out
    );

input clk;
input rst;
input inst_in_v; 
input [`INST_WIDTH-1:0] inst_in;

output inst_out_v;
output [`INST_WIDTH-1:0] inst_out;

wire wr_en;
wire control; 
reg  control_d1 = 0;
assign wr_en = inst_in_v & (~control);
assign inst_out_v = control_d1;
 
wire [`IM_ADDR_WIDTH-1:0] addr;
assign addr = control ? pc : inst_cnt; // read or write

/*** BRAM-based Instruction Memory (perhaps can be changed to LUT-based) ***/
(* ram_style="block" *)
reg [`INST_WIDTH-1:0] imem [0:(2**`IM_ADDR_WIDTH)-1];
reg [`INST_WIDTH-1:0] inst_out = 0;
reg [`IM_ADDR_WIDTH-1:0] inst_cnt = 0;
reg [`IM_ADDR_WIDTH-1:0] pc = 0;

always @(posedge clk) begin 
    if (rst) begin
        pc <= 0;
        inst_cnt <= 0;
    end
    else if (wr_en) begin
        imem[addr] <= inst_in; // load instructions to IMEM
        inst_cnt <= inst_cnt + 1;
    end
    else if (control) 
        pc <= pc + 1; // program counter
    else
        pc <= 0;
    inst_out <= imem[addr]; // instructions triggered by program counter
end

/*** Control Logics for Instruction Memory ***/
parameter DELAY = 16; // how to set automatically set DELAY
reg [DELAY-1:0] shift_reg = 0;

always @ (posedge clk) begin 
    shift_reg <= {shift_reg[DELAY-2:0], inst_in_v};
end

assign control = shift_reg[DELAY-1]; // signal to triger the program counter

always@(posedge clk) begin
    control_d1 <= control; 
end

endmodule