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
    clk, rst, load, din_overlay_v, din_overlay, inst_in_v, inst_in, dout_overlay_v, dout_overlay
    );
    
input  clk; 
input  rst; 
input  load; 
input  din_overlay_v; 
input  [`DATA_WIDTH*2-1:0] din_overlay; 
input  inst_in_v; 
input  [`INST_WIDTH-1:0] inst_in; 

output dout_overlay_v; 
output [`DATA_WIDTH*2-1:0] dout_overlay; 
//reg [`DATA_WIDTH*2-1:0] dout_overlay; //

wire pe_out_v [`PE_NUM-1:0];
wire pe_tx_v [`PE_NUM-1:0];
wire [`DATA_WIDTH*2-1:0] pe_out [`PE_NUM-1:0];
wire [`DATA_WIDTH*2-1:0] pe_tx [`PE_NUM-1:0];
wire [`PE_NUM*`DATA_WIDTH*2-1:0] p_in;
wire [`PE_NUM*`DATA_WIDTH*2-1:0] pe_in;
wire p_out_v;
wire shift_v;

sipo_y in_buffer(
    .clk(clk), 
    .rst(rst),
    .shift_v(shift_v),
    .s_in_v(din_overlay_v), 
    .s_in(din_overlay), 
    .p_out_v(p_out_v),
    .p_out(pe_in)
    );

genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i + 1) begin : array
        // PE_0
        if (i == 0) begin
            pe( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(p_out_v), 
            .din_pe(pe_in[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2]), 
            .din_tx_v(0), 
            .din_tx(0), 
            .inst_in_v(inst_in_v), 
            .inst_in(inst_in), 
            .dout_pe_v(pe_out_v[0]), 
            .dout_pe(pe_out[0]), 
            .dout_tx_v(pe_tx_v[0]), 
            .dout_tx(pe_tx[0]),
            .shift_v(shift_v) // add
            );
        end       
        // PE_N-1 (Output)
        else if (i == `PE_NUM-1) begin
            pe( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(p_out_v), 
            .din_pe(pe_in[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2]), 
            .din_tx_v(pe_tx_v[i]), 
            .din_tx(pe_tx[i]), 
            .inst_in_v(inst_in_v), 
            .inst_in(inst_in), 
            .dout_pe_v(pe_out_v[i]), 
            .dout_pe(pe_out[i]), 
            .dout_tx_v(pe_tx_v[i]), 
            .dout_tx(pe_tx[i]),
            .shift_v() // add
            );
        end        
        // PE_1 to PE_N-2
        else begin
             pe( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(p_out_v), 
            .din_pe(pe_in[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2]), 
            .din_tx_v(pe_tx_v[i-1]), 
            .din_tx(pe_tx[i-1]), 
            .inst_in_v(inst_in_v), 
            .inst_in(inst_in), 
            .dout_pe_v(pe_out_v[i]), 
            .dout_pe(pe_out[i]), 
            .dout_tx_v(pe_tx_v[i]), 
            .dout_tx(pe_tx[i]),
            .shift_v() // add
            ); 
        end
        
        assign p_in[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2] = pe_out[i];
        
    end
endgenerate

piso_new out_buffer(
    .clk(clk), 
    .load(load),
    .p_in_v(), //
    .p_in(p_in), 
    .s_out_v(dout_overlay_v), 
    .s_out(dout_overlay)
    );

//PISO out_buffer(
//    .clk(clk), 
//    .rst(rst), 
//    .ce(ce),
//    .load(load),
//    .p_in(p_in), 
//    .s_out_v(dout_overlay_v),
//    .s_out(dout_overlay) 
//    ); 
    
endmodule