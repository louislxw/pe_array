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
// Dependencies: 176 LUTs, 245 FFs, 1.5 BRAMs, 4 DSPs (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module pe( 
    clk, rst, din_pe_v, din_pe, din_tx_v, din_tx, inst_in_v, inst_in, alpha_v, 
    dout_pe_v, dout_pe, dout_tx_v, dout_tx
    );
    
input  clk;
input  rst;
input  din_pe_v;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  din_tx_v;
input  [`DATA_WIDTH*2-1:0] din_tx;
input  inst_in_v;
input  [`INST_WIDTH-1:0] inst_in;
input  alpha_v;

output reg dout_pe_v;
output reg [`DATA_WIDTH*2-1:0] dout_pe;
output reg dout_tx_v;
output reg [`DATA_WIDTH*2-1:0] dout_tx;


/*** wires for module connection ***/
wire inst_pc_v;
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

wire tx_flag;
assign tx_flag = dout_alu_v ? 1 : 0; // this will be changed later

always @ (posedge clk) begin
    if (tx_flag) begin // forward partial alpha
        dout_tx_v <= 1;
        dout_tx   <= dout_alu;
    end
    else begin
        dout_tx_v <= 0;
        dout_tx   <= 32'hxxxxxxxx; 
    end
    if (alpha_v) begin // output alpha (alpha_v = 1 when in last iteration)
        dout_pe_v <= 1;
        dout_pe   <= dout_alu; 
    end
end

//parameter DELAY = 14;
//reg shift_v = 0; 
//reg [DELAY-1:0] shift_reg_v = 0;
//always @ (posedge clk) begin 
//    shift_reg_v <= {shift_reg_v[DELAY-2:0], shift_v};
//end
//wire shift_v_d;
//assign shift_v_d = shift_reg_v[DELAY-1]; // valid signal for shift registers


// Instruction Memory
inst_mem IMEM(
    .clk(clk), 
    .rst(rst), 
    .inst_in_v(inst_in_v), 
    .inst_in(inst_in), 
    .inst_out_v(inst_pc_v),
    .inst_out(inst_pc) // instructions triggered by program counter
    ); 

// Control Logics & Decoder
control CTRL(
    .clk(clk),
    .din_ld_v(din_pe_v), 
    .din_ld(din_pe), 
    .din_wb(dout_alu), 
    .inst_v(inst_pc_v),
    .inst(inst_pc), // instructions triggered by program counter
    .dout_v(dout_alu_v),
    .dout(dout_ctrl), // data output of the controller
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult)
    );

reg load_v, re, re_d1; // register write/read enable signal to synchronize with dout_ctrl
reg [`REG_ADDR_WIDTH-1:0] dmem_count = 0; // counter for data memory

always @ (posedge clk) begin
    if (din_pe_v && dmem_count <= `REG_NUM*2-1) begin
        load_v <= 1;
        dmem_count <= dmem_count + 1;
    end
    else begin
        load_v <= 0;
        dmem_count <= 0;
    end  
    if (inst_pc_v) begin
        re <= 1; // inst_pc[`INST_WIDTH-5]; 
        re_d1 <= re;
    end    
    else begin
        re <= 0;
        re_d1 <= re;
    end 
end

wire ren;
assign ren = inst_pc_v ? 1: 0;

//wire [`DATA_WIDTH*2-1:0] din_comp;
//assign din_comp = load_v ? dout_ctrl : 32'hxxxxxxxx;  

wire dout_ctrl_v;
assign dout_ctrl_v = load_v | dout_alu_v;

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wea(dout_ctrl_v), // valid of dout_ctrl
    .web(din_tx_v), // valid of din_tx
    .dina(dout_ctrl), // din_comp
    .dinb(din_tx), // data transmitted from previous PE
    .wben(dout_alu_v), 
    .rden(re), // re
    .inst_v(inst_pc_v),
    .inst(inst_pc), // instructions triggered by program counter
    .douta(rdata0),
    .doutb(rdata1)
    );

wire [`DATA_WIDTH*2-1:0] dout_rom;
reg en;
reg [`WN_ADDR_WIDTH-1:0] addr; 
always @ (posedge clk) begin
    if (inst_pc[`INST_WIDTH-4]) // bit 28
        en <= 1'b1;
    else 
        en <= 1'b0;
    addr <= inst_pc[27:24];
end

const_rom ROM(
    .clk(clk), 
    .en(en), 
    .addr(addr), 
    .data_out(dout_rom)
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
    .din_3(dout_rom),
    .dout(dout_alu) 
    );    
    
endmodule