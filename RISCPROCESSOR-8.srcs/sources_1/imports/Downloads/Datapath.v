`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2018 10:51:46 AM
// Design Name: 
// Module Name: Datapath
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


module Datapath(
    input [15:0] R_data,
    input [7:0] RF_W_data,
    input RF_s1,
    input twittRF_s0,
    input [3:0] RF_W_addr,
    input W_wr,
    input [3:0] RF_Rp_addr,
    input Rp_rd,
    input [3:0] RF_Rq_addr,
    input Rq_rd,
    input [2:0] alu_s,
    output [15:0] W_data
    );
    
    wire [15:0] ALU_out;
    wire [15:0] MUX2RF;
    wire [15:0] Rq_data;
    wire [15:0] Rp_data;
    
    assign W_data = Rp_data;
    
    MUX3x1 DP1(RF_s1, RF_s0, RF_W_data, R_data, ALU_out, MUX2RF);
    RF16x16 DP2(RF_W_addr, W_wr, RF_Rp_addr, Rp_rd, RF_Rq_addr, Rq_rd, MUX2RF, Rp_data, Rq_data);
    ALU DP3(Rp_data, Rq_data, alu_s, ALU_out);
    
    
endmodule
