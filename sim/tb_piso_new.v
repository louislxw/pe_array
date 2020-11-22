`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2020 16:38:13
// Design Name: 
// Module Name: tb_piso_new
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

module tb_piso_new;

    // Inputs
    reg clk;
    reg load;
    reg p_in_v;
    reg [`PE_NUM*`DATA_WIDTH*2-1:0] p_in;

    // Outputs
    wire s_out_v;
    wire [`DATA_WIDTH*2-1:0] s_out; 
    
    // Instantiate the Unit Under Test (UUT)
    piso_new uut(
    .clk(clk),
    .load(load),
    .p_in_v(p_in_v), 
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
        load = 0;
        p_in_v = 0;
        p_in = 32'h0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here        
        #20; p_in_v = 1; load = 1; p_in = 128'h00000001_00001000_00010000_01000000; 
		#20; p_in_v = 1; load = 1; p_in = 128'h00000002_00002000_00020000_02000000; 
		#20; p_in_v = 1; load = 1; p_in = 128'h00000003_00003000_00030000_03000000;
		#20; p_in_v = 1; load = 1; p_in = 128'h00000004_00004000_00040000_04000000; 
		#20; p_in_v = 1; load = 0; p_in = 128'h00000005_00005000_00050000_05000000; 
		#20; p_in_v = 1; p_in = 128'h00000006_00006000_00060000_06000000;
        #20; p_in_v = 1; p_in = 128'h00000007_00007000_00070000_07000000; 
		#20; p_in_v = 1; p_in = 128'h00000008_00008000_00080000_08000000; 
		#20; p_in_v = 1; p_in = 128'h00000009_00009000_00090000_09000000;
		#20; p_in_v = 1; p_in = 128'h0000000a_0000a000_000a0000_0a000000; 
		#20; p_in_v = 1; p_in = 128'h0000000b_0000b000_000b0000_0b000000; 
		#20; p_in_v = 1; p_in = 128'h0000000c_0000c000_000c0000_0c000000;
        #20; p_in_v = 1; p_in = 128'h0000000d_0000d000_000d0000_0d000000; 
		#20; p_in_v = 1; p_in = 128'h0000000e_0000e000_000e0000_0e000000; 
		#20; p_in_v = 1; p_in = 128'h0000000f_0000f000_000f0000_0f000000;
		#20; p_in_v = 1; p_in = 128'h00000010_00010000_00100000_10000000; 
		#20; p_in_v = 1; p_in = 128'h00000011_00011000_00110000_11000000; 
		#20; p_in_v = 1; p_in = 128'h00000012_00012000_00120000_12000000;
        #20; p_in_v = 1; p_in = 128'h00000013_00013000_00130000_13000000; 
		#20; p_in_v = 1; p_in = 128'h00000014_00014000_00140000_14000000; 
		#20; p_in_v = 1; p_in = 128'h00000015_00015000_00150000_15000000;
		#20; p_in_v = 1; p_in = 128'h00000016_00016000_00160000_16000000; 
		#20; p_in_v = 1; p_in = 128'h00000017_00017000_00170000_17000000; 
		#20; p_in_v = 1; p_in = 128'h00000018_00018000_00180000_18000000;
		#20; p_in_v = 1; p_in = 128'h00000019_00019000_00190000_19000000; 
		#20; p_in_v = 1; p_in = 128'h0000001a_0001a000_001a0000_1a000000; 
		#20; p_in_v = 1; p_in = 128'h0000001b_0001b000_001b0000_1b000000;
        #20; p_in_v = 1; p_in = 128'h0000001c_0001c000_001c0000_1c000000; 
		#20; p_in_v = 1; p_in = 128'h0000001d_0001d000_001d0000_1d000000; 
		#20; p_in_v = 1; p_in = 128'h0000001e_0001e000_001e0000_1e000000;
		#20; p_in_v = 1; p_in = 128'h0000001f_0001f000_001f0000_1f000000; 
		#20; p_in_v = 1; p_in = 128'h00000020_00020000_00200000_20000000; 	
		
		#20; p_in_v = 0; 
		
		#1000; 
    end
    
endmodule
