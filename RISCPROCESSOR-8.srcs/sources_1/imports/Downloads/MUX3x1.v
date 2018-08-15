`timescale 1ns / 1ps

module MUX3x1(
    input RF_s1,
    input RF_s0,
    input [7:0] RF_W_data,
    input [15:0] R_data,
    input [15:0] ALU_data,
    output [15:0] W_data
    );
    
    wire [1:0] RF_s;
    
    
    assign RF_s = {RF_s1, RF_s0};
        
        
    assign W_data = RF_s[1]? (RF_s[0] ? 16'hzzzz : RF_W_data) : (RF_s[0] ? R_data : ALU_data);
    
    always @(*) begin
        $display("*3x1 MUX* SELECTION: RF_s1 %b, RF_s0 %b", RF_s1, RF_s0);
        if (RF_s0 & ~RF_s1) begin
            $display("*3x1 MUX* OP: W_data = R_data, %d = %d", W_data, R_data);
        end else if (~RF_s0 & ~RF_s1) begin
            $display("*3x1 MUX* OP: W_data = ALU_data, %d = %d", W_data, ALU_data);
        end else if (RF_s1) begin
            $display("*3x1 MUX* OP: W_data = RF_W_data, %d = %d", W_data, RF_W_data);
        end else begin
            $display("*3x1 MUX* OP: Logical Error");
        end
    end
        
endmodule
