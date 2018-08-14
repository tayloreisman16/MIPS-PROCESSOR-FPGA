`timescale 1ns / 1ps

module tb_controller;
    reg [15:0] R_terminal, R_data;
    reg term_en; 
    wire D_rd, D_wr, D_addr_sel, RF_s1, RF_s0, W_wr, Rp_rd, Rq_rd;
    wire [7:0] PC_addr, D_addr, RF_W_data;
    wire [3:0] RF_W_addr, RF_Rp_addr, RF_Rq_addr, OP_Code;
    wire [2:0] alu_s;
    
    Control_Unit TBC1(R_terminal,
        term_en,
        R_data,
        PC_addr,
        D_addr,
        D_rd,
        D_wr,
        D_addr_sel,
        RF_W_data,
        RF_s1,
        RF_s0,
        RF_W_addr,
        W_wr,
        RF_Rp_addr,
        Rp_rd,
        RF_Rq_addr,
        Rq_rd,
        alu_s,
        OP_Code);
        
        initial begin
            term_en = 1'b0;
        end
        
        always begin
            #50;
            term_en = 1'b1;
            #50;
            R_terminal = 16'b1001011011001010; //LW 6 202
            term_en = 1'b1;
            #50;
            R_terminal = 16'b0000011101010110; //Add 7 5 6
            term_en = 1'b1;
            #50;
            R_terminal = 16'b1010011111001011; // SW A 7 203
            term_en = 1'b1;
            #50;
            R_terminal = 16'b1000100011111010; // LI 8 250
            term_en = 1'b1;
            #50;
            R_terminal = 16'b0001010010000101; //SUB 4 8 5
            term_en = 1'b1;
            #50;
            R_terminal = 16'b1010010011001100; //SW 4 204
            term_en = 1'b1;
            #50;
            R_terminal = 16'b0110001001110000; // SRA 3 7
            term_en = 1'b1;
            #50;
            R_terminal = 16'b0100001000110100; //XOR 2 3 4
            term_en = 1'b1;
            #50;
            R_terminal = 16'b1010001011001101; //SW 2 205
            term_en = 1'b1;
        end
        
        
endmodule
