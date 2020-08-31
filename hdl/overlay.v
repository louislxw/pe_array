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
    clk, rst, din_overlay_v, din_overlay, inst_in_v, inst_in, dout_overlay_v, dout_overlay, overlay_fwd_v, overlay_fwd
    );
    
input  clk; 
input  rst;
input  din_overlay_v;
input  [`DATA_WIDTH*2-1:0] din_overlay;
input  inst_in_v;
input  [`INST_WIDTH-1:0] inst_in;

output dout_overlay_v;
output [`DATA_WIDTH*2-1:0] dout_overlay; 
output overlay_fwd_v;
output [`DATA_WIDTH*2-1:0] overlay_fwd;

wire pe_out_v [`PE_NUM-1:0];
wire pe_fwd_v [`PE_NUM-1:0];
wire [`DATA_WIDTH*2-1:0] pe_out [`PE_NUM-1:0];
wire [`DATA_WIDTH*2-1:0] pe_fwd [`PE_NUM-1:0];
wire dout_last_v;
wire [`DATA_WIDTH*2-1:0] dout_last;

genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i + 1) begin : array
        // PE_0 (Input)
        if (i == 0) begin
            pe(
            .clk(clk), 
            .rst(rst), 
            .din_v(din_overlay_v), 
            .din_pe(din_overlay), 
            .inst_in_v(inst_in_v), 
            .inst_in(inst_in), 
            
            .dout_v(pe_out_v[i]),
            .dout_pe(pe_out[i]),
            .dout_fwd_v(pe_fwd_v[i]),
            .dout_fwd(pe_fwd[i])
            );
        end
        // PE_N-1 (Output)
        else if (i == `PE_NUM-1) begin
            pe(
            .clk(clk), 
            .rst(rst), 
            .din_v(pe_fwd_v[i]), 
            .din_pe(pe_fwd[i]), 
            .inst_in_v(inst_in_v), 
            .inst_in(inst_in), 
            
            .dout_v(dout_last_v),
            .dout_pe(dout_last),
            .dout_fwd_v(overlay_fwd_v),
            .dout_fwd(overlay_fwd)          
            );
        end
        // PE_1 to PE_N-2
        else begin
            pe(
            .clk(clk), 
            .rst(rst), 
            .din_v(pe_fwd_v[i-1]), 
            .din_pe(pe_fwd[i-1]), 
            .inst_in_v(inst_in_v), 
            .inst_in(inst_in), 
            
            .dout_v(pe_out_v[i]),
            .dout_pe(pe_out[i]),
            .dout_fwd_v(pe_fwd_v[i]),
            .dout_fwd(pe_fwd[i])           
            );
        end
        
        assign dout_overlay_v = (i == `PE_NUM-1) ? dout_last_v : pe_out_v[i]; 
        assign dout_overlay = (i == `PE_NUM-1) ? dout_last : pe_out[i];
        
    end
endgenerate    
    
    
endmodule
