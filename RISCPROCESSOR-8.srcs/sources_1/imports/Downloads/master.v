`timescale 1ns / 1ps

module master(
    input clk, 
    input [15:0] op_in, //same as SW 
    input op_en, 
    input [4:1]btn, //btn[1]=continue ,btn[2]=reset ,btn[3]=back to State1/load,btn[4]=display
//    input [15:0]SW,
    output [15:0] W_data,
    output [3:0] OP_Code,
    output reg [7:0]SSEG_CA,
    output reg [7:0]SSEG_AN,
    output reg [15:0]LED,
	 output reg [3:0]State		//temp
);
    (* dont_touch = "true" *)wire [15:0] DATA2MEM;
    //(* dont_touch = "true" *)reg [3:0]State; //for multiplexing
    (* dont_touch = "true" *)reg [3:0]State1, State3, State4, State5, State6;
    (* dont_touch = "true" *)reg Clk_Slow;   //name of clk for SSEG
    (* dont_touch = "true" *)reg Clk_count;  //name of clk for buttons
    (* dont_touch = "true" *)reg [2:0]counter;
    (* dont_touch = "true" *)reg [31:0] counter_out, counter_out1; //used to slow clks down
    (* dont_touch = "true" *)reg [31:0] counter4, counter5, counter6;
    (* dont_touch = "true" *)reg [15:0]in;
    
    //Control Unit Wires
    (* dont_touch = "true" *)wire [7:0] PC_addr;
    (* dont_touch = "true" *)wire [7:0] D_addr;
    (* dont_touch = "true" *)wire D_rd;
    (* dont_touch = "true" *)wire D_wr;
    (* dont_touch = "true" *)wire D_addr_sel;
    (* dont_touch = "true" *)wire [7:0] RF_W_data;
    (* dont_touch = "true" *)wire RF_s1;
    (* dont_touch = "true" *)wire RF_s0;
    (* dont_touch = "true" *)wire [3:0] RF_W_addr;
    (* dont_touch = "true" *)wire W_wr;
    (* dont_touch = "true" *)wire [3:0] RF_Rp_addr;
    (* dont_touch = "true" *)wire [3:0] RF_Rq_addr;
    (* dont_touch = "true" *)wire Rp_rd;
    (* dont_touch = "true" *)wire Rq_rd;
    (* dont_touch = "true" *)wire [2:0] alu_s;
    (* dont_touch = "true" *)reg [15:0] R_terminal;
    (* dont_touch = "true" *)reg term_en;
    
    //Datapath & Mempath Wires
//    (* dont_touch = "true" *)wire [15:0] W_data;
    (* dont_touch = "true" *)wire [15:0] R_data;
    
//    assign RF_W_data = {{8{RF_W_data[7]}}, RF_W_data};
    assign DATA2MEM = W_data;
    
    always @(*) begin
        //R_terminal = op_in;
        term_en = op_en;
        end
 
initial 
    begin
        State=0;
		  State1=0;
		  State3=0;
		  State4=0;
		  State5=0;
		  State6=0;
		  counter_out<= 32'h00000000;
        counter_out1<= 32'h00000000;
        counter4<=0;
        counter5<=0;
        counter6<=0;
        Clk_Slow <=0;
        Clk_count <=0;
        counter<=0;
    end 
    
always @(posedge clk) 
begin
    counter_out<= counter_out + 32'h00000001;
    if (counter_out  > 32'd100000) 
    begin
        counter_out<= 32'h00000000;
        Clk_Slow <= !Clk_Slow;
    end
    
    counter_out1<= counter_out1 + 32'h00000001;
        if (counter_out1  > 32'd50000000) 
        begin
            counter_out1<= 32'h00000000;
            Clk_count <= !Clk_count;
        end
end//always  

always@(posedge Clk_count)
begin 
    case(State)
        0:begin         //Start
        if(btn[1])
            State=1;
        else
            State=0;
        end
        1:begin         //input IR
        if(btn[2])
            State=0;
         else if(btn[1])
            State=2;
         else
            State=1;
        end
        2:begin
            State=3;    //Set IR
        end  
        3:begin         //Display IR
        if(btn[2])
            State=0;
         else if(btn[3])
            State=1;
         else if(btn[4])
            State=4;
         else
            State=3;
        end
        4:begin
        if(btn[2])
            State=0;
        else if(btn[3])
            State=1;
        else if(counter4>1000)
            State=5;
        else 
            State=4;
        end
        5:begin
        if(btn[2])
            State=0;
        else if(btn[3])
            State=1;
        else if(counter5>1000)
            State=6;
        else 
            State=5;
        end
        6:begin
        if(btn[2])
            State=0;
        else if(btn[3])
            State=1;
        else if(counter6>1000)
            State=4;
        else 
            State=6;
        end
    endcase
end//always Clk_count



always@(posedge Clk_Slow)
begin
    case(State)
    0: begin //Reset/Initial State
        SSEG_AN=8'b00000000;
        SSEG_CA <= 8'b11000000; //0
//        temp_a<=0;
//        temp_b<=0;
//        Output<=0;
        State1<=0;
        State3<=0;
//        State4<=0;
        counter4<=0;
        counter5<=0;
        counter6<=0;
    end
/////////////////////////////////////
    1: begin
        LED=op_in;
        case(State1)
        0: State1=1;
        1: State1=2;
        2: State1=3;
        3: State1=0;
        endcase//state1
        
        case(State1)
        0:begin
            SSEG_AN=8'b11110111;
            SSEG_CA <= 8'b11001111; //l
        end
        1:begin
            SSEG_AN=8'b11111011;
            SSEG_CA <= 8'b10100011; //o
        end
        2:begin
            SSEG_AN=8'b11111101;
            SSEG_CA <= 8'b10001000; //A
        end
        3:begin
            SSEG_AN=8'b11111110;
            SSEG_CA <= 8'b10100001; //d
        end
        endcase
    end//case1
////////////////////////////////////////////    
    2:begin
	 R_terminal = op_in;
	 //in=op_in;
    LED=0;
    end
////////////////////////////////////////////    
    3: begin  
    case(State3)
        0: State3=1;
        1: State3=2;
        2: State3=3;
        3: State3=0;
    endcase//state3
    case(State3)
    0: begin
    SSEG_AN=8'b11110111;
    case (R_terminal[15:12]) 
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case0
    1: begin
    SSEG_AN=8'b11111011;
    case (R_terminal[11:8]) 
        4'b0000 : SSEG_CA <= 8'b11000000; //0    
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case1
    2: begin
    SSEG_AN=8'b11111101;
    case (R_terminal[7:4]) 
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F
    endcase
    end//case2
    3: begin
    SSEG_AN=8'b11111110;
    case (R_terminal[3:0]) 
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F      
    endcase
    end//case3  
    endcase//case(State3)
    end//case3
////////////////////////////////////////////   
    4: begin  
    counter4=counter4+1;
    counter6=0;
    case(State4)
        0: State4=1;
        1: State4=2;
        2: State4=3;
        3: State4=4;
        4: State4=5;
        5: State4=6;
        6: State4=0;
    endcase//state4
    case(State4)
    0:begin
        SSEG_AN=8'b01111111;
        SSEG_CA = 8'b10100100; //2
    end
    1:begin
        SSEG_AN=8'b10111111;
        SSEG_CA = 8'b11000000; //0
    end
    2:begin
        SSEG_AN=8'b11011111;
        SSEG_CA = 8'b10110000; //3
    end
    3: begin
    SSEG_AN=8'b11110111;
    case (in[15:12]) //change to output[15:12] from reg 203
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case3
    4: begin
    SSEG_AN=8'b11111011;
    case (in[11:8]) //change to output[11:8] from reg 203
        4'b0000 : SSEG_CA <= 8'b11000000; //0    
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case4
    5: begin
    SSEG_AN=8'b11111101;
    case (in[7:4]) //change to output[7:4] from reg 203
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F
    endcase
    end//case5
    6: begin
    SSEG_AN=8'b11111110;
    case (in[3:0]) //change to output[3:0] from reg 203
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F      
    endcase
    end//case6  
    endcase//case(State4)
    end//case4
////////////////////////////////////////////
    5: begin  
    counter5=counter5+1;
    counter4=0;
    case(State5)
        0: State5=1;
        1: State5=2;
        2: State5=3;
        3: State5=4;
        4: State5=5;
        5: State5=6;
        6: State5=0;
    endcase//state5
    case(State5)
    0:begin
        SSEG_AN=8'b01111111;
        SSEG_CA = 8'b10100100; //2
    end
    1:begin
        SSEG_AN=8'b10111111;
        SSEG_CA = 8'b11000000; //0
    end
    2:begin
        SSEG_AN=8'b11011111;
        SSEG_CA = 8'b10011001; //4
    end
    3: begin
    SSEG_AN=8'b11110111;
    case (in[15:12]) //change to output[15:12] from reg 204
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case3
    4: begin
    SSEG_AN=8'b11111011;
    case (in[11:8]) //change to output[11:8] from reg 204
        4'b0000 : SSEG_CA <= 8'b11000000; //0    
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case4
    5: begin
    SSEG_AN=8'b11111101;
    case (in[7:4]) //change to output[7:4] from reg 204
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F
    endcase
    end//case5
    6: begin
    SSEG_AN=8'b11111110;
    case (in[3:0]) //change to output[3:0] from reg 204
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F      
    endcase
    end//case6  
    endcase//case(State5)
    end//case5
////////////////////////////////////////////
    6: begin  
    counter6=counter6+1;
    counter5=0;
    case(State6)
        0: State6=1;
        1: State6=2;
        2: State6=3;
        3: State6=4;
        4: State6=5;
        5: State6=6;
        6: State6=0;
    endcase//state6
    case(State6)
    0:begin
        SSEG_AN=8'b01111111;
        SSEG_CA = 8'b10100100; //2
    end
    1:begin
        SSEG_AN=8'b10111111;
        SSEG_CA = 8'b11000000; //0
    end
    2:begin
        SSEG_AN=8'b11011111;
        SSEG_CA = 8'b10010010; //5
    end
    3: begin
    SSEG_AN=8'b11110111;
    case (in[15:12]) //change to output[15:12] from reg 205
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case3
    4: begin
    SSEG_AN=8'b11111011;
    case (in[11:8]) //change to output[11:8] from reg 205
        4'b0000 : SSEG_CA <= 8'b11000000; //0    
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F       
    endcase
    end//case4
    5: begin
    SSEG_AN=8'b11111101;
    case (in[7:4]) //change to output[7:4] from reg 205
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F
    endcase
    end//case5
    6: begin
    SSEG_AN=8'b11111110;
    case (in[3:0]) //change to output[3:0] from reg 205
        4'b0000 : SSEG_CA <= 8'b11000000; //0
        4'b0001 : SSEG_CA <= 8'b11111001; //1
        4'b0010 : SSEG_CA <= 8'b10100100; //2
        4'b0011 : SSEG_CA <= 8'b10110000; //3
        4'b0100 : SSEG_CA <= 8'b10011001; //4
        4'b0101 : SSEG_CA <= 8'b10010010; //5
        4'b0110 : SSEG_CA <= 8'b10000011; //6
        4'b0111 : SSEG_CA <= 8'b11111000; //7
        4'b1000 : SSEG_CA <= 8'b10000000; //8
        4'b1001 : SSEG_CA <= 8'b10011000; //9
        4'b1010 : SSEG_CA <= 8'b10001000; //A
        4'b1011 : SSEG_CA <= 8'b10000011; //b
        4'b1100 : SSEG_CA <= 8'b10100111; //c
        4'b1101 : SSEG_CA <= 8'b10100001; //d
        4'b1110 : SSEG_CA <= 8'b10000110; //E
        4'b1111 : SSEG_CA <= 8'b10001110; //F      
    endcase
    end//case6  
    endcase//case(State6)
    end//case6


    endcase//State
end//always Clk_Slow
    
    //Module Instantiation
    Control_Unit M1(
        op_in,  
        op_en,
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
        
    Memorypath M2(
        D_addr_sel,
        PC_addr,
        D_addr,
        D_rd,
        D_wr,
        DATA2MEM,
        R_data);
        
    Datapath M3(
        R_data,
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
        W_data);
        
endmodule