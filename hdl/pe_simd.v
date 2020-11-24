`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2020 18:47:18
// Design Name: 
// Module Name: pe_simd
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Single PE for 32-bit complex operations
// 
// Dependencies: 108 LUTs, 134 FFs, 1.5 BRAMs, 4 DSPs (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module pe_simd( 
    clk, rst, din_v, din_pe, inst_in_v, inst_in, dout_v, dout_pe
    );
    
input  clk;
input  rst;
input  din_v;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  inst_in_v;
input  [`INST_WIDTH-1:0] inst_in;

output dout_v;
output [`DATA_WIDTH*2-1:0] dout_pe;

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

parameter DELAY = 14;
reg shift_v = 0; 
reg [DELAY-1:0] shift_reg_v = 0;
always @ (posedge clk) begin 
    shift_reg_v <= {shift_reg_v[DELAY-2:0], shift_v};
end
wire shift_v_d;
assign shift_v_d = shift_reg_v[DELAY-1]; // valid signal for shift registers

/*** shift register array for din_pe ***/
reg [`REG_ADDR_WIDTH-1:0] dc = 0; // data counter for shift_reg
reg [`DATA_WIDTH*2-1:0] shift_reg_data [0:`REG_NUM-1]; 
reg [`DATA_WIDTH*2-1:0] din_ctrl;
reg [`REG_ADDR_WIDTH-1:0] addr = 0;
integer i;
always @ (posedge clk) begin 
    if (din_v && dc <= `REG_NUM-1) begin  // should last for 32 cycles
        for(i = `REG_NUM-1; i > 0; i = i-1) begin
            shift_reg_data[i] <= shift_reg_data[i-1];
        end
        din_ctrl <= din_pe; // MUX
        shift_reg_data[0] <= din_pe;
        dc <= dc + 1;
        shift_v <= 1;
    end
    else if (din_v && dc > `REG_NUM-1) begin
        din_ctrl <= shift_reg_data[2**`REG_ADDR_WIDTH-addr]; // MUX
        addr <= addr + 1; // MUX
        shift_v <= 0;
//        dc <= 0;
    end
    else if (shift_v_d) begin // should last for 32 cycles
        for(i = `REG_NUM-1; i > 0; i = i-1) begin
            shift_reg_data[i] <= shift_reg_data[i-1];
        end
        shift_reg_data[0] <= din_pe;
    end
    else begin
        din_ctrl <= 0; // MUX
        shift_v <= 0;
    end
        
end


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
    .din_ld(din_ctrl), 
    .din_wb(dout_pe), 
    .inst_v(inst_out_v),
    .inst(inst_pc), // instructions triggered by program counter
    .dout_v(dout_v),
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
always @ (posedge clk) begin
    if (din_v && dmem_count <= `REG_NUM*2-1) begin
        wren <= 1;
        dmem_count <= dmem_count + 1;
    end
    else
        wren <= 0;
    
    if (inst_out_v)
        rden <= 1; // inst_pc[`INST_WIDTH-5]; 
    else
        rden <= 0;
end

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wren(wren), // valid for din_pe
    .wben(dout_v), // valid for dout_pe
    .rden(rden), 
    .inst_v(inst_out_v),
    .inst(inst_pc), // instructions triggered by program counter
    .wdata(dout_ctrl), 
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