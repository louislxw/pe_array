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
    reg [`REG_NUM*`DATA_WIDTH*2-1:0] p_in;
    reg fetch; 
    
    // Outputs
    wire [`DATA_WIDTH*2-1:0] s_out; 

    // Instantiate the Unit Under Test (UUT)
    PISO uut(
    .clk(clk), 
    .rst(rst), 
    .p_in(p_in), 
    .fetch(fetch), 
    .s_out(s_out) 
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
        p_in = 0;
        fetch = 0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; fetch = 0; rst = 0; 
		#20; fetch = 0; p_in = 256'h00000001_00000002_00000003_00000004_00000005_00000006_00000007_00000008; 
		#20; fetch = 1;
		#20; fetch = 1;
		#20; fetch = 1; 
		#20; fetch = 1; p_in = 256'h11111111_22222222_33333333_44444444_55555555_66666666_77777777_88888888; 
		#20; fetch = 1;
		#20; fetch = 1;
		#20; fetch = 1; //
		#20; fetch = 1; //
		#20; fetch = 0; p_in = 256'h00000011_00000022_00000033_00000044_00000055_00000066_00000077_00000088; 
		#20; fetch = 1; 
		#20; fetch = 1; 
		#20; fetch = 1; 
		#20; fetch = 1; p_in = 256'h11111111_22222222_33333333_44444444_55555555_66666666_77777777_88888888; 
		#20; fetch = 1; 
		#20; fetch = 1;  
		#20; fetch = 1; 
		#20; fetch = 1; 
		#20; fetch = 0; p_in = 256'h0;
		#20; fetch = 0; 
		#20; fetch = 0;
		#20; fetch = 0;
		
		#1000;
		
    end 

endmodule
