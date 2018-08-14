`timescale 1ns / 1ps

module Memorypath(
    input D_addr_sel,
    input [7:0] PC_addr,
    input [7:0] D_addr,
    input D_rd,
    input D_wr,
    input [15:0] W_data,
    output [15:0] R_data
    );
    
    wire [7:0] MUX2MEM;
    
    MUX2x1 MP1(D_addr, PC_addr, D_addr_sel, MUX2MEM);
    data_memory MP2(MUX2MEM, D_rd, D_wr, W_data, R_data);
    
endmodule
