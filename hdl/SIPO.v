`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2020 10:06:21
// Design Name: 
// Module Name: SIPO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Serial-in to Parallel-out (SIPO) Shift Register
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module SIPO(
    clk, rst, load, s_in, p_out
    );

input clk;
input rst;
input [`DATA_WIDTH*2-1:0] s_in;
input load; // load serial input

output [`PE_NUM*`DATA_WIDTH*2-1:0] p_out; 

reg [`DATA_WIDTH*2-1:0] shift_reg_data [0:`PE_NUM-1]; 

integer i;
always @ (posedge clk) begin
    if (rst)
        for(i = `PE_NUM-1; i > 0; i = i-1) begin 
            shift_reg_data[i] <= 0;
        end
    else if (load) begin
        for(i = `PE_NUM-1; i > 0; i = i-1) begin 
            shift_reg_data[i] <= shift_reg_data[i-1];
        end
        shift_reg_data[0] <= s_in; 
    end
end 

genvar j;
for(j = 0; j < `PE_NUM; j = j+1) begin 
    assign p_out[(j+1)*`DATA_WIDTH*2-1:j*`DATA_WIDTH*2] = shift_reg_data[j]; 
end
    
endmodule
