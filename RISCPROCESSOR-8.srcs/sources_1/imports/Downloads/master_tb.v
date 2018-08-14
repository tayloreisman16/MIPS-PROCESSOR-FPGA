`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:11:18 08/13/2018
// Design Name:   master
// Module Name:   C:/Xilinx/FPGA_HDL/Final_RISC/master_tb.v
// Project Name:  Final_RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: master
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module master_tb;

	// Inputs
	reg clk;
	reg [15:0] op_in;
	reg op_en;
	reg [4:1] btn;
//	reg [15:0] SW;

	// Outputs
	wire [15:0] W_data;
	wire [3:0] OP_Code;
	wire [7:0] SSEG_CA;
	wire [7:0] SSEG_AN;
	wire [15:0] LED;
	wire [3:0] State; 	//temp

	// Instantiate the Unit Under Test (UUT)
	master uut (
		.clk(clk), 
		.op_in(op_in), 
		.op_en(op_en), 
		.btn(btn), 
//		.SW(SW), 
		.W_data(W_data), 
		.OP_Code(OP_Code), 
		.SSEG_CA(SSEG_CA), 
		.SSEG_AN(SSEG_AN), 
		.LED(LED),
		.State(State)		//temp
	);

	initial begin
		// Initialize Inputs
		clk = 0; op_en = 1;
		btn = 2;
		
		op_in = 16'b1001010111001001; //LW 5 201
		#200;
		op_in = 16'b1001011011001010; //LW 6 202;
		#200;
		op_in = 16'b0000011101010110; //Add 7 5 6
		#200;
		op_in = 16'b1010011111001011; // SW A 7 203
		#200;
		op_in = 16'b1000100011111010; // LI 8 250
		#200;
		op_in = 16'b0001010010000101; //SUB 4 8 5
		#200;
		op_in = 16'b1010010011001100; //SW 4 204
		#200;
		op_in = 16'b0110001001110000; // SRA 3 7
		#200;
		op_in = 16'b0100001000110100; //XOR 2 3 4
		#200;
		op_in = 16'b1010001011001101; //SW 2 205
		#200;
//		SW = 0;

	end
      always begin
        #5 clk = ~clk;
    end
endmodule

