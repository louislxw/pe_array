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
    clk, rst, inst_in_v, inst_in, inst_out_v, inst_out
    );

input clk;
input rst;
input inst_in_v; // instruction valid signal
input [`INST_WIDTH-1:0] inst_in;

//output shift_v;
output inst_out_v;
output [`INST_WIDTH-1:0] inst_out;

wire wr_en;
reg  wr_en_r;
wire control, ctrl; 
reg  control_d1 = 0;
reg  control_d2 = 0;
reg  ctrl_d1 = 0;
	
assign wr_en = inst_in_v & (~ctrl);
assign ctrl = control | control_d1; // signal to triger the program counter
assign inst_out_v = control_d2; // control_d2
//wire [`IM_ADDR_WIDTH-1:0] addr;
//assign addr = ctrl ? pc : inst_addr; // read or write

always @(posedge clk) begin
    ctrl_d1 <= ctrl; 
end

//assign shift_v = ~ctrl & ctrl_d1;

(* ram_style="block" *)
reg [`INST_WIDTH-1:0] imem [0:(2**`IM_ADDR_WIDTH)-1];
reg [`INST_WIDTH-1:0] inst_in_r;
reg [`INST_WIDTH-1:0] inst_out = 0;
reg [`IM_ADDR_WIDTH-1:0] addr;
reg [`IM_ADDR_WIDTH-1:0] inst_addr = 0;
reg [`IM_ADDR_WIDTH-1:0] pc = 0;

always @(posedge clk) begin 
    if (rst) begin
        pc <= 0;
        inst_addr <= 0;
//        inst_out <= 0;
    end
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

/*** Control Logics for Instruction Memory ***/
parameter DELAY = 16; // 9 // how to set automatically set DELAY with inst_addr

reg [DELAY-1:0] shift_reg = 0;
//wire delayed_signal; // inst_v

always @ (posedge clk) begin 
    shift_reg <= {shift_reg[DELAY-2:0], inst_in_v};
end

assign control = shift_reg[DELAY-1]; // delayed_signal

always@(posedge clk) begin
    control_d1 <= control;
    control_d2 <= control_d1;
end

endmodule
