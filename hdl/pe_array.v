`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 10:33:50 PM
// Design Name: 
// Module Name: pe_array
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: A linear array of RISC-V PEs
// 
// Dependencies: 8-PE: 5,278 LUTs, 4,844 FFs, 16 BRAMs, 32 DSPs (meet 600MHz)
//              32-PE: 21,584 LUTs, 18,775 FFs, 64 BRAMs, 128 DSPs (meet 600MHz)
//             128-PE: 80,725 LUTs, 71,898 FFs, 256 BRAMs, 512 DSPs (meet 500MHz)
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module pe_array(
    clk, rst, load, din_overlay_v, din_overlay, dout_overlay_v, dout_overlay
//    array_out
    );
    
input  clk; 
input  rst; 
input  load; 
input  din_overlay_v; 
input  [`DATA_WIDTH*2-1:0] din_overlay; 

output reg dout_overlay_v; 
output reg [`DATA_WIDTH*2-1:0] dout_overlay; 
//output [`PE_NUM*`DATA_WIDTH*2-1:0] array_out;

reg  [`PE_NUM-1:0] pe_in_v;
reg  [`DATA_WIDTH*2-1:0] pe_in [`PE_NUM-1:0];
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

reg [13:0] stream_cnt = 0; // 2^14 = 16384 = 256*32*2 (X, Y matrices)
always @ (posedge clk) 
    if(din_overlay_v) 
        stream_cnt <= stream_cnt + 1;
    else 
        stream_cnt <= 0;

integer j;
always @ (posedge clk) begin
    for (j = 0; j < `PE_NUM; j = j + 1) begin 
        if(stream_cnt >= j*`LOAD_NUM && stream_cnt < (j+1)*`LOAD_NUM) begin
            pe_in_v[j] <= din_overlay_v;
            pe_in[j] <= din_overlay;
        end
        else begin
            pe_in_v[j] <= 0;
            pe_in[j] <= 0;
        end
    end
end

wire [`PE_NUM-1:0] pe_out_v;
wire [`DATA_WIDTH*2-1:0] pe_out [`PE_NUM-1:0];
wire [`PE_NUM-1:0] pe_tx_v;
wire [`DATA_WIDTH*2-1:0] pe_tx [`PE_NUM-1:0];
wire [`PE_NUM-1:0] pe_shift_v;
wire [`DATA_WIDTH*2-1:0] pe_shift [`PE_NUM-1:0];
wire [`PE_NUM-1:0] shift;
wire [`PE_NUM*`DATA_WIDTH*2-1:0] array_out;

genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i + 1) begin : array
        // PE_0
        if (i == 0) begin
            pe #
            (
            .ITER_NUM(`ITER_NUM-2) //
            )
            PE_i( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(pe_in_v[0]), 
            .din_pe(pe_in[0]), 
            .din_tx_v(0), 
            .din_tx(0), 
            .din_shift_v(pe_shift_v[0]), 
            .din_shift(pe_shift[0]), 
            .s_shift(0), 
            
            .dout_pe_v(pe_out_v[0]), 
            .dout_pe(pe_out[0]), 
            .dout_tx_v(pe_tx_v[0]), 
            .dout_tx(pe_tx[0]),
            .dout_shift_v(), //
            .dout_shift(), //
            .m_shift(shift[0])
            );
        end       
        // PE_N-1 (Output)
        else if (i == `PE_NUM-1) begin
            pe #
            (
            .ITER_NUM(0) //
            )
            PE_i( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(pe_in_v[`PE_NUM-1]), 
            .din_pe(pe_in[`PE_NUM-1]), 
            .din_tx_v(pe_tx_v[`PE_NUM-2]), 
            .din_tx(pe_tx[`PE_NUM-2]),  
            .din_shift_v(0), // 
            .din_shift(0), // 
            .s_shift(shift[`PE_NUM-2]), 
            
            .dout_pe_v(pe_out_v[`PE_NUM-1]), 
            .dout_pe(pe_out[`PE_NUM-1]), 
            .dout_tx_v(pe_tx_v[`PE_NUM-1]), 
            .dout_tx(pe_tx[`PE_NUM-1]),
            .dout_shift_v(pe_shift_v[`PE_NUM-2]), 
            .dout_shift(pe_shift[`PE_NUM-2]),
            .m_shift() //
            );
        end        
        // PE_1 to PE_N-2
        else begin
             pe #
            (
            .ITER_NUM(`ITER_NUM-2*(i+1)) 
            )
            PE_i( 
            .clk(clk), 
            .rst(rst), 
            .din_pe_v(pe_in_v[i]), 
            .din_pe(pe_in[i]),           
            .din_tx_v(pe_tx_v[i-1]), 
            .din_tx(pe_tx[i-1]),
            .din_shift_v(pe_shift_v[i]), 
            .din_shift(pe_shift[i]),  
            .s_shift(shift[i-1]), 
            
            .dout_pe_v(pe_out_v[i]), 
            .dout_pe(pe_out[i]), 
            .dout_tx_v(pe_tx_v[i]), 
            .dout_tx(pe_tx[i]),
            .dout_shift_v(pe_shift_v[i-1]), 
            .dout_shift(pe_shift[i-1]),
            .m_shift(shift[i])
            ); 
        end
        
//        assign p_in[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2] = pe_out[i];
//        assign array_out_v = pe_out_v[i] ? 1 : 0;
//        assign array_out = array_out_v ? pe_out[i] : 0;
        
//        assign array_out[(i+1)*`DATA_WIDTH*2-1:i*`DATA_WIDTH*2] = pe_out[i];
        
    end
endgenerate

//genvar k;
//generate
//    for (k = 0; k < `PE_NUM-1; k = k + 1) begin : out_valid
//        array_out_v = pe_out_v[k] | pe_out_v[k+1];
//    end
//endgenerate 

//piso_new out_buffer(
//    .clk(clk), 
//    .load(load),
//    .p_in_v(), //
//    .p_in(p_in), 
//    .s_out_v(dout_overlay_v), 
//    .s_out(dout_overlay)
//    );

//always @ (posedge clk) begin
//    if(load) begin
////        dout_overlay_v <= 1;
//        dout_overlay <= array_out;
//    end
//    else begin
////        dout_overlay_v <= 0;
//        dout_overlay <= 0;
//    end
//end

integer k;
always @ (posedge clk) begin
    for (k = 0; k < `PE_NUM; k = k + 1) begin 
        if(load) begin
            dout_overlay_v <= 1;
            dout_overlay <= pe_out[k];
        end
        else begin
            dout_overlay_v <= 0;
            dout_overlay <= 0;
        end
    end
end
    
endmodule