`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2020 12:10:37
// Design Name: 
// Module Name: tb_inst_mem
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

module tb_inst_mem;

    // Inputs
    reg clk;
    reg rst;
    reg valid;
    reg [`INST_WIDTH-1:0] inst_in;
    
    // Outputs
    wire [`INST_WIDTH-1:0] inst_out;
    
    // Instantiate the Unit Under Test (UUT)
    inst_mem uut(
    .clk(clk), 
    .rst(rst), 
    .valid(valid), 
    .inst_in(inst_in), 
    .inst_out(inst_out) 
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
        valid = 0;
        inst_in = 0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; valid = 0; rst = 0; 
		#20; valid = 0; 
		#20; valid = 0; 
		#20; valid = 0;
		#20; valid = 1; inst_in = 64'h00000000ffff0000; 
		#20; valid = 1; inst_in = 64'h00000000ffffaaaa; 
		#20; valid = 1; inst_in = 64'h00000000ffffbbbb; 
		#20; valid = 1; inst_in = 64'h00000000ffffcccc;
		#20; valid = 1; inst_in = 64'h00000000ffffdddd; 
		#20; valid = 0; inst_in = 0; 
		#20; valid = 0; 
		#20; valid = 0; 
		#20; valid = 0; 
		
		#1000;
		
    end

endmodule
