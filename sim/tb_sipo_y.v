`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2020 18:05:22
// Design Name: 
// Module Name: tb_sipo_y
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

module tb_sipo_y;
    
    // Inputs
    reg clk;
    reg s_in_v;
    reg [`DATA_WIDTH*2-1:0] s_in;

    // Outputs
    wire p_out_v;
    wire [`PE_NUM*`DATA_WIDTH*2-1:0] p_out; 
    
    // Instantiate the Unit Under Test (UUT)
    sipo_y uut(
    .clk(clk), 
    .s_in_v(s_in_v), 
    .s_in(s_in),
    .p_out_v(p_out_v),
    .p_out(p_out)
    );
    
    parameter PERIOD = 20;

    always begin
        clk = 1'b0;
        #(PERIOD/2) clk = 1'b1;
        #(PERIOD/2);
    end
    
    integer cycle;
    
    initial cycle = 0;
    always @(posedge clk)
        cycle = cycle + 1;
        
    initial begin
        // Initialize Inputs
        clk = 0;
        s_in_v = 0;
        s_in = 32'd0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
		#20; s_in_v = 1; s_in = 32'd1; 
		#20; s_in_v = 1; s_in = 32'd2; 
		#20; s_in_v = 1; s_in = 32'd3; 
		#20; s_in_v = 1; s_in = 32'd4;
		#20; s_in_v = 1; s_in = 32'd5; 
		#20; s_in_v = 1; s_in = 32'd6; 
		#20; s_in_v = 1; s_in = 32'd7;
		#20; s_in_v = 1; s_in = 32'd8;
		#20; s_in_v = 1; s_in = 32'd9;
		#20; s_in_v = 1; s_in = 32'd10;
		#20; s_in_v = 1; s_in = 32'd11; 
		#20; s_in_v = 1; s_in = 32'd12; 
		#20; s_in_v = 1; s_in = 32'd13; 
		#20; s_in_v = 1; s_in = 32'd14;
		#20; s_in_v = 1; s_in = 32'd15; 
		#20; s_in_v = 1; s_in = 32'd16; 
		#20; s_in_v = 1; s_in = 32'd17;
		#20; s_in_v = 1; s_in = 32'd18;
		#20; s_in_v = 1; s_in = 32'd19;
		#20; s_in_v = 1; s_in = 32'd20;
		#20; s_in_v = 1; s_in = 32'd21; 
		#20; s_in_v = 1; s_in = 32'd22; 
		#20; s_in_v = 1; s_in = 32'd23; 
		#20; s_in_v = 1; s_in = 32'd24;
		#20; s_in_v = 1; s_in = 32'd25; 
		#20; s_in_v = 1; s_in = 32'd26; 
		#20; s_in_v = 1; s_in = 32'd27;
		#20; s_in_v = 1; s_in = 32'd28;
		#20; s_in_v = 1; s_in = 32'd29;
		#20; s_in_v = 1; s_in = 32'd30;
		#20; s_in_v = 1; s_in = 32'd31;
		#20; s_in_v = 1; s_in = 32'd32;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
//		#20; s_in_v = 1;
		#20; s_in_v = 0;	
		#1000;
		
    end  
    
endmodule
