`timescale 1ns / 1ps

module ALU(A,B,alu_s,C);
    input [15:0]A;
    input [15:0]B;
    input [2:0]alu_s;
    output reg [15:0]C;

    always@(*)
        begin
        $display("*ALU MESSAGE* A: %b", A);
        $display("*ALU MESSAGE* B: %b", B);
            if (alu_s == 3'd0)
                begin
                $display("*ALU MESSAGE* ADD");
                C = A+B;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else if (alu_s == 3'd1) begin
                $display("*ALU MESSAGE* SUB");
                C = A-B;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else if (alu_s == 3'd2) begin
                $display("*ALU MESSAGE* AND");
                C = A&B;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else if (alu_s == 3'd3) begin
                $display("*ALU MESSAGE* OR");
                C = A|B;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else if (alu_s == 3'd4) begin
                $display("*ALU MESSAGE* XOR");
                C = A^B;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else if (alu_s == 3'd5) begin
                $display("*ALU MESSAGE* NOT");
                C = ~A;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else if (alu_s == 3'd6) begin
                $display("*ALU MESSAGE* SLA");
                C = A<<1;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else if (alu_s == 3'd7) begin
                $display("*ALU MESSAGE* SRA");
                C = A>>1;
                $display("*ALU MESSAGE* C: %b", C);
                end
            else begin
                $display("*ALU MESSAGE* ZERO");
                C=0;
                $display("*ALU MESSAGE* C: %b", C);
             end
        end
endmodule