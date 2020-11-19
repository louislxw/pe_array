`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2020 16:42:49
// Design Name: 
// Module Name: PISO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Parallel-in to Serial-out (PISO) 
// 
// Dependencies: 8147 LUTs, 8193 FFs
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module PISO(
    clk, rst, ce, load, p_in, s_out_v, s_out
    );
    
input clk;
input rst;
input ce;
input load; // load parallel ouput into SRL
input [`PE_NUM*`DATA_WIDTH*2-1:0] p_in;

output s_out_v;
output reg [`DATA_WIDTH*2-1:0] s_out; 

wire [`DATA_WIDTH*2-1:0] array_output [0:`PE_NUM-1]; 
genvar j;
for(j = 0; j < `PE_NUM; j = j+1) begin 
    assign array_output[j] = p_in[(j+1)*`DATA_WIDTH*2-1:j*`DATA_WIDTH*2];
end

reg [`DATA_WIDTH*2-1:0] shift_reg_data [0:`REG_NUM-1]; 

integer i;
always @ (posedge clk) begin
    if (rst)
        for(i = `REG_NUM-1; i > 0; i = i-1) begin 
            shift_reg_data[i] <= 0;
            s_out <= 0;
        end
    else if (load) begin
        for(i = `REG_NUM-1; i > 0; i = i-1) begin 
            shift_reg_data[i] <= array_output[i];
        end
    end
    else if (ce) begin // left shift
        s_out <= shift_reg_data[0]; 
        for(i = 0; i < `REG_NUM-1; i = i+1) begin 
            shift_reg_data[i] <= shift_reg_data[i+1];
        end
    end

end

parameter DELAY = `PE_NUM;
reg [DELAY-1:0] shift_reg_v = 0;
always @ (posedge clk) begin 
    shift_reg_v <= {shift_reg_v[DELAY-2:0], ce};
end
assign s_out_v = shift_reg_v[DELAY-1]; // valid signal for shift registers

endmodule
