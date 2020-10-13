`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2020 17:22:02
// Design Name: 
// Module Name: tb_SIPO
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

module tb_SIPO;

    // Inputs
    reg clk;
    reg rst;
    reg [`DATA_WIDTH*2-1:0] s_in;
    reg load; 
    
    // Outputs
    wire [`REG_NUM*`DATA_WIDTH*2-1:0] p_out; 

    // Instantiate the Unit Under Test (UUT)
    SIPO uut(
    .clk(clk), 
    .rst(rst), 
    .s_in(s_in), 
    .load(load), 
    .p_out(p_out) 
    ); 

    parameter PERIOD = 20;

    always begin
        clk = 1'b0;
        #(PERIOD/2) clk = 1'b1;
        #(PERIOD/2);
    end
    
     initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        s_in = 0;
        load = 0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; load = 0; rst = 0; 
		#20; load = 0; 
		#20; load = 0; 
		#20; load = 0;
		#20; load = 1; s_in = 32'd1; 
		#20; load = 1; s_in = 32'd2; 
		#20; load = 1; s_in = 32'd3; 
		#20; load = 1; s_in = 32'd4;
		#20; load = 1; s_in = 32'd5; 
		#20; load = 1; s_in = 32'd6; 
		#20; load = 1; s_in = 32'd7;
		#20; load = 1; s_in = 32'd8;
		#20; load = 0; s_in = 32'd9;
		#20; load = 0; s_in = 32'd10;
		#20; load = 0;
		#20; load = 0;
		
		#1000;
		
    end   

endmodule


