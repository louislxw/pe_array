`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2020 15:54:56
// Design Name: 
// Module Name: stream_io
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: SIPO to PISO --> SISO
// 
// Dependencies: 20,553 LUTs, 161 FFs (meet 600MHz)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module stream_io(
    clk, rst, p_ce, load, s_in_v, s_in, s_out_v, s_out
    );
    
input clk;
input rst;
input s_in_v;
input p_ce;
input load;
input [`DATA_WIDTH*2-1:0] s_in;

output s_out_v;
output [`DATA_WIDTH*2-1:0] s_out;

// intermediate signals
wire p_out_v;
wire [`PE_NUM*`DATA_WIDTH*2-1:0] p_out;

sipo_y in_buffer(
    .clk(clk), 
    .s_in_v(s_in_v), 
    .s_in(s_in), 
    .p_out_v(p_out_v),
    .p_out(p_out)
    );
    
piso_new out_buffer(
    .clk(clk), 
    .load(load),
    .p_in_v(p_out_v), 
    .p_in(p_out), 
    .s_out_v(s_out_v), 
    .s_out(s_out)
    );
    
//PISO out_buffer( 
//    .clk(clk), 
//    .rst(rst), 
//    .ce(p_ce),
//    .load(load),
//    .p_in(p_out), 
//    .s_out_v(s_out_v),
//    .s_out(s_out) 
//    );
    
endmodule
