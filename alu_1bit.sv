
`timescale 1ns/10ps
module alu_1bit (a, b, carryIn, selector, carryOut, result);
	input logic a, b;
	input logic carryIn;
	input logic [2:0] selector;
	output logic carryOut;
	output logic result;
	
	logic sum, ANDOut, OROut, XOROut;
	logic [7:0] mux8_1_Input;
	
	fullAdder add (.a(a), .b(b), .carryIn(carryIn), .carryOut(carryOut), .sum(sum), .control(selector[0]));    
	bitwiseAND AND (.a(a), .b(b), .out(ANDOut));
	bitwiseOR OR (.a(a), .b(b), .out(OROut));
	bitwiseXOR XOR (.a(a), .b(b), .out(XOROut));
	
	assign mux8_1_Input[0] = b;
	assign mux8_1_Input[1] = 1'b0;
	assign mux8_1_Input[2] = sum;
	assign mux8_1_Input[3] = sum;
	assign mux8_1_Input[4] = ANDOut;
	assign mux8_1_Input[5] = OROut;
	assign mux8_1_Input[6] = XOROut;
	assign mux8_1_Input[7] = 1'b0;
	
	mux8_1 mux1(.i(mux8_1_Input), .out(result), .sel(selector));
endmodule
