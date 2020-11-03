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
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module sipo_y(
    clk, en, s_in, p_out
    );
    
input clk;
input en;
input [`DATA_WIDTH*2-1:0] s_in;
output [`PE_NUM*`DATA_WIDTH*2-1:0] p_out; 

reg [`REG_ADDR_WIDTH-1:0] reg_cnt = {`REG_ADDR_WIDTH{1'b0}}; // 2^5 = 32
reg [`PE_ADDR_WIDTH-1:0] pe_cnt = {`PE_ADDR_WIDTH{1'b0}}; // 2^8 = 256
reg state; // Eventually should be three-state: load, process, shift

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

reg [`DATA_WIDTH*2-1:0] srl_in; 
wire [`DATA_WIDTH*2-1:0] srl_out [`PE_NUM-1:0]; 

always @(posedge clk) 
    if (state == 0) // load state
        srl_in <= s_in;
    else // shift state
        srl_in <= srl_out[`PE_NUM-1];

genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i+1) begin: SIPO_Y
        // srl_0 (Input)
        if (i == 0)  
            srl(
            .clk(clk), 
            .ce(en), 
            .din(srl_in), 
            .dout(srl_out[i])
            );
        // srl_1 to srl_N-1
        else 
            srl(
            .clk(clk), 
            .ce(en), 
            .din(srl_out[i-1]), 
            .dout(srl_out[i])
            );
             
        assign p_out[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2] = srl_out[i];
    end
endgenerate    
    
endmodule
