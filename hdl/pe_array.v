`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2021 01:59:11 PM
// Design Name: 
// Module Name: pe_array
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

module pe_array(
    clk, rst, load, din_overlay_v, din_overlay, dout_overlay_v, dout_overlay
    );
    
input  clk; 
input  rst; 
input  load; 
input  din_overlay_v; 
input  [`DATA_WIDTH*2-1:0] din_overlay; 

output dout_overlay_v; 
output [`DATA_WIDTH*2-1:0] dout_overlay; 
reg dout_overlay_v; //
reg [`DATA_WIDTH*2-1:0] dout_overlay; //

reg  [`PE_NUM-1:0] pe_in_v;
reg  [`DATA_WIDTH*2-1:0] pe_in [`PE_NUM-1:0];
wire [`PE_NUM-1:0] pe_out_v;
wire [`DATA_WIDTH*2-1:0] pe_out [`PE_NUM-1:0];
wire [`PE_NUM-1:0] pe_tx_v;
wire [`DATA_WIDTH*2-1:0] pe_tx [`PE_NUM-1:0];
wire [`PE_NUM-1:0] pe_shift_v;
wire [`DATA_WIDTH*2-1:0] pe_shift [`PE_NUM-1:0];
wire array_out_v;
wire [`DATA_WIDTH*2-1:0] array_out;
//wire [`PE_NUM*`DATA_WIDTH*2-1:0] pe_in;
//wire [`PE_NUM*`DATA_WIDTH*2-1:0] p_in;
//wire p_out_v;
//wire shift_v;

//sipo_y in_buffer(
//    .clk(clk), 
//    .rst(rst),
//    .shift_v(shift_v),
//    .s_in_v(din_overlay_v), 
//    .s_in(din_overlay), 
//    .p_out_v(p_out_v),
//    .p_out(pe_in)
//    );

reg [4:0] load_cnt = 0;
reg [13:0] stream_cnt = 0;
always @ (posedge clk) 
    if(din_overlay_v) 
        load_cnt <= load_cnt + 1;
    else 
        load_cnt <= 0;

integer j;
always @ (posedge clk) begin
    for (j = 0; j < `PE_NUM; j = j + 1) begin 
        if(load_cnt >= j*`LOAD_NUM && load_cnt < (j+1)*`LOAD_NUM) begin
            pe_in_v[j] <= din_overlay_v;
            pe_in[j] <= din_overlay;
        end
        else begin
            pe_in_v[j] <= 0;
            pe_in[j] <= 0;
        end
    end
end

genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i + 1) begin : array
        // PE_0
        if (i == 0) begin
            pe ( // PE0( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(pe_in_v[0]), 
            .din_pe(pe_in[0]), 
            .din_shift_v(pe_shift_v[0]), 
            .din_shift(pe_shift[0]),
            .din_tx_v(0), 
            .din_tx(0), 
            .dout_pe_v(pe_out_v[0]), 
            .dout_pe(pe_out[0]), 
            .dout_tx_v(pe_tx_v[0]), 
            .dout_tx(pe_tx[0]),
            .dout_shift_v(), 
            .dout_shift()
            );
        end       
        // PE_N-1 (Output)
        else if (i == `PE_NUM-1) begin
            pe ( // PE_N_1( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(pe_in_v[i]), 
            .din_pe(pe_in[i]), 
            .din_shift_v(), 
            .din_shift(),   
            .din_tx_v(pe_tx_v[i]), 
            .din_tx(pe_tx[i]),  
            .dout_pe_v(pe_out_v[i]), 
            .dout_pe(pe_out[i]), 
            .dout_tx_v(pe_tx_v[i]), 
            .dout_tx(pe_tx[i]),
            .dout_shift_v(pe_shift_v[i-1]), 
            .dout_shift(pe_shift[i-1])
            );
        end        
        // PE_1 to PE_N-2
        else begin
             pe ( // PE_K( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(pe_in_v[i]), 
            .din_pe(pe_in[i]), 
            .din_shift_v(pe_shift_v[i]), 
            .din_shift(pe_shift[i]),            
            .din_tx_v(pe_tx_v[i-1]), 
            .din_tx(pe_tx[i-1]), 
            .dout_pe_v(pe_out_v[i]), 
            .dout_pe(pe_out[i]), 
            .dout_tx_v(pe_tx_v[i]), 
            .dout_tx(pe_tx[i]),
            .dout_shift_v(pe_shift_v[i-1]), 
            .dout_shift(pe_shift[i-1])
            ); 
        end
        
//        assign p_in[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2] = pe_out[i];
        assign array_out_v = pe_out_v[i] ? 1 : 0;
        assign array_out = pe_out_v[i] ? pe_out[i] : 0;
        
    end
endgenerate

//piso_new out_buffer(
//    .clk(clk), 
//    .load(load),
//    .p_in_v(), //
//    .p_in(p_in), 
//    .s_out_v(dout_overlay_v), 
//    .s_out(dout_overlay)
//    );

always @ (posedge clk) begin
    if(array_out_v) begin
        dout_overlay_v <= 1;
        dout_overlay <= array_out;
    end
    else begin
        dout_overlay_v <= 0;
        dout_overlay <= 0;
    end
end
    
endmodule
