`timescale 1ns / 1ps

module MUX2x1(
    input [7:0] D_addr,
    input [7:0] PC_addr,
    input D_addr_sel,
    output [7:0] addr
    );
        always@(*) begin
            $display("*2x1 MUX* OP: D_addr_sel: %d, D_addr: %d, PC_addr: %d, ", D_addr_sel, D_addr, PC_addr);
        end
        
        assign addr = D_addr_sel? D_addr : PC_addr;
        
endmodule
