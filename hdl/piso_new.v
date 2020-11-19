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
// Dependencies: 8,192 LUTs, 8,192 FFs 
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

wire [`DATA_WIDTH*2-1:0] srl_out; 

wire [`DATA_WIDTH*2-1:0] srl_in [0:`PE_NUM-1]; 
wire ce_srl;
 
genvar j;
for(j = 0; j < `PE_NUM; j = j+1) begin 
    assign srl_in[j] = load ? p_in[(j+1)*`DATA_WIDTH*2-1:j*`DATA_WIDTH*2] : 1'b0;
end
assign ce_srl = load ? 1'b0 : 1'b1;

//always @(posedge clk) 
//    s_out <= srl_out;
    
genvar i;
generate
    for (i = 0; i < `PE_NUM; i = i+1) begin: piso_srl
        // srl_0 (Output)
        if (i == 0)  
            srl srl_inst(
            .clk(clk), 
            .ce(ce_srl), // 1'b1
            .din(srl_in[0]), 
            .dout(s_out)
            );
        // srl_1 to srl_N-1 (left shift: from high to low)
        else 
            srl srl_inst(
            .clk(clk), 
            .ce(ce_srl), // 1'b1
            .din(srl_in[i]), 
            .dout(srl_in[i-1]) 
            ); 
    end 
    
//    assign s_out = srl_out;
    
endgenerate      

parameter DELAY = `REG_NUM;
reg [DELAY-1:0] shift_reg_v = 0;
always @ (posedge clk) begin 
    shift_reg_v <= {shift_reg_v[DELAY-2:0], p_in_v};
end
assign s_out_v = shift_reg_v[DELAY-1]; // valid signal for parallel outputs
    
endmodule
