`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2020 12:09:10
// Design Name: 
// Module Name: tb_srl
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

module tb_srl;

    // Inputs
    reg clk;
    reg ce;
    reg [`DATA_WIDTH*2-1:0] din;
    
    // Outputs
    wire [`DATA_WIDTH*2-1:0] dout; 
    
    // Instantiate the Unit Under Test (UUT)
    srl uut(
    .clk(clk), 
    .ce(ce), 
    .din(din),
    .dout(dout)
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
        ce = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
		#20; ce = 1; din = 32'd1; 
		#20; ce = 1; din = 32'd2; 
		#20; ce = 1; din = 32'd3; 
		#20; ce = 1; din = 32'd4;
		#20; ce = 1; din = 32'd5; 
		#20; ce = 1; din = 32'd6; 
		#20; ce = 1; din = 32'd7;
		#20; ce = 1; din = 32'd8;
		#20; ce = 1; din = 32'd9;
		#20; ce = 1; din = 32'd10;
		#20; ce = 1; din = 32'd11; 
		#20; ce = 1; din = 32'd12; 
		#20; ce = 1; din = 32'd13; 
		#20; ce = 1; din = 32'd14;
		#20; ce = 1; din = 32'd15; 
		#20; ce = 1; din = 32'd16; 
		#20; ce = 1; din = 32'd17;
		#20; ce = 1; din = 32'd18;
		#20; ce = 1; din = 32'd19;
		#20; ce = 1; din = 32'd20;
		#20; ce = 1; din = 32'd21; 
		#20; ce = 1; din = 32'd22; 
		#20; ce = 1; din = 32'd23; 
		#20; ce = 1; din = 32'd24;
		#20; ce = 1; din = 32'd25; 
		#20; ce = 1; din = 32'd26; 
		#20; ce = 1; din = 32'd27;
		#20; ce = 1; din = 32'd28;
		#20; ce = 1; din = 32'd29;
		#20; ce = 1; din = 32'd30;
		#20; ce = 1; din = 32'd31;
		#20; ce = 1; din = 32'd32;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 1;
		#20; ce = 0;	
		#1000;
		
    end         
        
endmodule
