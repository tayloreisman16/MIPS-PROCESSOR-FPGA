`timescale 1ns / 1ps

module RF16x16(
    input [3:0] W_addr,
    input W_wr,
    input alu_done,
    input [3:0] Rp_addr,
    input Rp_rd,
    input [3:0] Rq_addr,
    input Rq_rd,
    input [15:0] W_data,
    output reg [15:0] Rp_data,
    output reg Rp_ready,
    output reg [15:0] Rq_data
    );
    
    reg [15:0] mem [0:15];
    
    initial begin
        mem[0] = 16'h0000;
        mem[1] = 16'h0000;
        mem[2] = 16'h0000;
        mem[3] = 16'h0000;
        mem[4] = 16'h0000;
        mem[5] = 16'h0000;
        mem[6] = 16'h0000;
        mem[7] = 16'h0000;
        mem[8] = 16'h0000;
        mem[9] = 16'h0000;
        mem[10] = 16'h0000;
        mem[11] = 16'h0000;
        mem[12] = 16'h0000;
        mem[13] = 16'h0000;
        mem[14] = 16'h0000;
        mem[15] = 16'h0000;
        Rp_data = 16'h0000;
        Rq_data = 16'h0000;
        Rp_ready = 1'b0;
    end

    always@(posedge W_wr or W_data or alu_done) begin
        if(W_wr) begin
            $display("*RF MESSAGE* Writing [%d] to register [%d]!", W_data, W_addr);
            mem[W_addr] = W_data;
        end
    end
    
    always@(posedge Rp_rd or Rp_addr) begin
        if (Rp_rd) begin
            Rp_data = mem[Rp_addr];
            $display("*RF MESSAGE* Reading [%d] from register [%d] to Rp!", Rp_data, Rp_addr);
            Rp_ready = 1'b1;
        end else begin
            Rp_ready = 1'b0;
            Rp_data = Rp_data;
        end
    end
        
    always@(posedge Rq_rd) begin
        Rq_data = mem[Rq_addr];
        $display("*RF MESSAGE* Reading [%d] from register [%d] to Rq!", Rq_data, Rq_addr);
    end
    
//    always @(W_wr or Rp_rd or Rq_rd or W_data or W_addr or Rp_addr or Rq_addr) begin
//        $display("RF16x16 W_wr: %b", W_wr);
//        $display("RF16x16 Rp_rd: %b", Rp_rd);
//        $display("RF16x16 Rq_rd: %b", Rq_rd);
//        $display("RF16x16 W_addr: %d", W_addr);
//        if (W_wr & ~Rp_rd & ~Rq_rd) //100
//                mem[W_addr] = W_data;
//        else if (~W_wr & Rp_rd & ~Rq_rd) //010
//                Rp_data = mem[Rp_addr];
//        else if (~W_wr & ~Rp_rd & Rq_rd) //001
//                Rq_data = mem[Rq_addr];    
//        else if (W_wr & Rp_rd & Rq_rd) begin //111
//            mem[W_addr] = W_data;
//            Rp_data = mem[Rp_addr];
//            Rq_data = mem[Rq_addr]; 
//        end else if (W_wr & Rp_rd & ~Rq_rd) begin //110
//            mem[W_addr] = W_data;
//            Rp_data = mem[Rp_addr];
//        end else if (~W_wr & Rp_rd & Rq_rd) begin //011
//            Rp_data = mem[Rp_addr];
//            Rq_data = mem[Rq_addr];
//        end else if (W_wr & ~Rp_rd & Rq_rd) begin //101
//            mem[W_addr] = W_data;
//            Rq_data = mem[Rq_addr];
//        end else if (~W_wr & ~Rp_rd & ~Rq_rd) begin //000
//            Rp_data = Rp_data;
//            Rq_data = Rq_data;
//        end else begin
//            $display("Operational error in Memory!");
//            Rp_data = 16'hzzzz;
//            Rq_data = 16'hzzzz;
//        end
//    end
endmodule
