`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2020 09:48:05
// Design Name: 
// Module Name: PISO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Parallel-in to Serial-out (PISO) Shift Register
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module PISO(
    clk, rst, fetch, p_in, s_out
    );
    
input clk;
input rst;
input fetch; // fetch parallel ouput
input [`REG_NUM*`DATA_WIDTH*2-1:0] p_in;

output reg [`DATA_WIDTH*2-1:0] s_out; 

wire [`DATA_WIDTH*2-1:0] array_output [0:`REG_NUM-1]; 
genvar j;
for(j = 0; j < `REG_NUM; j = j+1) begin 
    assign array_output[j] = p_in[(j+1)*`DATA_WIDTH*2-1:j*`DATA_WIDTH*2];
end

reg [`DATA_WIDTH*2-1:0] shift_reg_data [0:`REG_NUM-1]; 

integer i;
always @ (posedge clk) begin
    if (rst)
        for(i = `REG_NUM-1; i > 0; i = i-1) begin 
            shift_reg_data[i] <= 0;
        end
    else if (fetch) begin
        s_out <= shift_reg_data[`REG_NUM-1]; 
        for(i = `REG_NUM-1; i > 0; i = i-1) begin 
            shift_reg_data[i] <= shift_reg_data[i-1];
        end
    end
    else begin
        for(i = `REG_NUM-1; i > 0; i = i-1) begin 
            shift_reg_data[i] <= array_output[i];
        end
    end

end

endmodule
