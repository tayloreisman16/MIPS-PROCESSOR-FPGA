`timescale 1ns / 1ps

module MUX3x1(
    input RF_s1,
    input RF_s0,
    input [7:0] RF_W_data,
    input [15:0] R_data,
    input [15:0] ALU_data,
    output reg [15:0] W_data
    );
        
    always @(*) begin
        $display("*3x1 MUX* SELECTION: RF_s1 %b, RF_s0 %b", RF_s1, RF_s0);
        if (RF_s0 & ~RF_s1) begin
            W_data = R_data;
            $display("*3x1 MUX* OP: W_data = R_data, %d", W_data);
        end else if (~RF_s0 & ~RF_s1) begin
            W_data = ALU_data;
            $display("*3x1 MUX* OP: W_data = ALU_data, %d", W_data);
        end else if (RF_s1) begin
            W_data = RF_W_data;
            $display("*3x1 MUX* OP: W_data = RF_W_data, %d", W_data);
        end
            else begin
            W_data = 16'hzzzz;
            $display("*3x1 MUX* OP: Logical Error");
            end
    end
        
endmodule
