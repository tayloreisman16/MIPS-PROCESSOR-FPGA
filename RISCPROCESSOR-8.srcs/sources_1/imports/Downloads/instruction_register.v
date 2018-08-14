`timescale 1ns / 1ps

module instruction_register(
    input op_en,
    input [15:0] R_data,
    input [15:0] op_in,
    output [15:0] IR
    );
    
    
    assign IR = op_en? op_in : R_data;
    
    always @(IR) begin
            $display("*IR MESSAGE* Loading R_terminal into Controller: %b, OP_enable: %b, OP_in: %h", IR, op_en, op_in);
        end

        
endmodule

