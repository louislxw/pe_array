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
// Description: Single PE with data forwarding support (-> Add the state machine)
//  IMEM: BRAM -> ROM
// Dependencies: 226 -> 265 LUTs, 295 -> 301 FFs, 1.5 BRAMs, 4 DSPs (meet 600MHz)
//  182 LTUs, 184 FFs, 1.0 BRAM, 4 DSPs (meet 600MHz)
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module pe( 
    clk, rst, din_pe_v, din_pe, din_shift_v, din_shift, din_tx_v, din_tx, 
//    inst_in_v, inst_in,  
    dout_pe_v, dout_pe, dout_tx_v, dout_tx, dout_shift_v, dout_shift
    );
    
input  clk;
input  rst;
input  din_pe_v;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  din_shift_v; // 
input  [`DATA_WIDTH*2-1:0] din_shift; //
input  din_tx_v;
input  [`DATA_WIDTH*2-1:0] din_tx;
//input  inst_in_v;
//input  [`INST_WIDTH-1:0] inst_in;
//input  alpha_v;

output reg dout_pe_v;
output reg [`DATA_WIDTH*2-1:0] dout_pe;
output reg dout_tx_v;
output reg [`DATA_WIDTH*2-1:0] dout_tx;
output reg dout_shift_v;
output reg [`DATA_WIDTH*2-1:0] dout_shift;

/*** wires for module connection ***/
wire [`ALUMODE_WIDTH*4-1:0] alumode; // 4-bit * 4
wire [`INMODE_WIDTH*4-1:0] inmode;   // 5-bit * 4 
wire [`OPMODE_WIDTH*4-1:0] opmode;   // 7-bit * 4
wire [3:0] cea2;    // 1-bit * 4
wire [3:0] ceb2;    // 1-bit * 4
wire [3:0] usemult; // 1-bit * 4

wire [`DATA_WIDTH*2-1:0] dout_ctrl;
wire [`DATA_WIDTH*2-1:0] rdata0, rdata1;
wire din_ld_v;
wire [`DATA_WIDTH*2-1:0] din_ld;
wire dout_alu_v;
wire [`DATA_WIDTH*2-1:0] dout_alu;

//wire inst_pc_v;  
wire [`INST_WIDTH-1:0] inst_pc; // instructions triggered by program counter

// Instruction Memory
//inst_mem IMEM(
//    .clk(clk), 
//    .rst(rst), 
//    .inst_in_v(inst_in_v), 
//    .inst_in(inst_in), 
//    .inst_out_v(inst_pc_v),
//    .inst_out(inst_pc) // instructions triggered by program counter
//    ); 

reg [`IM_ADDR_WIDTH-1:0] inst_addr;
always @ (posedge clk) 
    if (cmpt_v)
        inst_addr <= inst_addr + 1'b1;
    else
        inst_addr <= 0; 

reg cmpt_v_reg, inst_pc_v;
always @ (posedge clk) 
    inst_pc_v <= cmpt_v;

// Instruction ROM
inst_rom INST_ROM(
    .clk(clk), 
    .en(cmpt_v), 
    .addr(inst_addr), 
    .data_out(inst_pc)
    );

reg [2:0] opcode;
always @ (posedge clk) 
    opcode <= inst_pc[31:29]; 

assign din_ld_v = din_pe_v | din_shift_v;
assign din_ld = din_pe | din_shift;

// Control Logics & Decoder
control CTRL(
    .clk(clk),
    .din_ld_v(din_ld_v), // din_pe_v
    .din_ld(din_ld), // din_pe
    .din_wb(dout_alu), 
    .inst_v(inst_pc_v),
    .opcode(opcode), 
//    .inst(inst_pc), // instructions triggered by program counter
    .dout_v(dout_alu_v),
    .dout(dout_ctrl), // data output of the controller
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult)
    );

reg dmem_re; // register write/read enable signal to synchronize with dout_ctrl

always @ (posedge clk) begin
    if (inst_pc_v | shift_v) begin
        dmem_re <= 1; // inst_pc[`INST_WIDTH-5]; 
    end    
    else begin
        dmem_re <= 0;
    end 
end

wire dout_ctrl_v;
assign dout_ctrl_v = load_v | dout_alu_v;

always @ (posedge clk) 
    if (shift_v) begin
        dout_shift_v <= 1;
        dout_shift <= rdata0; 
    end
    else begin
        dout_shift_v <= 0;
        dout_shift <= 0;
    end

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wea(dout_ctrl_v), // valid of dout_ctrl
    .web(din_tx_v), // valid of din_tx
    .dina(dout_ctrl), // din_comp
    .dinb(din_tx), // data transmitted from previous PE
    .wben(dout_alu_v), 
    .rden(dmem_re), // re
    .inst_v(inst_pc_v),
    .inst(inst_pc), // instructions triggered by program counter
    .shift_v(shift_v),
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

// ROM for Twiddle Factors
const_rom ROM(
    .clk(clk), 
    .en(en), 
    .addr(addr), 
    .data_out(dout_rom)
    );

/*** Data Memory Feedback Input Map ***/
reg  three_operand, three_operand_d1, three_operand_d2;
always @ (posedge clk) begin
    if (inst_pc[31:29] == 3'b101 | inst_pc[31:29] == 3'b110)
        three_operand <= 1; 
    else 
        three_operand <= 0; 
    three_operand_d1 <= three_operand; 
    three_operand_d2 <= three_operand_d1; // ROM requires 3-stage pipeline
end    
//wire three_operand; 
//assign three_operand = (inst_pc[31:29] == 3'b101 | inst_pc[31:29] == 3'b110) ? 1 : 0; 
wire [`DATA_WIDTH*2-1:0] din_alu_1, din_alu_2, din_alu_3; 
assign din_alu_1 = three_operand_d2 ? dout_rom : rdata0;
assign din_alu_2 = rdata1;
assign din_alu_3 = three_operand_d2 ? rdata0 : 0;

// ALU for Complex Data
complex_alu ALU( 
    .clk(clk), 
    .rst(rst), 
    .opcode(opcode), 
    .alumode(alumode), 
    .inmode(inmode), 
    .opmode(opmode), 
    .cea2(cea2), 
    .ceb2(ceb2), 
    .usemult(usemult), 
    .din_1(din_alu_1), // rdata0
    .din_2(din_alu_2), // rdata1
    .din_3(din_alu_3), // dout_rom
    .dout(dout_alu) 
    );    

/*** Moore finite state machine (FSM) for data transmit & alpha output ***/
   parameter IDLE = 3'b000;
   parameter LOAD = 3'b001;
   parameter COMPUTE = 3'b010;
   parameter TRANSMIT = 3'b011;
   parameter SHIFT = 3'b100;
   parameter OUTPUT = 3'b101;

   reg [5:0] fsm_output = 6'b000000;
   
   wire start, load_v, cmpt_v, tx_v, shift_v, output_v;
   assign start = fsm_output[5];
   assign load_v = fsm_output[4];
   assign cmpt_v = fsm_output[3];
   assign tx_v   = fsm_output[2];
   assign shift_v = fsm_output[1];
   assign output_v = fsm_output[0];
   
   // counters to control the state machine
   reg [6:0] iter_cnt = 0; // iteration
   reg [7:0] loop_cnt = 0; // loop
   reg [4:0] load_cnt = 0; // load
   reg [7:0] cmpt_cnt = 0; // compute
   reg [2:0] tx_cnt = 0;  // transmit
   reg [4:0] shift_cnt = 0; // shift
   reg [2:0] output_cnt = 0; // output
   
   reg [2:0] state = IDLE; // initial state

   always @(posedge clk)
      if (rst) begin
         state <= IDLE;
      end
      else
         case (state)
            IDLE : begin
               if (din_pe_v)
                  state <= LOAD;
               else
                  state <= IDLE;
               fsm_output <= 6'b100000;  // start = 1
            end
            LOAD : begin
               if (load_cnt == `LOAD_NUM-1) begin
                  state <= COMPUTE;
                  load_cnt <= 0;
               end
               else begin
                  state <= LOAD;
                  load_cnt <= load_cnt + 1'b1;
               end
//               loop_cnt <= loop_cnt + 1'b1;
               fsm_output <= 6'b010000;  // load_v = 1
            end
            COMPUTE : begin
               if (cmpt_cnt == `INST_NUM-1 && iter_cnt == `ITER_NUM-1) begin
                  state <= OUTPUT;
                  cmpt_cnt <= 0;
//                  iter_cnt <= 0;
               end
               else if (cmpt_cnt == `INST_NUM-1) begin
                  state <= TRANSMIT;
                  cmpt_cnt <= 0;
               end
               else begin
                  state <= COMPUTE;
                  cmpt_cnt <= cmpt_cnt + 1'b1;
               end
//               loop_cnt <= loop_cnt + 1'b1;
               fsm_output <= 6'b001000; // cmpt_v = 1
            end
            TRANSMIT : begin
               if (tx_cnt == `TX_NUM-1) begin
                  state <= SHIFT;
                  tx_cnt <= 0;
               end
               else begin
                  state <= TRANSMIT;
                  tx_cnt <= tx_cnt + 1'b1;
               end
//               loop_cnt <= loop_cnt + 1'b1;
               fsm_output <= 6'b000100; // tx_v = 1
            end
            SHIFT : begin
               if (shift_cnt == `REG_NUM-1) begin
                  state <= COMPUTE;
                  shift_cnt <= 0;
               end
               else begin
                  state <= SHIFT;
                  shift_cnt <= shift_cnt + 1'b1;
               end 
               fsm_output <= 6'b000010; // shift_V = 1
            end
            OUTPUT : begin
               if (output_cnt == `ALPHA_NUM-1) begin
                  state <= IDLE;
                  output_cnt <= 0; 
               end
               else begin
                  state <= OUTPUT;
                  output_cnt <= output_cnt + 1'b1;
               end 
               fsm_output <= 6'b000001; // output_v = 1
            end
         endcase
   
   // counter for iterations
   always @(posedge clk)
      if (state == IDLE) begin
         loop_cnt <= 0;
         iter_cnt <= 0;
      end
      else if (loop_cnt == (`LOAD_NUM + `INST_NUM + `TX_NUM - 1)) begin
         loop_cnt <= 0;
         iter_cnt <= iter_cnt + 1'b1;
      end
      else if (state == LOAD | state == COMPUTE | state == TRANSMIT)
         loop_cnt <= loop_cnt + 1'b1;
 
//    always @(posedge clk)
//       if (loop_cnt >= `LOAD_NUM && loop_cnt < (`LOAD_NUM + `REG_NUM)) 
//          shift_v <= 1;
//       else 
//          shift_v <= 0;
           
   // control logics for data forward & alpha output
   always @ (posedge clk) begin
    if (tx_v) begin // partial alpha forward to next PE
        dout_tx_v <= 1;
        dout_tx   <= dout_alu;
    end
    else begin
        dout_tx_v <= 0;
        dout_tx   <= 32'hxxxxxxxx; 
    end
    if (output_v) begin // output alpha (output_v = 1 when in last iteration)
        dout_pe_v <= 1;
        dout_pe   <= dout_alu; 
    end
    else begin
        dout_pe_v <= 0;
        dout_pe   <= 32'hxxxxxxxx; 
    end   
end
    
endmodule