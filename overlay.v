`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2020 17:29:10
// Design Name: 
// Module Name: overlay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module overlay(
    clk, rst, din_v, din_ld, din_pe, ins_in_v, ins_in, dout_v, dout
    );
    
input  clk; 
input  rst;
input  din_v;
input  [`DATA_WIDTH*2-1:0] din_ld;
input  [`DATA_WIDTH*2-1:0] din_pe;
input  ins_in_v;
input  [`INST_WIDTH-1:0] ins_in;

output dout_v;
output [`DATA_WIDTH*2-1:0] dout; 
//output inst_out_v;
//output [`INST_WIDTH-1:0] inst_out;

wire valid_data [`NUM_PE-1:0], valid_inst [`NUM_PE-1:0];
wire [`DATA_WIDTH*2-1:0] pe_in [`NUM_PE-1:0];
wire [`DATA_WIDTH*2-1:0] pe_ld [`NUM_PE-1:0];
wire [`DATA_WIDTH*2-1:0] pe_out [`NUM_PE-1:0];
wire [`INST_WIDTH-1:0] inst_ld [`NUM_PE-1:0];

genvar i;

generate
    for (i = 0; i < `NUM_PE; i = i + 1) begin : array
        if (i == 0) begin
            pe(
            .clk(clk), 
            .rst(rst), 
            .din_v(din_v), 
            .din_ld(din_ld), 
            .din_pe(din_pe), 
            .inst_in_v(inst_v), 
            .inst_in(inst_in), 
            .dout_v(dout_v),
            .dout_pe(pe_out[i]),
            .inst_out_v(inst_out_v),
            .inst_out(inst_out)
            );
        end
        else if (i == `NUM_PE-1) begin
            pe(
            .clk(clk), 
            .rst(rst), 
            .din_v(valid_data[i]), 
            .din_ld(pe_ld[i]), 
            .din_pe(pe_in[i + 1]), 
            .inst_in_v(valid_inst[i + 1]), 
            .inst_in(inst_ld[i]), 
            .dout_v(dout_v),
            .dout_pe(dout_pe),
            .inst_out_v(inst_out_v),
            .inst_out(inst_out)
            );
        end
        else begin
        pe(
            .clk(clk), 
            .rst(rst), 
            .din_v(valid_data[i]), 
            .din_ld(pe_ld[i]), 
            .din_pe(pe_in[i + 1]), 
            .inst_in_v(valid_inst[i + 1]), 
            .inst_in(inst_ld[i]), 
            .dout_v(dout_v),
            .dout_pe(pe_out[i]),
            .inst_out_v(inst_out_v),
            .inst_out(inst_out)
            );
        end
    end
endgenerate    
    
    
endmodule