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
		#20; wren = 1; wdata = 32'h0004_0002; // 4 + j*2 
		#20; wren = 1; wdata = 32'h0003_0001; // 3 + j*1 
		#20; wren = 1; wdata = 32'h0008_0006; // 8 + j*6 
		#20; wren = 1; wdata = 32'h0007_0005; // 7 + j*5 
		#20; wren = 1; wdata = 32'h000c_000a; // 12 + j*10 
		#20; wren = 0; wdata = 32'h000b_0009; // 11 + j*9 
		
		// Load the instructions (only affects the raddr1, raddr0, and waddr)
	    #20; inst_v = 1; rden = 0; inst = 32'h60_01_00_80; // CMPLX_MULT 
		#20; inst_v = 1; rden = 1; inst = 32'h60_03_02_81; // CMPLX_MULT 
		#20; inst_v = 1; rden = 1; inst = 32'h60_05_04_82; // CMPLX_MULT 
		#20; inst_v = 0; rden = 1; inst = 0;
		#20; rden = 0; 
		
        #20; wben = 1; 
        #20; wben = 1; wdata = 32'h000a_000a; 
        #20; wben = 1; wdata = 32'h001a_0052; 
        #20; wben = 0; wdata = 32'h002a_00da; 
        #20; wdata = 0; 
		
		#1000;
		
    end

endmodule
