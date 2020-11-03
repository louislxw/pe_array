`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2020 14:08:47
// Design Name: 
// Module Name: sipo_x
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Serial-in to Parallel-out (SIPO) for input X
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module sipo_x(
    clk, en, s_in, p_out
    );
    
input clk;
input en;
input [`DATA_WIDTH*2-1:0] s_in;
output [`PE_NUM*`DATA_WIDTH*2-1:0] p_out; 

reg [`REG_ADDR_WIDTH-1:0] reg_cnt = {`REG_ADDR_WIDTH{1'b0}}; // 2^5 = 32
reg [`PE_ADDR_WIDTH-1:0] pe_cnt = {`PE_ADDR_WIDTH{1'b0}}; // 2^8 = 256
reg state; // Eventually should be two-state: load, keep

always @(posedge clk) 
    if (reg_cnt == {`REG_ADDR_WIDTH{1'b1}} && pe_cnt == {`PE_ADDR_WIDTH{1'b1}} && state == 1) begin
        reg_cnt <= 0;
        pe_cnt <= 0; 
        state <= 0;
    end
    else if (reg_cnt == {`REG_ADDR_WIDTH{1'b1}} && pe_cnt == {`PE_ADDR_WIDTH{1'b1}}) begin
        reg_cnt <= 0;
        pe_cnt <= 0;
        state <= state + 1'b1;
    end
    else if (reg_cnt == {`REG_ADDR_WIDTH{1'b1}}) begin
        reg_cnt <= 0;
        pe_cnt <= pe_cnt + 1'b1;
    end
    else begin
        reg_cnt <= reg_cnt + 1'b1;
    end  

wire ce_x;
assign ce_x = (state == 0) ? en : 0;

wire [`DATA_WIDTH*2-1:0] srl_in [`PE_NUM-1:0]; 
wire [`DATA_WIDTH*2-1:0] srl_out [`PE_NUM-1:0]; 

genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i+1) begin: SIPO_X
        srl(
        .clk(clk), 
        .ce(ce_x), 
        .din(srl_in[i]), 
        .dout(srl_out[i])
        );
        
        assign srl_in[i] = (pe_cnt == i) ? s_in : 0;    
        assign p_out[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2] = srl_out[i];
    end
endgenerate   
    
endmodule
