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
// Description: Single PE with data forwarding support
// 
// Dependencies: 106 LUTs, 195 FFs, 1.5 BRAMs, 4 DSPs (doesn't meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module pe( 
    clk, rst, din_pe_v, din_pe, inst_in_v, inst_in, alpha_v, dout_pe_v, dout_pe, dout_fwd_v, dout_fwd
//    , inst_out_v, inst_out
    );
    
input  clk;
input  rst;
input  din_pe_v;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  inst_in_v;
input  [`INST_WIDTH-1:0] inst_in;
input  alpha_v;

output dout_pe_v;
output [`DATA_WIDTH*2-1:0] dout_pe;
output dout_fwd_v;
output [`DATA_WIDTH*2-1:0] dout_fwd;
//output reg inst_out_v;
//output reg [`INST_WIDTH-1:0] inst_out;

reg dout_pe_v;
reg [`DATA_WIDTH*2-1:0] dout_pe;
reg dout_fwd_v;
reg [`DATA_WIDTH*2-1:0] dout_fwd;

wire inst_out_v;
wire [`INST_WIDTH-1:0] inst_pc; // instructions triggered by program counter

wire [`ALUMODE_WIDTH*4-1:0] alumode; // 4-bit * 4
wire [`INMODE_WIDTH*4-1:0] inmode;   // 5-bit * 4 
wire [`OPMODE_WIDTH*4-1:0] opmode;   // 7-bit * 4
wire [3:0] cea2;    // 1-bit * 4
wire [3:0] ceb2;    // 1-bit * 4
wire [3:0] usemult; // 1-bit * 4

wire [`DATA_WIDTH*2-1:0] dout_ctrl;
wire [`DATA_WIDTH*2-1:0] rdata0, rdata1; 
wire [`DATA_WIDTH*2-1:0] dout_alu;
wire dout_alu_v;

//reg shift_v; // triggered by the negedge of ctrl signal
//reg load_v;
wire[2:0] opcode;
assign opcode = inst_pc[31:29]; 

always @ (posedge clk) begin
    if (opcode == 3'b000) begin // forward partial alpha
        dout_fwd_v <= 1;
        dout_fwd   <= dout_alu;
    end
    if (alpha_v) begin // output alpha (alpha_v = 1 when in last iteration)
        dout_pe_v <= 1;
        dout_pe <= dout_alu; 
    end
end

//always @ (posedge clk) begin
//    inst_out_v <= inst_in_v;
//    inst_out <= inst_in;
//end

parameter DELAY = 14;
reg shift_v = 0; 
reg [DELAY-1:0] shift_reg_v = 0;
always @ (posedge clk) begin 
    shift_reg_v <= {shift_reg_v[DELAY-2:0], shift_v};
end
wire shift_v_d;
assign shift_v_d = shift_reg_v[DELAY-1]; // valid signal for shift registers


// Instruction Memory
inst_mem IMEM(
    .clk(clk), 
    .rst(rst), 
    .inst_in_v(inst_in_v), 
    .inst_in(inst_in), 
    .inst_out_v(inst_out_v),
    .inst_out(inst_pc) // instructions triggered by program counter
    ); 

// Control Logics & Decoder
control CTRL(
    .clk(clk),
    .din_ld(din_pe), // din_ctrl
    .din_wb(dout_alu), // dout_pe
    .inst_v(inst_out_v),
    .inst(inst_pc), // instructions triggered by program counter
    .dout_v(dout_alu_v),
    .dout(dout_ctrl), // input data of DMEM
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult)
    );

//wire wren, rden; // write enable & read enable signal for DMEM
//assign wren = din_v | reg_v;
//assign rden = inst_out_v ? 1 : 0; // inst_pc[`INST_WIDTH-5] : 0; 

reg wren, rden; // register write/read enable signal to synchronize with dout_ctrl
reg [`REG_ADDR_WIDTH-1:0] dmem_count = 0; // counter for data memory
reg [`DATA_WIDTH*2-1:0] din_dmem;

always @ (posedge clk) begin
    if (din_pe_v && dmem_count <= `REG_NUM*2-1) begin
        wren <= 1;
//        din_dmem <= dout_ctrl;
        dmem_count <= dmem_count + 1;
    end
    else begin
        wren <= 0;
        dmem_count <= 0;
    end  
    if (inst_out_v)
        rden <= 1; // inst_pc[`INST_WIDTH-5]; 
    else
        rden <= 0;
end

always @ (posedge clk) 
    if (wren)
        din_dmem <= dout_ctrl;
        

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wren(wren), // valid for din_pe
    .wben(dout_alu_v), // valid for dout_alu
    .rden(rden), 
    .inst_v(inst_out_v),
    .inst(inst_pc), // instructions triggered by program counter
    .wdata(din_dmem), // dout_ctrl
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
    .dout(dout_alu) // dout_pe
    );    
    
endmodule