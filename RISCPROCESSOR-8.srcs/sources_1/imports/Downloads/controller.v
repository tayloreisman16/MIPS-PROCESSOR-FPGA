module Controller(
    input [15:0] IR,
    output reg IR_ld, PC_inc, D_addr_sel, D_rd, D_wr, RF_s1, RF_s0, W_wr, Rp_rd, Rq_rd, 
    output reg [2:0] alu_s,
    output reg [3:0] RF_W_addr, RF_Rp_addr, RF_Rq_addr,
    output reg [7:0] D_addr, RF_W_data,
    output reg [3:0]OP_Code);



always@(IR)
    begin
    OP_Code = IR[15:12];
    $display("*CONT MESSAGE* OPCODE: %h", IR[15:12]);   
        case(IR[15:12])
            //Arithmetic ALU Operations 
            //op___[Rd]_[Rs]_[Rt]
            0: begin        //ADD: Rd=Rs+Rt 
                $display("*CONT MESSAGE* ADD");
                
                //To Datapath: RF16x16
                RF_W_addr = IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr = IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr = IR[3:0];
                Rq_rd = 1'b1;
                
                //To Datapath: ALU
                alu_s = IR[14:12];
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0;
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1;
                
                //To Memorypath: Data_Memory
                D_rd = 1'b0;
                D_wr = 1'b0;
                
                //Internal to IR                
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1;      
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);  
            end
            1: begin        //SUB: Rd=Rs+Rt
                $display("*CONT MESSAGE* SUB");
                
                //To Datapath: RF16x16
                RF_W_addr=IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr=IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr=IR[3:0];
                Rq_rd = 1'b1;
                
                //To Datapath: ALU
                alu_s = IR[14:12];
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0;  
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1;
                
                //To Memorypath: Data_Memory
                D_rd = 1'b0;
                D_wr = 1'b0;
                
                //Internal to IR
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1;
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);
            end
            //Logical ALU Operations
            2: begin     //AND: Rd=Rs&Rt
                $display("*CONT MESSAGE* AND");
                
                //To Datapath: RF16x16
                RF_W_addr = IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr = IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr = IR[3:0];
                Rq_rd = 1'b1;
                
                //To Datapath: ALU
                alu_s = IR[14:12];
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0; 
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1;
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;
                        
                //Internal to IR
                IR_ld = 1'b0;
 
                //Internal to PC
                PC_inc = 1'b1;   
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc); 
            end
            3: begin        //OR: Rd=Rs|Rt
                $display("*CONT MESSAGE* OR");
               
                //To Datapath: RF16x16
                RF_W_addr=IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr=IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr=IR[3:0];
                Rq_rd = 1'b1;
                
                //To Datapath: ALU
                alu_s=IR[14:12];
                RF_s1 = 1'b0;
                RF_s0 = 1'b0;                
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0; 
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1;
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;
                        
                //Internal to IR
                IR_ld = 1'b0;
 
                //Internal to PC
                PC_inc = 1'b1;  
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);  
            end
            4: begin        //XOR: Rd=Rs^Rt
                $display("*CONT MESSAGE* XOR");
                
                //To Datapath: RF16x16
                RF_W_addr=IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr = IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr = IR[3:0];
                Rq_rd = 1'b1;
                
                //To Datapath: ALU
                alu_s=IR[14:12];
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0;
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1; 
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;                
                
                //Internal to IR
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1;    
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);
            end
            5: begin        //NOT: Rd=~Rs
                $display("*CONT MESSAGE* NOT");
                
                //To Datapath: RF16x16
                RF_W_addr=IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr=IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr = 4'b0000;
                Rq_rd = 1'b0;
                
                //To Datapath: ALU
                alu_s=IR[14:12];
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0;   
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1; 
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;          
                
                //Internal to IR  
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1;    
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);
            end
            6: begin        //SLA: Rd=Rs<<1
                $display("*CONT MESSAGE* SLA");
                
                //To Datapath: RF16x16
                RF_W_addr = IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr = IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr = 4'b0000;
                Rq_rd = 1'b0;
                
                //To Datapath: ALU
                alu_s=IR[14:12];
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0;   
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1; 
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;          
                
                //Internal to IR             
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc= 1'b1;    
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);
            end
            7: begin        //SRA: Rd=Rs>>1
                $display("*CONT MESSAGE* SRA");

                //To Datapath: RF16x16
                RF_W_addr = IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr = IR[7:4];
                Rp_rd = 1'b1;
                RF_Rq_addr = 4'b0000;
                Rq_rd = 1'b0;
                
                //To Datapath: ALU
                alu_s=IR[14:12];

                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b0;   
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1; 
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;          
                
                //Internal to IR   
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1;    
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);
                

            end
            //Memory Operations
            //0000_0000_0000_0000 
            //op___[Rd]_[Rs]_Sign_extend
            8: begin        //LI:
            $display("*CONT MESSAGE* LI"); 
                
                //To Datapath: RF16x16
                RF_W_addr = IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr = 4'b0000;
                Rp_rd = 1'b0;
                RF_Rq_addr = 4'b0000;
                Rq_rd = 1'b0;
                                
                //To Datapath: ALU
                alu_s= 3'b111;
                
                //To Datapath: 3x1 MUX
                RF_W_data=IR[7:0];
                RF_s1 = 1'b1;
                RF_s0 = 1'b0;
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1; 
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;   
                
                //Internal to IR  
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1; 
                
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);
            end
            9: begin        //LW: Rd=Mem[Dir]
                $display("*CONT MESSAGE* LW");
                
                //To Datapath: RF16x16
                RF_W_addr = IR[11:8];
                W_wr = 1'b1;
                RF_Rp_addr = 4'b0000;
                Rp_rd = 1'b0;
                RF_Rq_addr = 4'b0000;
                Rq_rd = 1'b0;
                
                //To Datapath: ALU
                alu_s= 3'b111;
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1; 
                
                $display("*CONT MESSAGE* D_addr: %d", D_addr);

                //To Memorypath: Data_Memory        
                D_rd = 1'b1;
                D_wr = 1'b0; 
                  
                //To Datapath: 3x1 MUX
                RF_W_data = IR[7:0];
                RF_s1 = 1'b1;
                RF_s0 = 1'b0;
                
                //Internal to IR  
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1;    
                $display("*CONT MESSAGE* D_addr_sel: %b, D_rd: %b, RF_s1: %b, RF_s0: %b, IR_ld: %b, PC_inc: %b, W_wr: %b, RF_W_addr: %d", D_addr_sel, D_rd, RF_s1, RF_s0, IR_ld, PC_inc, W_wr, RF_W_addr);

            end
            10: begin    //SW: Mem[Dir]=Rt
                $display("*CONT MESSAGE* SW");
                
                //To Datapath: RF16x16
                RF_W_addr = 4'b0000;
                W_wr = 1'b0;
                RF_Rp_addr = IR[11:8];
                Rp_rd = 1'b1;
                RF_Rq_addr = 4'b0000;
                Rq_rd = 1'b0;
                
                //To Datapath: ALU
                alu_s= 3'b111;
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b1; 
                
                $display("*CONT MESSAGE* D_addr: %d", D_addr);
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b1;
                
                //To Datapath: 3x1 MUX
                RF_W_data = IR[7:0];
                RF_s1 = 1'b1;
                RF_s0 = 1'b0;
                
                //Internal to IR 
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b1; 
                
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);

            end
            default: begin
                $display("*CONT MESSAGE* OOR!");
                
                //To Datapath: RF16x16
                RF_W_addr = 4'b0000;
                W_wr = 1'b0;
                RF_Rp_addr = 4'b0000;
                Rp_rd = 1'b0;
                RF_Rq_addr = 4'b0000;
                Rq_rd = 1'b0;
                
                //To Datapath: ALU
                alu_s= 3'b000;
                
                //To Memorypath: 2x1 MUX
                D_addr = IR[7:0];
                D_addr_sel = 1'b0; 
                
                $display("*CONT MESSAGE* D_addr: %d", D_addr);
                
                //To Memorypath: Data_Memory        
                D_rd = 1'b0;
                D_wr = 1'b0;
                
                //To Datapath: 3x1 MUX
                RF_W_data = 8'h00;
                RF_s1 = 1'b0;
                RF_s0 = 1'b1;
                
                //Internal to IR 
                IR_ld = 1'b0;
                
                //Internal to PC
                PC_inc = 1'b0; 
                $display("*CONT MESSAGE* RF_W_data: %b, RF_s1: %b, RF_s0: %b, RF_W_addr: %b, W_wr: %b, IR_ld: %b, PC_inc: %b", RF_W_data, RF_s1, RF_s0, RF_W_addr, W_wr, IR_ld, PC_inc);
            end
            endcase//opcode             
        end//always
    endmodule
    