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
    clk, rst, din_v, din_pe, inst_in_v, inst_in, fwd_v, dout_fwd, dout_v, dout_pe, inst_out_v, inst_out
    );
    
input  clk;
input  rst;
input  din_v;
//input  [`DATA_WIDTH*2-1:0] din_ld;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  inst_in_v;
input  [`INST_WIDTH-1:0] inst_in;

output fwd_v;
output [`DATA_WIDTH*2-1:0] dout_fwd;
output dout_v;
output [`DATA_WIDTH*2-1:0] dout_pe;
output inst_out_v;
output [`INST_WIDTH-1:0] inst_out;

reg [`DATA_WIDTH*2-1:0] dout_fwd;

reg inst_out_v = 0;
reg [`INST_WIDTH-1:0] inst_out;

wire [`INST_WIDTH-1:0] inst_pc; // instructions triggered by program counter

wire [`ALUMODE_WIDTH*4-1:0] alumode; // 4-bit * 4
wire [`INMODE_WIDTH*4-1:0] inmode;   // 5-bit * 4 
wire [`OPMODE_WIDTH*4-1:0] opmode;   // 7-bit * 4
wire [3:0] cea2;    // 1-bit * 4
wire [3:0] ceb2;    // 1-bit * 4
wire [3:0] usemult; // 1-bit * 4

wire [`DATA_WIDTH*2-1:0] wdata, rdata0, rdata1; 

//reg [`DATA_WIDTH*2-1:0] shift_array [0:`REG_NUM-1]; 
//reg [`REG_NUM-1:0] addr = 0;
//always @ (posedge clk) begin
//    if (addr != 31) begin
//        shift_array[addr] <= din_pe; 
//        addr <= addr + 1;
//    end
//    else begin
//        dout_fwd <= din_pe;
//        addr <= 0;
//    end
//end

always @ (posedge clk) begin
    inst_out_v <= inst_in_v;
    inst_out <= inst_in;
end

// shift register array for din_pe
reg load_v;
reg shift_v; // triggered by the negedge of ctrl signal
reg [`REG_ADDR_WIDTH-1:0] dc = 0; // data counter for shift_reg
reg [`DATA_WIDTH*2-1:0] shift_reg [0:`REG_NUM-1]; 
integer i;
always @ (posedge clk) begin 
    if (load_v) begin  // should last for 32 cycles
        for(i = `REG_NUM-1; i > 0; i = i-1) begin
            shift_reg[i] <= shift_reg[i-1];
        end
        shift_reg[0] <= din_pe;
        dc <= dc + 1;
        if (dc == `REG_NUM-1) begin
            load_v <= 0;
            dout_fwd <= din_pe;
        end    
    end
    if (shift_v) begin
        for(i = `REG_NUM-1; i > 0; i = i-1) 
            shift_reg[i] <= shift_reg[i-1];
        shift_reg[0] <= din_pe;
        dc <= dc + 1;
        if (dc == `REG_NUM-1) begin
            shift_v <= 0;
        end          
    end
end

//assign dout_v = [`DATA_WIDTH*2-1:0]shift_reg[FFT_NUM-1]; 

// Instruction Memory
inst_mem IMEM(
    .clk(clk), 
    .rst(rst), 
    .inst_v(inst_in_v), 
    .inst_in(inst_in), 
//    .shift_v(shift_v),
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

wire rden; // read enable signal for DMEM
assign rden = inst_pc[`INST_WIDTH-5]; // bit: 59

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
