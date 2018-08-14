`timescale 1ns / 1ps

module program_counter(
    input wire PC_inc,
    input wire [7:0] IR,
    output reg [7:0] PC_addr
    );   

    always @(posedge PC_inc) begin
            PC_addr = IR + 16'd1; 
            $display("*PC MESSAGE* PC Address = [%h]", PC_addr);   
    end

endmodule
