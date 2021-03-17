`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2021 10:36:46 PM
// Design Name: 
// Module Name: tb_pe_array
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
`define NULL 0  

module tb_pe_array;

    // Inputs
    reg clk; 
    reg rst; 
    reg load; 
    reg din_overlay_v; 
    reg [`DATA_WIDTH*2-1:0] din_overlay; 

//    wire dout_overlay_v; 
    wire [`DATA_WIDTH*2-1:0] dout_overlay; 

    // Instantiate the Unit Under Test (UUT)
    pe_array uut(
    .clk(clk), 
    .rst(rst), 
    .load(load), 
    .din_overlay_v(din_overlay_v), 
    .din_overlay(din_overlay), 
//    .dout_overlay_v(dout_overlay_v), 
    .dout_overlay(dout_overlay)
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

    integer data_file; // file handler
    integer scan_file; // file handler
    reg [`DATA_WIDTH*2-1:0] captured_data;
    
    always @(posedge clk) begin
        scan_file = $fscanf(data_file, "%x\n", captured_data); 
        if (!$feof(data_file) && !rst) begin
            //use captured_data as you would any other wire or reg value;
            din_overlay <= captured_data;
            din_overlay_v <= 1;
        end
        else begin
            din_overlay <= 0;
            din_overlay_v <= 0;
        end    
    end
    
    initial begin
        // Initialize Inputs
        clk = 0;
        load = 0;
        din_overlay_v = 0;
        din_overlay = 0; 
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; rst = 0; 
        // Load the data  
        data_file = $fopen("array_input_hex.txt", "rb"); //read mode, binary
        if (data_file == `NULL) begin
            $display("data_file handle was NULL");
            $finish;
        end
        
        /*
        // X0, Y0
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 
 
        // X1, Y1
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 
        
        // X2, Y2
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 
        
        // X3, Y3
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0006; // 8 + j*6 
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0005; // 7 + j*5 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000a; // 12 + j*10
        #20; din_overlay_v = 1; din_overlay = 32'h000b_0009; // 11 + j*9
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0002; // 4 + j*2 // add
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0001; // 3 + j*1 // add 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 

        #20; din_overlay_v = 1; din_overlay = 32'h0009_0009; 
        #20; din_overlay_v = 1; din_overlay = 32'h000a_000a; 
        #20; din_overlay_v = 1; din_overlay = 32'h000b_000b; 
        #20; din_overlay_v = 1; din_overlay = 32'h000c_000c; 
        #20; din_overlay_v = 1; din_overlay = 32'h000d_000d; 
        #20; din_overlay_v = 1; din_overlay = 32'h000e_000e; 
        #20; din_overlay_v = 1; din_overlay = 32'h000f_000f; 
        #20; din_overlay_v = 1; din_overlay = 32'h0010_0010; 

        #20; din_overlay_v = 1; din_overlay = 32'h0001_0001; // 1 + j*1 
        #20; din_overlay_v = 1; din_overlay = 32'h0002_0002; // 2 + j*2
        #20; din_overlay_v = 1; din_overlay = 32'h0003_0003; // 3 + j*3 
        #20; din_overlay_v = 1; din_overlay = 32'h0004_0004; // 4 + j*4 
        #20; din_overlay_v = 1; din_overlay = 32'h0005_0005; // 5 + j*5
        #20; din_overlay_v = 1; din_overlay = 32'h0006_0006; // 6 + j*6
        #20; din_overlay_v = 1; din_overlay = 32'h0007_0007; // 7 + j*7
        #20; din_overlay_v = 1; din_overlay = 32'h0008_0008; // 8 + j*8 
 
        // invalid data below         
        #20; din_overlay_v = 0; din_overlay = 1; 
        #20; din_overlay_v = 0; din_overlay = 2; 
        #20; din_overlay_v = 0; din_overlay = 3; 
        #20; din_overlay_v = 0; din_overlay = 4; 
        #20; din_overlay_v = 0; din_overlay = 5; 
        #20; din_overlay_v = 0; din_overlay = 6; 
        */
        
        #2000;
		
    end   

endmodule