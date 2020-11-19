`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2020 17:44:50
// Design Name: 
// Module Name: tb_PISO
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

module tb_PISO;

    // Inputs
    reg clk;
    reg rst;
    reg ce;
    reg load; 
    reg [`PE_NUM*`DATA_WIDTH*2-1:0] p_in;
    
    // Outputs
    wire s_out_v;
    wire [`DATA_WIDTH*2-1:0] s_out; 

    // Instantiate the Unit Under Test (UUT)
    PISO uut(
    .clk(clk), 
    .rst(rst), 
    .ce(ce),
    .load(load),
    .p_in(p_in), 
    .s_out_v(s_out_v),
    .s_out(s_out) 
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
        rst = 0;
        ce = 0;
        load = 0;
        p_in = 0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; load = 0; rst = 0; ce = 1;
		#20; load = 0; p_in = 128'h00000001_00000002_00000003_00000004; 
		#20; load = 1;
		#20; load = 1;
		#20; load = 1; 
		#20; load = 1; p_in = 128'h11111111_22222222_33333333_44444444; 
		#20; load = 1;
		#20; load = 1;
		#20; load = 1; //
		#20; load = 1; //
		#20; load = 1; p_in = 128'h00000011_00000022_00000033_00000044; 
		#20; load = 1; 
		#20; load = 1; 
		#20; load = 1; 
		#20; load = 1; p_in = 128'h11111111_22222222_33333333_44444444; 
		#20; load = 1; 
		#20; load = 1;  
		#20; load = 1; 
		#20; load = 1; 
		#20; load = 0; p_in = 256'h0;
		#20; load = 0; 
		#20; load = 0;
		#20; load = 0;
		
		#1000;
		
    end 

endmodule
