`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2018 10:38:16 AM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input [15:0] R_terminal,
    input term_en,
    input [15:0] R_data,
    output [7:0] PC_addr,
    output [7:0] D_addr,
    output D_rd,
    output D_wr,
    output D_addr_sel,
    output [7:0] RF_W_data,
    output RF_s1,
    output RF_s0,
    output [3:0] RF_W_addr,
    output W_wr,
    output [3:0] RF_Rp_addr,
    output Rp_rd,
    output [3:0] RF_Rq_addr,
    output Rq_rd,
    output [2:0] alu_s,
    output [3:0] OP_Code
    );
    
    wire [15:0] IR;
    wire IR_ld;
    wire PC_ld;
    wire PC_clr;
    wire PC_inc;
    

    Controller CU1(IR, IR_ld, PC_inc, D_addr_sel, D_rd, D_wr, RF_s1, RF_s0, W_wr, Rp_rd, Rq_rd, alu_s, RF_W_addr, RF_Rp_addr, RF_Rq_addr, D_addr, RF_W_data, OP_Code);
    program_counter CU2(PC_inc, IR[7:0], PC_addr);
    instruction_register CU3(term_en, R_data, R_terminal, IR);
    
endmodule

