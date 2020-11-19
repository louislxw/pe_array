`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2020 10:01:33
// Design Name: 
// Module Name: tb_piso_macro
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

module tb_piso_macro; 

    // Inputs
    reg clk;
    reg rst;
    reg load;
    reg ce;
    reg [`DATA_WIDTH*2-1:0] p_in;
    
    // Outputs
    wire s_out; 
    
    // Instantiate the Unit Under Test (UUT)
    piso_macro uut(
    .clk(clk), 
    .rst(rst),
    .load(load),
    .ce(ce), 
    .p_in(p_in),
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
        rst = 1;
        load = 0;
        ce = 0;
        p_in = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        rst = 0;
        // Add stimulus here
        #20; load = 1; p_in = 32'h0100_0001; 
        #20; load = 1; p_in = 32'h0100_0000; 
        #20; load = 1; p_in = 32'h0100_0001; 
        #20; load = 0; ce = 1;
        #640; 
        #20; ce = 0; p_in = 32'd0;
        
        #1000;
        
     end   

endmodule