`timescale 1ns / 1ps

module Memorypath(
    input D_addr_sel,
    input [7:0] PC_addr,
    input [7:0] D_addr,
    input D_rd,
    input D_wr,
    input [15:0] W_data,
    input Rp_ready,
    output wire [15:0] R_data,
    output wire [15:0] data_out_201, data_out_202, data_out_203
    );
    
    wire [7:0] MUX2MEM;
    
    MUX2x1 MP1(D_addr, PC_addr, D_addr_sel, MUX2MEM);
    data_memory MP2(MUX2MEM, D_rd, D_wr, W_data, Rp_ready, R_data, data_out_201, data_out_202, data_out_203);
    
endmodule
