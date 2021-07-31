`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2021 02:01:52 PM
// Design Name: 
// Module Name: tb_pe_array_bd
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

module tb_pe_array_bd;

    // Inputs
    reg clk; 
    reg rst; 
    reg load; 
    reg din_v; 
    reg [`DATA_WIDTH*2-1:0] din; 

    wire dout_v; 
    wire [`DATA_WIDTH*2-1:0] dout; 

    // Instantiate the Unit Under Test (UUT)
    pe_array_bd uut(
    .clk(clk), 
    .rst(rst), 
    .load(load), 
    .din_v(din_v), 
    .din(din), 
    .dout_v(dout_v), 
    .dout(dout)
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
    integer fd;
    reg [`DATA_WIDTH*2-1:0] captured_data;
    
    reg [`DATA_WIDTH*2-1:0] dout_r; 
    reg dout_v_r;
    
    always @(posedge clk) begin
        dout_r <= dout;
        dout_v_r <= dout_v;
        
//        if (dout_v_r) 
            $fwrite(fd, "%x\n", dout);
         
        scan_file = $fscanf(data_file, "%x\n", captured_data); 
        
        if (!$feof(data_file) && !rst) begin
            //use captured_data as you would any other wire or reg value;
            din <= captured_data;
            din_v <= 1;          
        end
        else begin
            din <= 0;
            din_v <= 0;
        end
        
//        if (dout_v)
            
    end
    
    reg sim_done = 0;

//    always @(posedge clk) begin
//        if (din_v)
//            $fwrite(fd, "%x\n", din);

//        if (sim_done) begin
//            $fclose(fd);
//            $finish;
//        end
//    end
    
    initial begin
        // Initialize Inputs
        clk = 0;
        load = 0;
        din_v = 0;
        din = 0; 
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; rst = 0; 
        // Load the data  
//        data_file = $fopen("array_input_hex.txt", "rb"); //read mode, binary (128-PE array -> 256*32*2)
        data_file = $fopen("/home/louis/workspace/vivado/pe_array_bd/pe_array_bd.srcs/sim_1/new/array16_input_hex.txt", "rb"); //read mode, binary (8-PE array -> 16*32*2)
        if (data_file == `NULL) begin
            $display("data_file handle was NULL");
            $stop; // $finish;
        end
        
        #20;
        fd = $fopen("/home/louis/workspace/vivado/pe_array_bd/pe_array_bd.srcs/sim_1/new/log.txt", "w"); // write mode
        if (fd == `NULL) begin
            $display("Could not open file '%s' for writing","log.txt");
            $stop;
        end  
        
        #5000;
        sim_done = 1; //
		
    end   

endmodule
