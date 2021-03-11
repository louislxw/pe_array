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
    reg din_pe_v;
    reg [`DATA_WIDTH*2-1:0] din_pe;
    reg din_shift_v;
    reg [`DATA_WIDTH*2-1:0] din_shift;
    reg din_tx_v;
    reg [`DATA_WIDTH*2-1:0] din_tx;
//    reg inst_in_v;
//    reg [`INST_WIDTH-1:0] inst_in;
    
    // Outputs
    wire dout_pe_v;
    wire [`DATA_WIDTH*2-1:0] dout_pe; 
    wire dout_tx_v;
    wire [`DATA_WIDTH*2-1:0] dout_tx;
    wire dout_shift_v;
    wire [`DATA_WIDTH*2-1:0] dout_shift;
//    wire inst_out_v;
//    wire [`INST_WIDTH-1:0] inst_out;
    
    // Instantiate the Unit Under Test (UUT)
    pe uut(
    .clk(clk), 
    .rst(rst), 
    .din_pe_v(din_pe_v),
    .din_pe(din_pe),
    .din_shift_v(din_shift_v),
    .din_shift(din_shift),
    .din_tx_v(din_tx_v),
    .din_tx(din_tx),
//    .inst_in_v(inst_in_v), 
//    .inst_in(inst_in),
    .dout_pe_v(dout_pe_v), 
    .dout_pe(dout_pe),
    .dout_tx_v(dout_tx_v),
    .dout_tx(dout_tx),
    .dout_shift_v(dout_shift_v),
    .dout_shift(dout_shift)
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
        din_pe_v = 0;
        din_pe = 0; 
        din_shift_v = 0;
        din_shift = 0;
        din_tx_v = 0;
        din_tx = 0;
//        inst_in_v = 0;
//        inst_in = 32'h0000_0000; 
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; rst = 0; 
        #20;
        #20;

        // Load the instructions
//        #20; inst_in_v = 1; inst_in = 32'h80_01_00_80; // CMPLX_MULT (opcode = 100)
//        #20; inst_in_v = 1; inst_in = 32'h80_03_02_81; // CMPLX_MULT (opcode = 100)
//        #20; inst_in_v = 1; inst_in = 32'h80_05_04_82; // CMPLX_MULT (opcode = 100)

        // Load the data
//        #20; inst_in_v = 0; din_pe_v = 0; inst_in = 32'hxx_xx_xx_xx;
//        #20; inst_in_v = 0; din_pe_v = 1;
//        #20; inst_in_v = 0; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
//        #20; inst_in_v = 0; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
//        #20; inst_in_v = 0; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
//        #20; inst_in_v = 0; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
//        #20; inst_in_v = 0; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
//        #20; inst_in_v = 0; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
 
        #20; din_pe_v = 0; 
        #20; din_pe_v = 0;
        
        // Load 64 elements (32 for X, 32 for Y)
        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 

        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 

        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 

        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 

        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 

        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 

        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 

        #20; din_pe_v = 1; din_pe = 32'h0004_0002; // 4 + j*2 
        #20; din_pe_v = 1; din_pe = 32'h0003_0001; // 3 + j*1
        #20; din_pe_v = 1; din_pe = 32'h0008_0006; // 8 + j*6 
        #20; din_pe_v = 1; din_pe = 32'h0007_0005; // 7 + j*5 
        #20; din_pe_v = 1; din_pe = 32'h000c_000a; // 12 + j*10
        #20; din_pe_v = 1; din_pe = 32'h000b_0009; // 11 + j*9
        #20; din_pe_v = 1; din_pe = 32'h0002_0001; // 2 + j*1 
        #20; din_pe_v = 1; din_pe = 32'h0004_0003; // 4 + j*3 
                
        #20; din_pe_v = 0; din_pe = 1; 
        #20; din_pe_v = 0; din_pe = 2; 
        #20; din_pe_v = 0; din_pe = 3; 
        #20; din_pe_v = 0; din_pe = 4; 
        #20; din_pe_v = 0; din_pe = 5; 
        #20; din_pe_v = 0; din_pe = 6; 
        
        #200;
//        #20; inst_in_v = 1; inst_in = 32'hB1_01_00_00; // MULADD (opcode = 101 & Read ROM[1])
//        #20; inst_in_v = 1; inst_in = 32'hD2_03_02_00; // MULSUB (opcode = 110 & Read ROM[2])
//        #20; inst_in_v = 0; inst_in = 32'hxx_xx_xx_xx;
        
        #1000;
		
    end    

endmodule