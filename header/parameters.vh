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
`define PE_NUM          4 // 256 
`define PE_ADDR_WIDTH   8 // 2^8 = 256
`define REG_NUM         32 
`define REG_ADDR_WIDTH  5 // 2^5 = 32