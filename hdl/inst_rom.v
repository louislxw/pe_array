`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2021 10:10:42 AM
// Design Name: 
// Module Name: inst_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 0.5 BRAM
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module inst_rom(
    clk, en, iter, addr, data_out
    );

input clk;
input en;
input [7:0] iter;
input [7:0] addr; // 2^8 = 256 instructions
output [`INST_WIDTH*2-1:0] data_out;

//reg [`INST_WIDTH*2-1:0] data_out;
reg [`INST_WIDTH*2-1:0] rom_out;
//always @(posedge clk) begin
//    data_out <= rom_out; // Add one more pipeline for ROM output
//end

assign data_out = rom_out;

   always @(posedge clk)
      if (en)
         if (iter%2 == 0)
         case (addr) // Be careful about the sign bit and fixed-point values
            // Demo
//            8'b00000000: rom_out <= 32'h80_01_00_80; // CMPLX_MULT (opcode = 100)
//            8'b00000001: rom_out <= 32'h80_03_02_81; // CMPLX_MULT (opcode = 100)
//            8'b00000010: rom_out <= 32'h80_05_04_82; // CMPLX_MULT (opcode = 100)
            // 8-pt example
//            8'b00000000: rom_out <= 32'h80000040; // mul 
//            8'b00000001: rom_out <= 32'h80010141; // mul
//            8'b00000010: rom_out <= 32'h80020242; // mul
//            8'b00000011: rom_out <= 32'h80030343; // mul
//            8'b00000100: rom_out <= 32'h80040444; // mul
//            8'b00000101: rom_out <= 32'h80050545; // mul
//            8'b00000110: rom_out <= 32'h80060646; // mul
//            8'b00000111: rom_out <= 32'h80070747; // mul
//            8'b00001000: rom_out <= 32'hA0444048; // muladd
//            8'b00001001: rom_out <= 32'hC0444049; // mulsub
//            8'b00001010: rom_out <= 32'hA046424A;
//            8'b00001011: rom_out <= 32'hC046424B;
//            8'b00001100: rom_out <= 32'hA045414C;
//            8'b00001101: rom_out <= 32'hC045414D;
//            8'b00001110: rom_out <= 32'hA047434E;
//            8'b00001111: rom_out <= 32'hC047434F;
//            8'b00010000: rom_out <= 32'hA04A4850;
//            8'b00010001: rom_out <= 32'hC04A4852;
//            8'b00010010: rom_out <= 32'hA24B4951;
//            8'b00010011: rom_out <= 32'hC24B4953;
//            8'b00010100: rom_out <= 32'hA04E4C54;
//            8'b00010101: rom_out <= 32'hC04E4C56;
//            8'b00010110: rom_out <= 32'hA24F4D55;
//            8'b00010111: rom_out <= 32'hC24F4D57;
//            8'b00011000: rom_out <= 32'hA0545058;
//            8'b00011001: rom_out <= 32'hC054505C;
//            8'b00011010: rom_out <= 32'hA1565259;
//            8'b00011011: rom_out <= 32'hC156525D;
//            8'b00011100: rom_out <= 32'hA255515A;
//            8'b00011101: rom_out <= 32'hC255515E;
//            8'b00011110: rom_out <= 32'hA357535B;
//            8'b00011111: rom_out <= 32'hC357535F;
            // SCD Instructions
            // 32 element-wise complex multiplications (verified!)
            8'b00000000: rom_out <= 32'h80200040; // mul 
            8'b00000001: rom_out <= 32'h80210141; 
            8'b00000010: rom_out <= 32'h80220242; 
            8'b00000011: rom_out <= 32'h80230343; 
            8'b00000100: rom_out <= 32'h80240444; 
            8'b00000101: rom_out <= 32'h80250545; 
            8'b00000110: rom_out <= 32'h80260646; 
            8'b00000111: rom_out <= 32'h80270747; 
            8'b00001000: rom_out <= 32'h80280848; 
            8'b00001001: rom_out <= 32'h80290949; 
            8'b00001010: rom_out <= 32'h802A0A4A;
            8'b00001011: rom_out <= 32'h802B0B4B;
            8'b00001100: rom_out <= 32'h802C0C4C;
            8'b00001101: rom_out <= 32'h802D0D4D;
            8'b00001110: rom_out <= 32'h802E0E4E;
            8'b00001111: rom_out <= 32'h802F0F4F;
            8'b00010000: rom_out <= 32'h80301050;
            8'b00010001: rom_out <= 32'h80311151;
            8'b00010010: rom_out <= 32'h80321252;
            8'b00010011: rom_out <= 32'h80331353;
            8'b00010100: rom_out <= 32'h80341454;
            8'b00010101: rom_out <= 32'h80351555;
            8'b00010110: rom_out <= 32'h80361656;
            8'b00010111: rom_out <= 32'h80371757;
            8'b00011000: rom_out <= 32'h80381858;
            8'b00011001: rom_out <= 32'h80391959;
            8'b00011010: rom_out <= 32'h803A1A5A;
            8'b00011011: rom_out <= 32'h803B1B5B;
            8'b00011100: rom_out <= 32'h803C1C5C;
            8'b00011101: rom_out <= 32'h803D1D5D;
            8'b00011110: rom_out <= 32'h803E1E5E;
            8'b00011111: rom_out <= 32'h803F1F5F;
            // Stage-1 (verified!)
            8'b00100000: rom_out <= 32'hA0504060; // muladd
            8'b00100001: rom_out <= 32'hC0504061; // mulsub
            8'b00100010: rom_out <= 32'hA0584862;
            8'b00100011: rom_out <= 32'hC0584863;
            8'b00100100: rom_out <= 32'hA0544464;
            8'b00100101: rom_out <= 32'hC0544465;
            8'b00100110: rom_out <= 32'hA05C4C66;
            8'b00100111: rom_out <= 32'hC05C4C67;
            8'b00101000: rom_out <= 32'hA0524268;
            8'b00101001: rom_out <= 32'hC0524269;
            8'b00101010: rom_out <= 32'hA05A4A6A;
            8'b00101011: rom_out <= 32'hC05A4A6B;
            8'b00101100: rom_out <= 32'hA056466C;
            8'b00101101: rom_out <= 32'hC056466D;
            8'b00101110: rom_out <= 32'hA05E4E6E;
            8'b00101111: rom_out <= 32'hC05E4E6F;
            8'b00110000: rom_out <= 32'hA0514170;
            8'b00110001: rom_out <= 32'hC0514171;
            8'b00110010: rom_out <= 32'hA0594972;
            8'b00110011: rom_out <= 32'hC0594973;
            8'b00110100: rom_out <= 32'hA0554574;
            8'b00110101: rom_out <= 32'hC0554575;
            8'b00110110: rom_out <= 32'hA05D4D76;
            8'b00110111: rom_out <= 32'hC05D4D77;
            8'b00111000: rom_out <= 32'hA0534378;
            8'b00111001: rom_out <= 32'hC0534379;
            8'b00111010: rom_out <= 32'hA05B4B7A;
            8'b00111011: rom_out <= 32'hC05B4B7B;
            8'b00111100: rom_out <= 32'hA057477C;
            8'b00111101: rom_out <= 32'hC057477D;
            8'b00111110: rom_out <= 32'hA05F4F7E;
            8'b00111111: rom_out <= 32'hC05F4F7F;
            // Stage-2
            8'b01000000: rom_out <= 32'hA0626040; // muladd
            8'b01000001: rom_out <= 32'hC0626042; // mulsub
            8'b01000010: rom_out <= 32'hA8636141; 
            8'b01000011: rom_out <= 32'hC8636143;
            8'b01000100: rom_out <= 32'hA0666444;
            8'b01000101: rom_out <= 32'hC0666446;
            8'b01000110: rom_out <= 32'hA8676545;
            8'b01000111: rom_out <= 32'hC8676547;
            8'b01001000: rom_out <= 32'hA06A6848;
            8'b01001001: rom_out <= 32'hC06A684A;
            8'b01001010: rom_out <= 32'hA86B6949;
            8'b01001011: rom_out <= 32'hC86B694B;
            8'b01001100: rom_out <= 32'hA06E6C4C;
            8'b01001101: rom_out <= 32'hC06E6C4E;
            8'b01001110: rom_out <= 32'hA86F6D4D;
            8'b01001111: rom_out <= 32'hC86F6D4F;
            8'b01010000: rom_out <= 32'hA0727050;
            8'b01010001: rom_out <= 32'hC0727052;
            8'b01010010: rom_out <= 32'hA8737151;
            8'b01010011: rom_out <= 32'hC8737153;
            8'b01010100: rom_out <= 32'hA0767454;
            8'b01010101: rom_out <= 32'hC0767456;
            8'b01010110: rom_out <= 32'hA8777555;
            8'b01010111: rom_out <= 32'hC8777557;
            8'b01011000: rom_out <= 32'hA07A7858;
            8'b01011001: rom_out <= 32'hC07A785A;
            8'b01011010: rom_out <= 32'hA87B7959;
            8'b01011011: rom_out <= 32'hC87B795B;
            8'b01011100: rom_out <= 32'hA07E7C5C;
            8'b01011101: rom_out <= 32'hC07E7C5E;
            8'b01011110: rom_out <= 32'hA87F7D5D;
            8'b01011111: rom_out <= 32'hC87F7D5F;
            // Stage-3
            8'b01100000: rom_out <= 32'hA0444060; // muladd
            8'b01100001: rom_out <= 32'hC0444064; // mulsub
            8'b01100010: rom_out <= 32'hA4454161;
            8'b01100011: rom_out <= 32'hC4454165;
            8'b01100100: rom_out <= 32'hA8464262;
            8'b01100101: rom_out <= 32'hC8464266;
            8'b01100110: rom_out <= 32'hAC474363;
            8'b01100111: rom_out <= 32'hCC474367;
            8'b01101000: rom_out <= 32'hA04C4868;
            8'b01101001: rom_out <= 32'hC04C486C;
            8'b01101010: rom_out <= 32'hA44D4969;
            8'b01101011: rom_out <= 32'hC44D496D;
            8'b01101100: rom_out <= 32'hA84E4A6A;
            8'b01101101: rom_out <= 32'hC84E4A6E;
            8'b01101110: rom_out <= 32'hAC4F4B6B;
            8'b01101111: rom_out <= 32'hCC4F4B6F;
            8'b01110000: rom_out <= 32'hA0545070;
            8'b01110001: rom_out <= 32'hC0545074;
            8'b01110010: rom_out <= 32'hA4555171;
            8'b01110011: rom_out <= 32'hC4555175;
            8'b01110100: rom_out <= 32'hA8565272;
            8'b01110101: rom_out <= 32'hC8565276;
            8'b01110110: rom_out <= 32'hAC575373;
            8'b01110111: rom_out <= 32'hCC575377;
            8'b01111000: rom_out <= 32'hA05C5878;
            8'b01111001: rom_out <= 32'hC05C587C;
            8'b01111010: rom_out <= 32'hA45D5979;
            8'b01111011: rom_out <= 32'hC45D597D;
            8'b01111100: rom_out <= 32'hA85E5A7A;
            8'b01111101: rom_out <= 32'hC85E5A7E;
            8'b01111110: rom_out <= 32'hAC5F5B7B;
            8'b01111111: rom_out <= 32'hCC5F5B7F;
            // Stage-4
            8'b10000000: rom_out <= 32'hA0686040; // muladd
            8'b10000001: rom_out <= 32'hC0686048; // mulsub
            8'b10000010: rom_out <= 32'hA2696141; 
            8'b10000011: rom_out <= 32'hC2696149;
            8'b10000100: rom_out <= 32'hA46A6242;
            8'b10000101: rom_out <= 32'hC46A624A;
            8'b10000110: rom_out <= 32'hA66B6343;
            8'b10000111: rom_out <= 32'hC66B634B;
            8'b10001000: rom_out <= 32'hA86C6444;
            8'b10001001: rom_out <= 32'hC86C644C;
            8'b10001010: rom_out <= 32'hAA6D6545;
            8'b10001011: rom_out <= 32'hCA6D654D;
            8'b10001100: rom_out <= 32'hAC6E6646;
            8'b10001101: rom_out <= 32'hCC6E664E;
            8'b10001110: rom_out <= 32'hAE6F6747;
            8'b10001111: rom_out <= 32'hCE6F674F;
            8'b10010000: rom_out <= 32'hA0787050;
            8'b10010001: rom_out <= 32'hC0787058;
            8'b10010010: rom_out <= 32'hA2797151;
            8'b10010011: rom_out <= 32'hC2797159;
            8'b10010100: rom_out <= 32'hA47A7252;
            8'b10010101: rom_out <= 32'hC47A725A;
            8'b10010110: rom_out <= 32'hA67B7353;
            8'b10010111: rom_out <= 32'hC67B735B;
            8'b10011000: rom_out <= 32'hA87C7454;
            8'b10011001: rom_out <= 32'hC87C745C;
            8'b10011010: rom_out <= 32'hAA7D7555;
            8'b10011011: rom_out <= 32'hCA7D755D;
            8'b10011100: rom_out <= 32'hAC7E7656;
            8'b10011101: rom_out <= 32'hCC7E765E;
            8'b10011110: rom_out <= 32'hAE7F7757;
            8'b10011111: rom_out <= 32'hCE7F775F;
            // Stage-5 (FFT clock-wise shift first, then output the middle range!) 
//            8'b10100000: rom_out <= 32'hC0504088; // FFT_out: 16
//            8'b10100001: rom_out <= 32'hC1514189; // FFT_out: 17
//            8'b10100010: rom_out <= 32'hC252428A; // FFT_out: 18
//            8'b10100011: rom_out <= 32'hC353438B; // FFT_out: 19
//            8'b10100100: rom_out <= 32'hC454448C; // FFT_out: 20
//            8'b10100101: rom_out <= 32'hC555458D; // FFT_out: 21
//            8'b10100110: rom_out <= 32'hC656468E; // FFT_out: 22
//            8'b10100111: rom_out <= 32'hC757478F; // FFT_out: 23
//            8'b10101000: rom_out <= 32'hA8584880; // FFT_out: 8
//            8'b10101001: rom_out <= 32'hA9594981; // FFT_out: 9
//            8'b10101010: rom_out <= 32'hAA5A4A82; // FFT_out: 10
//            8'b10101011: rom_out <= 32'hAB5B4B83; // FFT_out: 11
//            8'b10101100: rom_out <= 32'hAC5C4C84; // FFT_out: 12
//            8'b10101101: rom_out <= 32'hAD5D4D85; // FFT_out: 13
//            8'b10101110: rom_out <= 32'hAE5E4E86; // FFT_out: 14
//            8'b10101111: rom_out <= 32'hAF5F4F87; // FFT_out: 15
            8'b10100000: rom_out <= 32'hC8584880; // FFT_out: 24
            8'b10100001: rom_out <= 32'hC9594981; // FFT_out: 25
            8'b10100010: rom_out <= 32'hCA5A4A82; // FFT_out: 26
            8'b10100011: rom_out <= 32'hCB5B4B83; // FFT_out: 27
            8'b10100100: rom_out <= 32'hCC5C4C84; // FFT_out: 28
            8'b10100101: rom_out <= 32'hCD5D4D85; // FFT_out: 29
            8'b10100110: rom_out <= 32'hCE5E4E86; // FFT_out: 30
            8'b10100111: rom_out <= 32'hCF5F4F87; // FFT_out: 31
            8'b10101000: rom_out <= 32'hA0504088; // FFT_out: 0
            8'b10101001: rom_out <= 32'hA1514189; // FFT_out: 1
            8'b10101010: rom_out <= 32'hA252428A; // FFT_out: 2
            8'b10101011: rom_out <= 32'hA353438B; // FFT_out: 3
            8'b10101100: rom_out <= 32'hA454448C; // FFT_out: 4
            8'b10101101: rom_out <= 32'hA555458D; // FFT_out: 5
            8'b10101110: rom_out <= 32'hA656468E; // FFT_out: 6
            8'b10101111: rom_out <= 32'hA757478F; // FFT_out: 7
            // MAX ((s3), s2, s1, d)  ith iteration 
            8'b10110000: rom_out <= 32'hE0_98_80_A8; // (i-1)th TOP Vs. ith BOTTOM
            8'b10110001: rom_out <= 32'hE0_99_81_A9; 
            8'b10110010: rom_out <= 32'hE0_9A_82_AA; 
            8'b10110011: rom_out <= 32'hE0_9B_83_AB;
            8'b10110100: rom_out <= 32'hE0_9C_84_AC;
            8'b10110101: rom_out <= 32'hE0_9D_85_AD;
            8'b10110110: rom_out <= 32'hE0_9E_86_AE;
            8'b10110111: rom_out <= 32'hE0_9F_87_AF;
            8'b10111000: rom_out <= 32'hE0_A0_A8_A8; // above results Vs. alpha[k-1]
            8'b10111001: rom_out <= 32'hE0_A1_A9_A9;
            8'b10111010: rom_out <= 32'hE0_A2_AA_AA;
            8'b10111011: rom_out <= 32'hE0_A3_AB_AB;
            8'b10111100: rom_out <= 32'hE0_A4_AC_AC;
            8'b10111101: rom_out <= 32'hE0_A5_AD_AD;
            8'b10111110: rom_out <= 32'hE0_A6_AE_AE;
            8'b10111111: rom_out <= 32'hE0_A7_AF_AF;
            // Null
            8'b11010000: rom_out <= 32'h0000_0000;
            8'b11010001: rom_out <= 32'h0000_0000;
            8'b11010010: rom_out <= 32'h0000_0000;
            8'b11010011: rom_out <= 32'h0000_0000;
            8'b11010100: rom_out <= 32'h0000_0000;
            8'b11010101: rom_out <= 32'h0000_0000;
            8'b11010110: rom_out <= 32'h0000_0000;
            8'b11010111: rom_out <= 32'h0000_0000;
            8'b11011000: rom_out <= 32'h0000_0000;
            8'b11011001: rom_out <= 32'h0000_0000;
            8'b11011010: rom_out <= 32'h0000_0000;
            8'b11011011: rom_out <= 32'h0000_0000;
            8'b11011100: rom_out <= 32'h0000_0000;
            8'b11011101: rom_out <= 32'h0000_0000;
            8'b11011110: rom_out <= 32'h0000_0000;
            8'b11011111: rom_out <= 32'h0000_0000;
            8'b11100000: rom_out <= 32'h0000_0000;
            8'b11100001: rom_out <= 32'h0000_0000;
            8'b11100010: rom_out <= 32'h0000_0000;
            8'b11100011: rom_out <= 32'h0000_0000;
            8'b11100100: rom_out <= 32'h0000_0000;
            8'b11100101: rom_out <= 32'h0000_0000;
            8'b11100110: rom_out <= 32'h0000_0000;
            8'b11100111: rom_out <= 32'h0000_0000;
            8'b11101000: rom_out <= 32'h0000_0000;
            8'b11101001: rom_out <= 32'h0000_0000;
            8'b11101010: rom_out <= 32'h0000_0000;
            8'b11101011: rom_out <= 32'h0000_0000;
            8'b11101100: rom_out <= 32'h0000_0000;
            8'b11101101: rom_out <= 32'h0000_0000;
            8'b11101110: rom_out <= 32'h0000_0000;
            8'b11101111: rom_out <= 32'h0000_0000;
            8'b11110000: rom_out <= 32'h0000_0000;
            8'b11110001: rom_out <= 32'h0000_0000;
            8'b11110010: rom_out <= 32'h0000_0000;
            8'b11110011: rom_out <= 32'h0000_0000;
            8'b11110100: rom_out <= 32'h0000_0000;
            8'b11110101: rom_out <= 32'h0000_0000;
            8'b11110110: rom_out <= 32'h0000_0000;
            8'b11110111: rom_out <= 32'h0000_0000;
            8'b11111000: rom_out <= 32'h0000_0000;
            8'b11111001: rom_out <= 32'h0000_0000;
            8'b11111010: rom_out <= 32'h0000_0000;
            8'b11111011: rom_out <= 32'h0000_0000;
            8'b11111100: rom_out <= 32'h0000_0000;
            8'b11111101: rom_out <= 32'h0000_0000;
            8'b11111110: rom_out <= 32'h0000_0000;
            8'b11111111: rom_out <= 32'h0000_0000;
            default: rom_out <= 32'h0000_0000;
         endcase
         
         else
         case (addr) 
            // SCD Instructions
            // 32 element-wise complex multiplications
            8'b00000000: rom_out <= 32'h80200040; // mul 
            8'b00000001: rom_out <= 32'h80210141; 
            8'b00000010: rom_out <= 32'h80220242; 
            8'b00000011: rom_out <= 32'h80230343; 
            8'b00000100: rom_out <= 32'h80240444; 
            8'b00000101: rom_out <= 32'h80250545; 
            8'b00000110: rom_out <= 32'h80260646; 
            8'b00000111: rom_out <= 32'h80270747; 
            8'b00001000: rom_out <= 32'h80280848; 
            8'b00001001: rom_out <= 32'h80290949; 
            8'b00001010: rom_out <= 32'h802A0A4A;
            8'b00001011: rom_out <= 32'h802B0B4B;
            8'b00001100: rom_out <= 32'h802C0C4C;
            8'b00001101: rom_out <= 32'h802D0D4D;
            8'b00001110: rom_out <= 32'h802E0E4E;
            8'b00001111: rom_out <= 32'h802F0F4F;
            8'b00010000: rom_out <= 32'h80301050;
            8'b00010001: rom_out <= 32'h80311151;
            8'b00010010: rom_out <= 32'h80321252;
            8'b00010011: rom_out <= 32'h80331353;
            8'b00010100: rom_out <= 32'h80341454;
            8'b00010101: rom_out <= 32'h80351555;
            8'b00010110: rom_out <= 32'h80361656;
            8'b00010111: rom_out <= 32'h80371757;
            8'b00011000: rom_out <= 32'h80381858;
            8'b00011001: rom_out <= 32'h80391959;
            8'b00011010: rom_out <= 32'h803A1A5A;
            8'b00011011: rom_out <= 32'h803B1B5B;
            8'b00011100: rom_out <= 32'h803C1C5C;
            8'b00011101: rom_out <= 32'h803D1D5D;
            8'b00011110: rom_out <= 32'h803E1E5E;
            8'b00011111: rom_out <= 32'h803F1F5F;
            // Stage-1
            8'b00100000: rom_out <= 32'hA0504060; // muladd
            8'b00100001: rom_out <= 32'hC0504061; // mulsub
            8'b00100010: rom_out <= 32'hA0584862;
            8'b00100011: rom_out <= 32'hC0584863;
            8'b00100100: rom_out <= 32'hA0544464;
            8'b00100101: rom_out <= 32'hC0544465;
            8'b00100110: rom_out <= 32'hA05C4C66;
            8'b00100111: rom_out <= 32'hC05C4C67;
            8'b00101000: rom_out <= 32'hA0524268;
            8'b00101001: rom_out <= 32'hC0524269;
            8'b00101010: rom_out <= 32'hA05A4A6A;
            8'b00101011: rom_out <= 32'hC05A4A6B;
            8'b00101100: rom_out <= 32'hA056466C;
            8'b00101101: rom_out <= 32'hC056466D;
            8'b00101110: rom_out <= 32'hA05E4E6E;
            8'b00101111: rom_out <= 32'hC05E4E6F;
            8'b00110000: rom_out <= 32'hA0514170;
            8'b00110001: rom_out <= 32'hC0514171;
            8'b00110010: rom_out <= 32'hA0594972;
            8'b00110011: rom_out <= 32'hC0594973;
            8'b00110100: rom_out <= 32'hA0554574;
            8'b00110101: rom_out <= 32'hC0554575;
            8'b00110110: rom_out <= 32'hA05D4D76;
            8'b00110111: rom_out <= 32'hC05D4D77;
            8'b00111000: rom_out <= 32'hA0534378;
            8'b00111001: rom_out <= 32'hC0534379;
            8'b00111010: rom_out <= 32'hA05B4B7A;
            8'b00111011: rom_out <= 32'hC05B4B7B;
            8'b00111100: rom_out <= 32'hA057477C;
            8'b00111101: rom_out <= 32'hC057477D;
            8'b00111110: rom_out <= 32'hA05F4F7E;
            8'b00111111: rom_out <= 32'hC05F4F7F;
            // Stage-2
            8'b01000000: rom_out <= 32'hA0626040; // muladd
            8'b01000001: rom_out <= 32'hC0626042; // mulsub
            8'b01000010: rom_out <= 32'hA8636141; 
            8'b01000011: rom_out <= 32'hC8636143;
            8'b01000100: rom_out <= 32'hA0666444;
            8'b01000101: rom_out <= 32'hC0666446;
            8'b01000110: rom_out <= 32'hA8676545;
            8'b01000111: rom_out <= 32'hC8676547;
            8'b01001000: rom_out <= 32'hA06A6848;
            8'b01001001: rom_out <= 32'hC06A684A;
            8'b01001010: rom_out <= 32'hA86B6949;
            8'b01001011: rom_out <= 32'hC86B694B;
            8'b01001100: rom_out <= 32'hA06E6C4C;
            8'b01001101: rom_out <= 32'hC06E6C4E;
            8'b01001110: rom_out <= 32'hA86F6D4D;
            8'b01001111: rom_out <= 32'hC86F6D4F;
            8'b01010000: rom_out <= 32'hA0727050;
            8'b01010001: rom_out <= 32'hC0727052;
            8'b01010010: rom_out <= 32'hA8737151;
            8'b01010011: rom_out <= 32'hC8737153;
            8'b01010100: rom_out <= 32'hA0767454;
            8'b01010101: rom_out <= 32'hC0767456;
            8'b01010110: rom_out <= 32'hA8777555;
            8'b01010111: rom_out <= 32'hC8777557;
            8'b01011000: rom_out <= 32'hA07A7858;
            8'b01011001: rom_out <= 32'hC07A785A;
            8'b01011010: rom_out <= 32'hA87B7959;
            8'b01011011: rom_out <= 32'hC87B795B;
            8'b01011100: rom_out <= 32'hA07E7C5C;
            8'b01011101: rom_out <= 32'hC07E7C5E;
            8'b01011110: rom_out <= 32'hA87F7D5D;
            8'b01011111: rom_out <= 32'hC87F7D5F;
            // Stage-3
            8'b01100000: rom_out <= 32'hA0444060; // muladd
            8'b01100001: rom_out <= 32'hC0444064; // mulsub
            8'b01100010: rom_out <= 32'hA4454161;
            8'b01100011: rom_out <= 32'hC4454165;
            8'b01100100: rom_out <= 32'hA8464262;
            8'b01100101: rom_out <= 32'hC8464266;
            8'b01100110: rom_out <= 32'hAC474363;
            8'b01100111: rom_out <= 32'hCC474367;
            8'b01101000: rom_out <= 32'hA04C4868;
            8'b01101001: rom_out <= 32'hC04C486C;
            8'b01101010: rom_out <= 32'hA44D4969;
            8'b01101011: rom_out <= 32'hC44D496D;
            8'b01101100: rom_out <= 32'hA84E4A6A;
            8'b01101101: rom_out <= 32'hC84E4A6E;
            8'b01101110: rom_out <= 32'hAC4F4B6B;
            8'b01101111: rom_out <= 32'hCC4F4B6F;
            8'b01110000: rom_out <= 32'hA0545070;
            8'b01110001: rom_out <= 32'hC0545074;
            8'b01110010: rom_out <= 32'hA4555171;
            8'b01110011: rom_out <= 32'hC4555175;
            8'b01110100: rom_out <= 32'hA8565272;
            8'b01110101: rom_out <= 32'hC8565276;
            8'b01110110: rom_out <= 32'hAC575373;
            8'b01110111: rom_out <= 32'hCC575377;
            8'b01111000: rom_out <= 32'hA05C5878;
            8'b01111001: rom_out <= 32'hC05C587C;
            8'b01111010: rom_out <= 32'hA45D5979;
            8'b01111011: rom_out <= 32'hC45D597D;
            8'b01111100: rom_out <= 32'hA85E5A7A;
            8'b01111101: rom_out <= 32'hC85E5A7E;
            8'b01111110: rom_out <= 32'hAC5F5B7B;
            8'b01111111: rom_out <= 32'hCC5F5B7F;
            // Stage-4
            8'b10000000: rom_out <= 32'hA0686040; // muladd
            8'b10000001: rom_out <= 32'hC0686048; // mulsub
            8'b10000010: rom_out <= 32'hA2696141; 
            8'b10000011: rom_out <= 32'hC2696149;
            8'b10000100: rom_out <= 32'hA46A6242;
            8'b10000101: rom_out <= 32'hC46A624A;
            8'b10000110: rom_out <= 32'hA66B6343;
            8'b10000111: rom_out <= 32'hC66B634B;
            8'b10001000: rom_out <= 32'hA86C6444;
            8'b10001001: rom_out <= 32'hC86C644C;
            8'b10001010: rom_out <= 32'hAA6D6545;
            8'b10001011: rom_out <= 32'hCA6D654D;
            8'b10001100: rom_out <= 32'hAC6E6646;
            8'b10001101: rom_out <= 32'hCC6E664E;
            8'b10001110: rom_out <= 32'hAE6F6747;
            8'b10001111: rom_out <= 32'hCE6F674F;
            8'b10010000: rom_out <= 32'hA0787050;
            8'b10010001: rom_out <= 32'hC0787058;
            8'b10010010: rom_out <= 32'hA2797151;
            8'b10010011: rom_out <= 32'hC2797159;
            8'b10010100: rom_out <= 32'hA47A7252;
            8'b10010101: rom_out <= 32'hC47A725A;
            8'b10010110: rom_out <= 32'hA67B7353;
            8'b10010111: rom_out <= 32'hC67B735B;
            8'b10011000: rom_out <= 32'hA87C7454;
            8'b10011001: rom_out <= 32'hC87C745C;
            8'b10011010: rom_out <= 32'hAA7D7555;
            8'b10011011: rom_out <= 32'hCA7D755D;
            8'b10011100: rom_out <= 32'hAC7E7656;
            8'b10011101: rom_out <= 32'hCC7E765E;
            8'b10011110: rom_out <= 32'hAE7F7757;
            8'b10011111: rom_out <= 32'hCE7F775F;
            // Stage-5 (FFT clock-wise shift first, then output the middle range!) 
            8'b10100000: rom_out <= 32'hC8584890; // FFT_out: 24
            8'b10100001: rom_out <= 32'hC9594991; // FFT_out: 25
            8'b10100010: rom_out <= 32'hCA5A4A92; // FFT_out: 26
            8'b10100011: rom_out <= 32'hCB5B4B93; // FFT_out: 27
            8'b10100100: rom_out <= 32'hCC5C4C94; // FFT_out: 28
            8'b10100101: rom_out <= 32'hCD5D4D95; // FFT_out: 29
            8'b10100110: rom_out <= 32'hCE5E4E96; // FFT_out: 30
            8'b10100111: rom_out <= 32'hCF5F4F97; // FFT_out: 31
            8'b10101000: rom_out <= 32'hA0504098; // FFT_out: 0
            8'b10101001: rom_out <= 32'hA1514199; // FFT_out: 1
            8'b10101010: rom_out <= 32'hA252429A; // FFT_out: 2
            8'b10101011: rom_out <= 32'hA353439B; // FFT_out: 3
            8'b10101100: rom_out <= 32'hA454449C; // FFT_out: 4
            8'b10101101: rom_out <= 32'hA555459D; // FFT_out: 5
            8'b10101110: rom_out <= 32'hA656469E; // FFT_out: 6
            8'b10101111: rom_out <= 32'hA757479F; // FFT_out: 7
            // MAX ((s3), s2, s1, d)  (i+1)th iteration 
            8'b10110000: rom_out <= 32'hE0_90_88_A8; // ith TOP Vs. (i+1)th BOTTOM
            8'b10110001: rom_out <= 32'hE0_91_89_A9; 
            8'b10110010: rom_out <= 32'hE0_92_8A_AA; 
            8'b10110011: rom_out <= 32'hE0_93_8B_AB;
            8'b10110100: rom_out <= 32'hE0_94_8C_AC;
            8'b10110101: rom_out <= 32'hE0_95_8D_AD;
            8'b10110110: rom_out <= 32'hE0_96_8E_AE;
            8'b10110111: rom_out <= 32'hE0_97_8F_AF;
            8'b10111000: rom_out <= 32'hE0_A0_A8_A8; // above results Vs. alpha[k-1]
            8'b10111001: rom_out <= 32'hE0_A1_A9_A9;
            8'b10111010: rom_out <= 32'hE0_A2_AA_AA;
            8'b10111011: rom_out <= 32'hE0_A3_AB_AB;
            8'b10111100: rom_out <= 32'hE0_A4_AC_AC;
            8'b10111101: rom_out <= 32'hE0_A5_AD_AD;
            8'b10111110: rom_out <= 32'hE0_A6_AE_AE;
            8'b10111111: rom_out <= 32'hE0_A7_AF_AF;            
            // Null
            8'b11010000: rom_out <= 32'h0000_0000;
            8'b11010001: rom_out <= 32'h0000_0000;
            8'b11010010: rom_out <= 32'h0000_0000;
            8'b11010011: rom_out <= 32'h0000_0000;
            8'b11010100: rom_out <= 32'h0000_0000;
            8'b11010101: rom_out <= 32'h0000_0000;
            8'b11010110: rom_out <= 32'h0000_0000;
            8'b11010111: rom_out <= 32'h0000_0000;
            8'b11011000: rom_out <= 32'h0000_0000;
            8'b11011001: rom_out <= 32'h0000_0000;
            8'b11011010: rom_out <= 32'h0000_0000;
            8'b11011011: rom_out <= 32'h0000_0000;
            8'b11011100: rom_out <= 32'h0000_0000;
            8'b11011101: rom_out <= 32'h0000_0000;
            8'b11011110: rom_out <= 32'h0000_0000;
            8'b11011111: rom_out <= 32'h0000_0000;
            8'b11100000: rom_out <= 32'h0000_0000;
            8'b11100001: rom_out <= 32'h0000_0000;
            8'b11100010: rom_out <= 32'h0000_0000;
            8'b11100011: rom_out <= 32'h0000_0000;
            8'b11100100: rom_out <= 32'h0000_0000;
            8'b11100101: rom_out <= 32'h0000_0000;
            8'b11100110: rom_out <= 32'h0000_0000;
            8'b11100111: rom_out <= 32'h0000_0000;
            8'b11101000: rom_out <= 32'h0000_0000;
            8'b11101001: rom_out <= 32'h0000_0000;
            8'b11101010: rom_out <= 32'h0000_0000;
            8'b11101011: rom_out <= 32'h0000_0000;
            8'b11101100: rom_out <= 32'h0000_0000;
            8'b11101101: rom_out <= 32'h0000_0000;
            8'b11101110: rom_out <= 32'h0000_0000;
            8'b11101111: rom_out <= 32'h0000_0000;
            8'b11110000: rom_out <= 32'h0000_0000;
            8'b11110001: rom_out <= 32'h0000_0000;
            8'b11110010: rom_out <= 32'h0000_0000;
            8'b11110011: rom_out <= 32'h0000_0000;
            8'b11110100: rom_out <= 32'h0000_0000;
            8'b11110101: rom_out <= 32'h0000_0000;
            8'b11110110: rom_out <= 32'h0000_0000;
            8'b11110111: rom_out <= 32'h0000_0000;
            8'b11111000: rom_out <= 32'h0000_0000;
            8'b11111001: rom_out <= 32'h0000_0000;
            8'b11111010: rom_out <= 32'h0000_0000;
            8'b11111011: rom_out <= 32'h0000_0000;
            8'b11111100: rom_out <= 32'h0000_0000;
            8'b11111101: rom_out <= 32'h0000_0000;
            8'b11111110: rom_out <= 32'h0000_0000;
            8'b11111111: rom_out <= 32'h0000_0000;
            default: rom_out <= 32'h0000_0000;
         endcase

endmodule
