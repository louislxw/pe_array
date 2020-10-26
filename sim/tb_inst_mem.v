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
    reg inst_in_v;
    reg [`INST_WIDTH-1:0] inst_in;
    
    // Outputs
    wire inst_out_v;
    wire [`INST_WIDTH-1:0] inst_out;
    
    // Instantiate the Unit Under Test (UUT)
    inst_mem uut(
    .clk(clk), 
    .rst(rst), 
    .inst_in_v(inst_in_v), 
    .inst_in(inst_in), 
    .inst_out_v(inst_out_v),
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
        inst_in_v = 0;
        inst_in = 0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; inst_in_v = 0; rst = 0; 
		#20; inst_in_v = 0; 
		#20; inst_in_v = 0; 
		#20; inst_in_v = 0;
		#20; inst_in_v = 1; inst_in = 32'hffff0000; 
		#20; inst_in_v = 1; inst_in = 32'hffffaaaa; 
		#20; inst_in_v = 1; inst_in = 32'hffffbbbb; 
		#20; inst_in_v = 1; inst_in = 32'hffffcccc;
		#20; inst_in_v = 1; inst_in = 32'hffffdddd; 
		#20; inst_in_v = 0; inst_in = 0; 
		#20; inst_in_v = 0; 
		#20; inst_in_v = 0; 
		#20; inst_in_v = 0; 
		
		#1000;
		
    end

endmodule
