`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2020 17:00:46
// Design Name: 
// Module Name: tb_data_mem
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

module tb_data_mem;

    // Inputs
    reg clk; 
    reg rst;
    reg wren; 
    reg wben;
    reg rden;
    reg inst_v;
    reg [`INST_WIDTH-1:0] inst;
    reg [`DATA_WIDTH*2-1:0] wdata;

    // Outputs
    wire [`DATA_WIDTH*2-1:0] rdata0;
    wire [`DATA_WIDTH*2-1:0] rdata1;

    // Instantiate the Unit Under Test (UUT)
    data_mem DMEM(
    .clk(clk), 
    .rst(rst), 
    .wren(wren), 
    .wben(wben),
    .rden(rden), 
    .inst_v(inst_v),
    .inst(inst), 
    .wdata(wdata), 
    .rdata0(rdata0),
    .rdata1(rdata1)
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
        wren = 0;
        wben = 0;
        rden = 0;
        inst_v = 0;
        inst = 0;
        wdata = 0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; wren = 0; rst = 0; 
		#20; wren = 0;  
		#20; wren = 0; 
		#20; wren = 0; 
        // wren or rden is aligned with inst; 1 cycle ahead of wdata 
        #20; wren = 1;                 
		#20; wren = 1; wdata = 32'd1;  
		#20; wren = 1; wdata = 32'd3;  
		#20; wren = 1; wdata = 32'd5;  
		#20; wren = 1; wdata = 32'd7;  
		#20; wren = 1; wdata = 32'd9;  
		#20; wren = 0; wdata = 32'd11; 
		
		// Load the instructions
	    #20; inst_v = 1; rden = 0; inst = 32'h00_01_00_00; // CMPLX_MULT 
		#20; inst_v = 1; rden = 1; inst = 32'h00_03_02_00; // CMPLX_MULT 
		#20; inst_v = 1; rden = 1; inst = 32'h00_05_04_00; // CMPLX_MULT 
		#20; inst_v = 0; rden = 1; 
		#20; rden = 0; 

		
		#1000;
		
    end

endmodule
