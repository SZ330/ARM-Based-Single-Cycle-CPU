
`timescale 1ns/10ps
module fullAdder (a, b, carryIn, carryOut, sum, control);
	input logic a, b, carryIn;
	output logic carryOut, sum;
	input logic control;
	
	logic [2:0] in;
	
	// Flip B for subtraction
	// Use subtraction if the control says to
	logic notB, useThisB;
	not #50 flipBits (notB, b);
	
	// Use 2:1 mux to determine which B to use
	mux2_1 mux1 (.out(useThisB), .i({notB, b}), .sel(control));
	
	// Sum/difference logic
	xor #50 sumOutput (sum, a, useThisB, carryIn);
	
	// Carryout logic
	and #50 input1 (in[0], a, useThisB);
	and #50 input2 (in[1], useThisB, carryIn);
	and #50 input3 (in[2], a, carryIn);
	or #50 carryOutput (carryOut, in[0], in[1], in[2]);
endmodule

module fullAdder_testbench ();
	logic a, b, carryIn;
	logic carryOut, sum;
	logic control;
	
	fullAdder adder (.a, .b, .carryIn, .carryOut, .sum, .control);
	
	initial begin
		// ADD
		control = 1'b0;
		a = 0; b = 0; carryIn = 0; #6000;
		a = 0; b = 0; carryIn = 1; #6000;
		a = 1; b = 1; carryIn = 1; #6000;
		a = 0; b = 1; carryIn = 0; #6000;
		a = 0; b = 1; carryIn = 1; #6000;
		a = 1; b = 0; carryIn = 0; #6000;
		a = 1; b = 0; carryIn = 1; #6000;
		a = 1; b = 1; carryIn = 0; #6000;
		a = 1; b = 1; carryIn = 1; #6000;

		// SUB
		control = 1'b1;
		a = 0; b = 0; carryIn = 0; #6000;
		a = 0; b = 0; carryIn = 1; #6000;
		a = 1; b = 1; carryIn = 1; #6000;
		a = 0; b = 1; carryIn = 0; #6000;
		a = 0; b = 1; carryIn = 1; #6000;
		a = 1; b = 0; carryIn = 0; #6000;
		a = 1; b = 0; carryIn = 1; #6000;
		a = 1; b = 1; carryIn = 0; #6000;
		a = 1; b = 1; carryIn = 1; #6000;
		$finish;
	end
endmodule
