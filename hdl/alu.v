`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2020 19:43:27
// Design Name: 
// Module Name: alu
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

module alu (

	input clk,
	input rst,
	input cea2_i,
	input ceb2_i,
	input usemult_i,	// select mux
	input [`PORTA_WIDTH-1:0]	a_i,
	input [`PORTB_WIDTH-1:0]	b_i,
	input [`PORTC_WIDTH-1:0]	c_i,
	input [`ALUMODE_WIDTH-1:0]	alumode_i,
	input [`INMODE_WIDTH-1:0]	inmode_i,
	input [`OPMODE_WIDTH-1:0]	opmode_i,

	output [`PORTP_WIDTH-1:0]   p_o	// to ex3 and regfile
);

// Internal signals
reg  [`OPMODE_WIDTH-1:0]  qopmode_o_reg1;
reg  [`ALUMODE_WIDTH-1:0] qalumode_o_reg1;
reg  [`INMODE_WIDTH-1:0]  qinmode_o_reg1;
wire [`OPMODE_WIDTH-1:0]  qinmode_o_mux;
reg  [`PORTC_WIDTH-1:0]   qc0_o_reg1;
reg	 qcea2_o_reg1, qceb2_o_reg1;

DSP48E2 #( 
	// Feature Control Attributes: Data Path Selection
	.ACASCREG 		( 2 ), // ACASCRAG = AREG = ADREG = CREG
	.ADREG			( 0 ), // Pipeline stages for pre-adder (0-1)
	.ALUMODEREG 	( 1 ), // Pipeline stages for ALUMODE (0-1)
	.AREG 			( 2 ), // Pipeline stages for A (0-2)
	.BCASCREG 		( 2 ), // Number of pipeline stages between B/BCIN and BCOUT (0-2)
	.BREG 			( 2 ), // Pipeline stages for B (0-2)
	.CARRYINREG 	( 1 ), // Pipeline stages for CARRYIN (0-1)
	.CARRYINSELREG 	( 1 ), // Pipeline stages for CARRYINSEL (0-1)
	.CREG 			( 1 ), // Pipeline stages for C (0-1)
	.DREG 			( 0 ), // Pipeline stages for D (0-1)
	.INMODEREG 		( 1 ), // Pipeline stages for INMODE (0-1)
	.MREG 			( 1 ), // Multiplier pipeline stages (0-1)
	.OPMODEREG 		( 1 ), // Pipeline stages for OPMODE (0-1)
	.A_INPUT 		( "DIRECT" ), // Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
	.B_INPUT 		( "DIRECT" ), // Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
	// .USE_DPORT 		( "FALSE" ),  // d port and preadder not used, only a port
	.USE_MULT 		( "DYNAMIC" ),  // Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
	.USE_SIMD 		( "ONE48" ),    // SIMD selection (FOUR12, ONE48, TWO24)
	.AUTORESET_PATDET ( "NO_RESET" ), 		// do not reset P register
	.MASK 			( 48'h000000000000 ), 	// every bit is compared
	.PATTERN 		( 48'h000000000000 ),  // 48-bit pattern match for pattern detect
	.SEL_MASK 		( "MASK" ),  // C, MASK, ROUNDING_MODE1, ROUNDING_MODE2
	.SEL_PATTERN 	( "C" ),    // Select pattern value (C, PATTERN)	 	
	.USE_PATTERN_DETECT ( "NO_PATDET" ) 	// pattern detection disabled		
)
	DSP48E2_inst (
	.ACOUT			(/*cascade*/), 
	.BCOUT			(/*cascade*/), 
	.CARRYCASCOUT	(/*cascade*/), 
	.CARRYOUT		(/*carryout*/), 
	.MULTSIGNOUT	(/*cascade*/), 
	.OVERFLOW		(/*overflow_o*/), 
	.P				(p_o), // 48-bit output: Primary data
	.PATTERNBDETECT	(), 
	.PATTERNDETECT	(), 
	.PCOUT			(/*cascade*/), 
	.UNDERFLOW		(), 
	.A				(a_i), // 30-bit input: A data
	.ACIN			(/*cascade*/), 
	.ALUMODE		(qalumode_o_reg1), // 4-bit input: ALU control
	.B				(b_i), // 18-bit input: B data
	.BCIN			(/*cascade*/),
	.C				(qc0_o_reg1), // 48-bit input: C data
	.CARRYCASCIN	(/*cascade*/), 
	.CARRYIN		(1'b0), 
	.CARRYINSEL		(3'b000), 
	.CEA1			(1'b1), 
	.CEA2			(qcea2_o_reg1), 
	.CEAD			(1'b0), 
	.CEALUMODE		(1'b1), 
	.CEB1			(1'b1), 
	.CEB2			(qceb2_o_reg1), 
	.CEC			(1'b1), 
	.CECARRYIN		(1'b1), 
	.CECTRL			(1'b1), 
	.CED			(1'b0), 
	.CEINMODE		(1'b1), 
	.CEM			(1'b1), 
	.CEP			(1'b1), 
	.CLK			(clk), 
	.D				(25'h0000000), 
	.INMODE			(qinmode_o_mux), // 5-bit input: INMODE control
	.MULTSIGNIN		(/*cascade*/), 
	.OPMODE			(qopmode_o_reg1), // 9-bit input: Operation mode
	.PCIN			(/*cascade*/),
	.RSTA			(rst), 
	.RSTALLCARRYIN	(rst), 
	.RSTALUMODE		(rst), 
	.RSTB			(rst), 
	.RSTC			(rst), 
	.RSTCTRL		(rst), 
	.RSTD			(rst), 
	.RSTINMODE		(rst), 
	.RSTM			(rst), 
	.RSTP			(rst)
);

// extra c0 register in the fabric
// Control signal for C0REG (Capital C Zero)
// FF
always@(posedge clk)
begin
	if (rst)
	begin
		qc0_o_reg1 <= 48'h000000000000;
		qinmode_o_reg1 <= 5'h00;

	end
	else
	begin
		qc0_o_reg1 <= c_i;
		qinmode_o_reg1 <= inmode_i;
	end
end

// Mux
assign qinmode_o_mux = (~usemult_i) ? qinmode_o_reg1 : inmode_i; // add an extra reg for inmode for non-mult ops 

// ************** Input: Control Signals ************* //
// CEA2, CEB2, ALUMODE and OPMODE to hold for 1 clk cycle 
// in order to reach the second stage of the pipeline
always@(posedge clk)
begin
	if (rst)
	begin
		qcea2_o_reg1 <= 1'b0;
		qceb2_o_reg1 <= 1'b0;
		qalumode_o_reg1 <= 4'h0;
		qopmode_o_reg1 <= 7'b0000000;
	end		
	else
	begin
		qcea2_o_reg1 <= cea2_i;
		qceb2_o_reg1 <= ceb2_i;
		qalumode_o_reg1 <= alumode_i;
		qopmode_o_reg1 <= opmode_i;
	end
end

endmodule
