// Data & Instructions
`define DATA_WIDTH     16
`define INST_WIDTH     32

// DSP48E2
`define PORTA_WIDTH    30
`define PORTB_WIDTH    18
`define PORTC_WIDTH    48
`define PORTP_WIDTH    48
`define ALUMODE_WIDTH   4
`define INMODE_WIDTH    5
`define OPMODE_WIDTH    7   

// Memories
`define DM_ADDR_WIDTH   8
`define IM_ADDR_WIDTH   8
`define WN_ADDR_WIDTH   4

// Top PE
`define PE_NUM          4 // 128 
`define PE_ADDR_WIDTH   7 // 2^7 = 128
`define REG_NUM         8 // 32 
`define REG_ADDR_WIDTH  5 // 2^5 = 32
`define LOAD_NUM        8 // 32 
`define INST_NUM        32 // 224 
`define ITER_NUM        4 // 256 
`define TX_NUM          8
`define ALPHA_NUM       3 // 8