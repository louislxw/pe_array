`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2020 17:08:49
// Design Name: 
// Module Name: tb_pe
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

module tb_pe;

    // Inputs
    reg clk;
    reg rst;
    reg din_v;
//    reg [`DATA_WIDTH*2-1:0] din_ld;
    reg [`DATA_WIDTH*2-1:0] din_pe;
    reg inst_in_v;
    reg [`INST_WIDTH-1:0] inst_in;
    
    // Outputs
    wire dout_v;
    wire [`DATA_WIDTH*2-1:0] dout_pe; 
//    wire inst_out_v;
//    wire [`INST_WIDTH-1:0] inst_out;
    
    // Instantiate the Unit Under Test (UUT)
    pe uut(
    .clk(clk), 
    .rst(rst), 
    .din_v(din_v),
//    .din_ld(din_ld),
    .din_pe(din_pe),
    .inst_in_v(inst_in_v), 
    .inst_in(inst_in),
    .dout_v(dout_v), 
    .dout_pe(dout_pe)
//    .inst_out_v(inst_out_v),
//    .inst_out(inst_out) 
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
        din_v = 0;
//        din_ld = 0;
        din_pe = 0;
        inst_in_v = 0;
//        inst_in = 0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; rst = 0; 
		#20;
		#20;

//		#20; inst_in_v = 1; inst_in = 64'h0_0_0000000_0_00_00_00; // din_ld
//		#20; inst_in_v = 1; inst_in = 64'h0_0_0000000_0_01_00_00; // din_ld
// 		#20; inst_in_v = 1; inst_in = 64'h0_0_0000000_0_02_00_00; // din_ld
//		#20; inst_in_v = 1; inst_in = 64'h4_0_0000000_0_03_00_00; // din_pe
//		#20; inst_in_v = 1; inst_in = 64'h4_0_0000000_0_04_00_00; // din_pe
//		#20; inst_in_v = 1; inst_in = 64'h4_0_0000000_0_05_00_00; // din_pe
//		#20; inst_in_v = 1; inst_in = 64'h0_8_0000000_3_00_01_00; // CMPLX_MULT
//		#20; inst_in_v = 1; inst_in = 64'h0_8_0000000_3_00_03_02; // CMPLX_MULT
//		#20; inst_in_v = 1; inst_in = 64'h0_8_0000000_3_00_05_04; // CMPLX_MULT

        // Load the instructions
        #20; // inst_in_v = 1; inst_in = 64'h0_0_0000000_0_00_00_00; // din_pe
        #20; // inst_in_v = 1; inst_in = 64'h0_0_0000000_0_01_00_00; // din_pe
        #20; // inst_in_v = 1; inst_in = 64'h0_0_0000000_0_02_00_00; // din_pe
		#20; // inst_in_v = 1; inst_in = 64'h0_0_0000000_0_03_00_00; // din_pe
		#20; // inst_in_v = 1; inst_in = 64'h0_0_0000000_0_04_00_00; // din_pe
		#20; // inst_in_v = 1; inst_in = 64'h0_0_0000000_0_05_00_00; // din_pe
		#20; inst_in_v = 1; inst_in = 64'h0_8_0000000_3_00_01_00; // CMPLX_MULT
		#20; inst_in_v = 1; inst_in = 64'h0_8_0000000_3_00_03_02; // CMPLX_MULT
		#20; inst_in_v = 1; inst_in = 64'h0_8_0000000_3_00_05_04; // CMPLX_MULT
		
//		#20; inst_in_v = 0; inst_in = 0; din_v = 0;
//		#20; inst_in_v = 0; inst_in = 0; din_v = 0;
//		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_ld = 32'h0004_0002;  din_pe = 32'd2; // 4 + j*2 
//		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_ld = 32'h0003_0001;  din_pe = 32'd4; // 3 + j*1
//		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_ld = 32'h0008_0006;  din_pe = 32'd6; // 8 + j*6 
//		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_ld = 32'd7;  din_pe = 32'h0007_0005; // 7 + j*5 
//		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_ld = 32'd9;  din_pe = 32'h000c_000a; // 12 + j*10
//		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_ld = 32'd11; din_pe = 32'h000b_0009; // 11 + j*9

        // Load the data
		#20; inst_in_v = 0; inst_in = 0; din_v = 0;
		#20; inst_in_v = 0; inst_in = 0; din_v = 0;
		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
		#20; inst_in_v = 0; inst_in = 0; din_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
		
//		#20; din_v = 0; din_ld = 32'd0;  din_pe = 0; 
//		#20; din_v = 0; din_ld = 32'd0;  din_pe = 0; 
//		#20; din_v = 0; din_ld = 32'd0;  din_pe = 0; 
//		#20; din_v = 0; din_ld = 32'd0;  din_pe = 0; 

		#20; din_v = 0; din_pe = 0; 
		#20; din_v = 0; din_pe = 0; 
		#20; din_v = 0; din_pe = 0; 
		#20; din_v = 0; din_pe = 0; 
				
		#1000;
		
    end    

endmodule
