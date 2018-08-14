`timescale 1ns / 1ps

module data_memory(
    input [7:0] addr,
    input D_rd,
    input D_wr,
    input [15:0] W_data,
    output reg [15:0] R_data
    );
    
    (* dont_touch = "true" *)reg [15:0] data_mem [0 : 255];
    
    initial begin
    data_mem[201] = 16'd5;
    data_mem[202] = 16'd20;
    data_mem[0] = 16'b1001011011001010; //LW 6 202
    data_mem[1] = 16'b0000011101010110; //Add 7 5 6
    data_mem[2] = 16'b1010011111001011; // SW A 7 203
    data_mem[3] = 16'b1000100011111010; // LI 8 250
    data_mem[4] = 16'b0001010010000101; //SUB 4 8 5
    data_mem[5] = 16'b1010010011001100; //SW 4 204
    data_mem[6] = 16'b0110001001110000; // SRA 3 7
    data_mem[7] = 16'b0100001000110100; //XOR 2 3 4
    data_mem[8] = 16'b1010001011001101; //SW 2 205
    end
    
    always@(posedge D_rd) begin
        R_data = data_mem[addr];
        $display("*MEM MESSAGE* Reading data from Memory Address [%d]!", addr);
    end
    
    always@(posedge D_wr) begin
        data_mem[addr] = W_data; 
        $display("*MEM MESSAGE* Writing Data to Memory Address [%d]!", addr);
    end
    
//    always@(D_rd or D_wr or W_data or R_data or addr) begin
//        $display("MEM Addr: %d", addr);
//        $display("MEM D_rd: %b", D_rd);
//        $display("MEM D_wr: %b", D_wr);
//        if (D_rd & ~D_wr) 
//            begin
//                R_data = data_mem[addr];
//                $display("MEM R_data: %d", R_data);
//            end
//        else if (D_wr & ~D_rd)
//            begin
//                data_mem[addr] = W_data;       
//            end
//        else begin
//                R_data = 16'h0000;
//            end
//    end    
endmodule
