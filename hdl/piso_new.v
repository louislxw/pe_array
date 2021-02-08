`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2020 16:59:44
// Design Name: 
// Module Name: piso_new
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 12,289 LUTs, 2 FFs 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module piso_new(
    clk, load, p_in_v, p_in, s_out_v, s_out
    );
    
input clk;
//input rst;
input load;
input p_in_v;
input [`PE_NUM*`DATA_WIDTH*2-1:0] p_in; // no register

output s_out_v;
output [`DATA_WIDTH*2-1:0] s_out; // no register

wire [`DATA_WIDTH*2-1:0] srl_in [0:`PE_NUM-1]; 
wire [`DATA_WIDTH*2-1:0] srl_out [0:`PE_NUM-1]; 
 
genvar j;
for(j = 0; j < `PE_NUM; j = j+1) begin 
    if (j == `PE_NUM-1) 
        assign srl_in[`PE_NUM-1] = load ? p_in[(j+1)*`DATA_WIDTH*2-1:j*`DATA_WIDTH*2] : 1'b0; 
    else
        assign srl_in[j] = load ? p_in[(j+1)*`DATA_WIDTH*2-1:j*`DATA_WIDTH*2] : srl_out[j+1];
end

//wire ce_srl;
//assign ce_srl = load ? 1'b0 : 1'b1;
    
genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i+1) begin: siso_alpha
        srl_macro srl_inst(
        .clk(clk), 
        .ce(1'b1), // 1'b1
        .din(srl_in[i]), 
        .dout(srl_out[i]) // srl_in[i-1]
        ); 
    end 

endgenerate      

assign s_out = srl_out[0];

parameter DELAY = `REG_NUM;
reg [DELAY-1:0] shift_reg_v = 0;
always @ (posedge clk) begin 
    shift_reg_v <= {shift_reg_v[DELAY-2:0], p_in_v};
end
assign s_out_v = shift_reg_v[DELAY-1]; // valid signal for parallel outputs
    
endmodule
