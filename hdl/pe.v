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
//  358 LTUs, 339 FFs, 1.5 BRAM, 4 DSPs (meet 600MHz)
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

output dout_pe_v;
output [`DATA_WIDTH*2-1:0] dout_pe;
output dout_tx_v;
output [`DATA_WIDTH*2-1:0] dout_tx;
output dout_shift_v;
output [`DATA_WIDTH*2-1:0] dout_shift;

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
inst_rom IMEM(
    .clk(clk), 
    .en(cmpt_v), 
    .addr(inst_addr), 
    .data_out(inst_pc)
    );

reg [2:0] opcode;
always @ (posedge clk) 
    opcode <= inst_pc[31:29]; 

// Control Logics & Decoder
control CTRL(
    .clk(clk),
    .din_pe_v(din_pe_v), 
    .din_pe(din_pe), 
    .din_shift_v(din_shift_v), 
    .din_shift(din_shift),
    .din_tx_v(din_tx_v), 
    .din_tx(din_tx),
//    .din_wb(dout_alu), 
    .inst_v(inst_pc_v),
    .opcode(opcode), 
    
    .dout_v(dout_alu_v), // generate valid signal for alu
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
        dmem_re <= 1; 
    end    
    else begin
        dmem_re <= 0;
    end 
end

reg shift_v_d1, shift_v_d2, shift_v_d3;
always @ (posedge clk) begin
    shift_v_d1 <= shift_v;
    shift_v_d2 <= shift_v_d1;
    shift_v_d3 <= shift_v_d2;
end

// It takes 2 cycles to read the data from DMEM.
assign dout_shift = shift_v_d3 ? rdata0 : 0;
assign dout_shift_v = shift_v_d3 ? 1 : 0;

// Data Memory
data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wea(din_pe_v), // valid in of load
    .web(din_shift_v), // valid in of shift
    .wec(din_tx_v), // valid in of tx
    .wed(dout_alu_v), // valid in of write back
    .dina(dout_ctrl), 
    .dinb(dout_alu_r), // dout_alu
    .rden(dmem_re), 
    .inst_v(inst_pc_v),
//    .rea(inst_pc_v),
//    .reb(shift_v),    
    .inst(inst_pc), // instructions triggered by program counter
    .shift_v(shift_v),
    
    .douta(rdata0),
    .doutb(rdata1)
    );

// Synchronize dout_rom with rdata0 and rdata1. 
wire [`DATA_WIDTH*2-1:0] dout_rom;
reg [`WN_ADDR_WIDTH-1:0] rom_addr; 
reg  rom_en, rom_en_d1, rom_en_d2;
always @ (posedge clk) begin
    if (inst_pc[31:29] == 3'b101 | inst_pc[31:29] == 3'b110)
        rom_en <= 1; 
    else 
        rom_en <= 0; 
    rom_en_d1 <= rom_en; 
    rom_en_d2 <= rom_en_d1; // ROM requires 3-stage pipeline
    rom_addr <= inst_pc[27:24];    
end

// ROM for Twiddle Factors
const_rom ROM(
    .clk(clk), 
    .en(rom_en), 
    .addr(rom_addr), 
    .data_out(dout_rom)
    );

/*** Data Memory Feedback Input Map ***/
wire [`DATA_WIDTH*2-1:0] din_alu_1, din_alu_2, din_alu_3; 
assign din_alu_1 = rom_en_d2 ? dout_rom : rdata0;
assign din_alu_2 = rdata1;
assign din_alu_3 = rom_en_d2 ? rdata0 : 0;

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
   reg [5:0] load_cnt = 0; // load
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
               if (output_cnt == `OUT_NUM-1) begin
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
      else if (loop_cnt == (`INST_NUM + `TX_NUM + `REG_NUM - 1)) begin
         loop_cnt <= 0;
         iter_cnt <= iter_cnt + 1'b1;
      end
      else if (state == COMPUTE | state == TRANSMIT | state == SHIFT)
         loop_cnt <= loop_cnt + 1'b1;
 
//    always @(posedge clk)
//       if (loop_cnt >= `LOAD_NUM && loop_cnt < (`LOAD_NUM + `REG_NUM)) 
//          shift_v <= 1;
//       else 
//          shift_v <= 0;
           
// control logics for data forward & alpha output
reg [`DATA_WIDTH*2-1:0] dout_alu_r;
always @ (posedge clk)
    dout_alu_r <= dout_alu;

assign dout_tx_v = tx_v ? 1 : 0;
assign dout_tx = tx_v ? dout_alu_r : 0;
assign dout_pe_v = output_v ? 1 : 0;
assign dout_pe = output_v ? dout_alu_r : 0;
    
endmodule