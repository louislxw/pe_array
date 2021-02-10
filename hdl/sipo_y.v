`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2020 18:07:35
// Design Name: 
// Module Name: sipo_y
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Serial-in to Parallel-out (SIPO) for input Y
// 
// Dependencies: 8,244 LUTs, 48 FFs
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module sipo_y(
    clk, ce, rst, shift_v, s_in_v, s_in, p_out_v, p_out
    );
    
input clk;
input ce;
input rst; // reset of the FSM
//input rst; no reset port in the LUTRAM
input shift_v;
input s_in_v;
input [`DATA_WIDTH*2-1:0] s_in; // no register

output p_out_v;
output [`PE_NUM*`DATA_WIDTH*2-1:0] p_out; // no register

//reg [`REG_ADDR_WIDTH-1:0] reg_cnt = {`REG_ADDR_WIDTH{1'b0}}; // 2^5 = 32
//reg [`PE_ADDR_WIDTH-1:0] pe_cnt = {`PE_ADDR_WIDTH{1'b0}}; // 2^8 = 256
//reg [1:0] state = 2'b00; // idle, load, wait, shift
//always @(posedge clk) 
//    if (reg_cnt == {`REG_ADDR_WIDTH{1'b1}} && pe_cnt == {`PE_ADDR_WIDTH{1'b1}} && state == 1) begin
//        reg_cnt <= 0;
//        pe_cnt <= 0; 
//        state <= 0;
//    end
//    else if (reg_cnt == {`REG_ADDR_WIDTH{1'b1}} && pe_cnt == {`PE_ADDR_WIDTH{1'b1}}) begin
//        reg_cnt <= 0;
//        pe_cnt <= 0;
//        state <= state + 1'b1;
//    end
//    else if (reg_cnt == {`REG_ADDR_WIDTH{1'b1}}) begin
//        reg_cnt <= 0;
//        pe_cnt <= pe_cnt + 1'b1;
//    end
//    else begin
//        reg_cnt <= reg_cnt + 1'b1;
//    end  

/*** Moore finite state machine (FSM) for shift register logics (SRL) ***/
   parameter IDLE = 2'b00;
   parameter LOAD = 2'b01;
   parameter WAIT = 2'b10;
   parameter SHIFT = 2'b11;
   
   reg [3:0] fsm_output = 4'b0000;

   reg [12:0] input_cnt = 0; // input
   reg [6:0] iter_cnt = 0; // iteration
   reg [4:0] shift_cnt = 0; // shift
      
   reg [1:0] state = IDLE; // initial state

   always @(posedge clk)
      if (rst) begin
         state <= IDLE;
      end
      else
         case (state)
            IDLE : begin
               if (s_in_v)
                  state <= LOAD;
               else
                  state <= IDLE;
               fsm_output <= 4'b1000;
            end
            LOAD : begin
               if (input_cnt == `REG_NUM * `PE_NUM - 1)
                  state <= WAIT;
               else
                  state <= LOAD;
               input_cnt <= input_cnt + 1'b1;
               fsm_output <= 4'b0100;
            end
            WAIT : begin
               if (shift_v)
                  state <= SHIFT;
               else
                  state <= WAIT;
               fsm_output <= 4'b0010;
            end
            SHIFT : begin
               if (shift_cnt == `REG_NUM - 1)
                  state <= WAIT;
               else if (iter_cnt == `ITER_NUM - 1)
                  state <= IDLE;
               else
                  state <= SHIFT;
               shift_cnt <= shift_cnt + 1'b1;   
               fsm_output <= 4'b0001;
            end
         endcase

reg [`DATA_WIDTH*2-1:0] srl_in; 
wire [`DATA_WIDTH*2-1:0] srl_out [`PE_NUM-1:0]; 

always @(posedge clk) 
    if (state == 2'b01) // load state
        srl_in <= s_in;
    else if (state == 2'b10) // round shift state
        srl_in <= srl_out[`PE_NUM-1];

genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i+1) begin: siso_y
        // srl_0 (Input)
        if (i == 0)  
            srl_macro srl_inst(
            .clk(clk), 
            .ce(ce), // 1'b1
            .din(srl_in), 
            .dout(srl_out[i])
            );
        // srl_1 to srl_N-1 (right shift: from low to high)
        else 
            srl_macro srl_inst(
            .clk(clk),
            .ce(ce), // 1'b1
            .din(srl_out[i-1]), 
            .dout(srl_out[i])
            );
             
        assign p_out[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2] = srl_out[i];
    end
endgenerate    

parameter DELAY = `REG_NUM + 1;
reg [DELAY-1:0] shift_reg_v = 0;
always @ (posedge clk) begin 
    shift_reg_v <= {shift_reg_v[DELAY-2:0], s_in_v};
end
assign p_out_v = shift_reg_v[DELAY-1]; // valid signal for parallel outputs
    
endmodule
