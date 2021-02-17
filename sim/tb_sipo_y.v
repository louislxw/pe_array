`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2020 18:05:22
// Design Name: 
// Module Name: tb_sipo_y
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

module tb_sipo_y;
    
    // Inputs
    reg clk;
//    reg ce;
    reg rst;
    reg shift_v;
    reg s_in_v;
    reg [`DATA_WIDTH*2-1:0] s_in;

    // Outputs
    wire p_out_v;
    wire [`PE_NUM*`DATA_WIDTH*2-1:0] p_out; 
    
    // Instantiate the Unit Under Test (UUT)
    sipo_y uut(
    .clk(clk),
//    .ce(ce),
    .rst(rst),
    .shift_v(shift_v),
    .s_in_v(s_in_v),
    .s_in(s_in),
    .p_out_v(p_out_v),
    .p_out(p_out) 
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
//        ce = 0;
        shift_v = 0;
        s_in_v = 0;
        s_in = 32'd0;
        
        // Wait 100 ns for global reset to finish
        rst = 1;
        #100;
        
        // Add stimulus here
        #20; rst = 0;  // ce = 1; 
        
        // Load state
        #20; s_in_v = 1;
		#20; s_in_v = 1; s_in = 32'd1;
		#20; s_in_v = 1; s_in = 32'd2; 
		#20; s_in_v = 1; s_in = 32'd3; 
		#20; s_in_v = 1; s_in = 32'd4;
		#20; s_in_v = 1; s_in = 32'd5; 
		#20; s_in_v = 1; s_in = 32'd6; 
		#20; s_in_v = 1; s_in = 32'd7;
		#20; s_in_v = 1; s_in = 32'd8;
		#20; s_in_v = 1; s_in = 32'd9;
		#20; s_in_v = 1; s_in = 32'd10;
		#20; s_in_v = 1; s_in = 32'd11; 
		#20; s_in_v = 1; s_in = 32'd12; 
		#20; s_in_v = 1; s_in = 32'd13; 
		#20; s_in_v = 1; s_in = 32'd14;
		#20; s_in_v = 1; s_in = 32'd15; 
		#20; s_in_v = 1; s_in = 32'd16; 
		#20; s_in_v = 1; s_in = 32'd17;
		#20; s_in_v = 1; s_in = 32'd18;
		#20; s_in_v = 1; s_in = 32'd19;
		#20; s_in_v = 1; s_in = 32'd20;
		#20; s_in_v = 1; s_in = 32'd21; 
		#20; s_in_v = 1; s_in = 32'd22; 
		#20; s_in_v = 1; s_in = 32'd23; 
		#20; s_in_v = 1; s_in = 32'd24;
		#20; s_in_v = 1; s_in = 32'd25; 
		#20; s_in_v = 1; s_in = 32'd26; 
		#20; s_in_v = 1; s_in = 32'd27;
		#20; s_in_v = 1; s_in = 32'd28;
		#20; s_in_v = 1; s_in = 32'd29;
		#20; s_in_v = 1; s_in = 32'd30;
		#20; s_in_v = 1; s_in = 32'd31;
		#20; s_in_v = 1; s_in = 32'd32;

		#20; s_in_v = 1; s_in = 32'd33;
		#20; s_in_v = 1; s_in = 32'd34; 
		#20; s_in_v = 1; s_in = 32'd35; 
		#20; s_in_v = 1; s_in = 32'd36;
		#20; s_in_v = 1; s_in = 32'd37; 
		#20; s_in_v = 1; s_in = 32'd38; 
		#20; s_in_v = 1; s_in = 32'd39;
		#20; s_in_v = 1; s_in = 32'd40;
		#20; s_in_v = 1; s_in = 32'd41;
		#20; s_in_v = 1; s_in = 32'd42;
		#20; s_in_v = 1; s_in = 32'd43; 
		#20; s_in_v = 1; s_in = 32'd44; 
		#20; s_in_v = 1; s_in = 32'd45; 
		#20; s_in_v = 1; s_in = 32'd46;
		#20; s_in_v = 1; s_in = 32'd47; 
		#20; s_in_v = 1; s_in = 32'd48; 
		#20; s_in_v = 1; s_in = 32'd49;
		#20; s_in_v = 1; s_in = 32'd50;
		#20; s_in_v = 1; s_in = 32'd51;
		#20; s_in_v = 1; s_in = 32'd52;
		#20; s_in_v = 1; s_in = 32'd53; 
		#20; s_in_v = 1; s_in = 32'd54; 
		#20; s_in_v = 1; s_in = 32'd55; 
		#20; s_in_v = 1; s_in = 32'd56;
		#20; s_in_v = 1; s_in = 32'd57; 
		#20; s_in_v = 1; s_in = 32'd58; 
		#20; s_in_v = 1; s_in = 32'd59;
		#20; s_in_v = 1; s_in = 32'd60;
		#20; s_in_v = 1; s_in = 32'd61;
		#20; s_in_v = 1; s_in = 32'd62;
		#20; s_in_v = 1; s_in = 32'd63;
		#20; s_in_v = 1; s_in = 32'd64;

		#20; s_in_v = 1; s_in = 32'd65;
		#20; s_in_v = 1; s_in = 32'd66; 
		#20; s_in_v = 1; s_in = 32'd67; 
		#20; s_in_v = 1; s_in = 32'd68;
		#20; s_in_v = 1; s_in = 32'd69; 
		#20; s_in_v = 1; s_in = 32'd70; 
		#20; s_in_v = 1; s_in = 32'd71;
		#20; s_in_v = 1; s_in = 32'd72;
		#20; s_in_v = 1; s_in = 32'd73;
		#20; s_in_v = 1; s_in = 32'd74;
		#20; s_in_v = 1; s_in = 32'd75; 
		#20; s_in_v = 1; s_in = 32'd76; 
		#20; s_in_v = 1; s_in = 32'd77; 
		#20; s_in_v = 1; s_in = 32'd78;
		#20; s_in_v = 1; s_in = 32'd79; 
		#20; s_in_v = 1; s_in = 32'd80; 
		#20; s_in_v = 1; s_in = 32'd81;
		#20; s_in_v = 1; s_in = 32'd82;
		#20; s_in_v = 1; s_in = 32'd83;
		#20; s_in_v = 1; s_in = 32'd84;
		#20; s_in_v = 1; s_in = 32'd85; 
		#20; s_in_v = 1; s_in = 32'd86; 
		#20; s_in_v = 1; s_in = 32'd87; 
		#20; s_in_v = 1; s_in = 32'd88;
		#20; s_in_v = 1; s_in = 32'd89; 
		#20; s_in_v = 1; s_in = 32'd90; 
		#20; s_in_v = 1; s_in = 32'd91;
		#20; s_in_v = 1; s_in = 32'd92;
		#20; s_in_v = 1; s_in = 32'd93;
		#20; s_in_v = 1; s_in = 32'd94;
		#20; s_in_v = 1; s_in = 32'd95;
		#20; s_in_v = 1; s_in = 32'd96;

		#20; s_in_v = 1; s_in = 32'd97;
		#20; s_in_v = 1; s_in = 32'd98; 
		#20; s_in_v = 1; s_in = 32'd99; 
		#20; s_in_v = 1; s_in = 32'd100;
		#20; s_in_v = 1; s_in = 32'd101; 
		#20; s_in_v = 1; s_in = 32'd102; 
		#20; s_in_v = 1; s_in = 32'd103;
		#20; s_in_v = 1; s_in = 32'd104;
		#20; s_in_v = 1; s_in = 32'd105;
		#20; s_in_v = 1; s_in = 32'd106;
		#20; s_in_v = 1; s_in = 32'd107; 
		#20; s_in_v = 1; s_in = 32'd108; 
		#20; s_in_v = 1; s_in = 32'd109; 
		#20; s_in_v = 1; s_in = 32'd110;
		#20; s_in_v = 1; s_in = 32'd111; 
		#20; s_in_v = 1; s_in = 32'd112; 
		#20; s_in_v = 1; s_in = 32'd113;
		#20; s_in_v = 1; s_in = 32'd114;
		#20; s_in_v = 1; s_in = 32'd115;
		#20; s_in_v = 1; s_in = 32'd116;
		#20; s_in_v = 1; s_in = 32'd117; 
		#20; s_in_v = 1; s_in = 32'd118; 
		#20; s_in_v = 1; s_in = 32'd119; 
		#20; s_in_v = 1; s_in = 32'd120;
		#20; s_in_v = 1; s_in = 32'd121; 
		#20; s_in_v = 1; s_in = 32'd122; 
		#20; s_in_v = 1; s_in = 32'd123;
		#20; s_in_v = 1; s_in = 32'd124;
		#20; s_in_v = 1; s_in = 32'd125;
		#20; s_in_v = 1; s_in = 32'd126;
		#20; s_in_v = 1; s_in = 32'd127;
		#20; s_in_v = 1; s_in = 32'd128;

		#20; s_in_v = 0; // ce = 0; 
		
		// SHIFT status
		#20; shift_v = 1; // ce = 1; 
		#640; shift_v = 0; // ce = 0; 
		
		#500;
		// SHIFT status
		#20; shift_v = 1; // ce = 1; 
		#640; shift_v = 0; // ce = 0; 		

		#500;
		// SHIFT status
		#20; shift_v = 1; // ce = 1; 
		#640; shift_v = 0; // ce = 0; 

		#500;
		// SHIFT status
		#20; shift_v = 1; // ce = 1; 
		#640; shift_v = 0; // ce = 0; 
				
		#1000;
		
    end  
    
endmodule