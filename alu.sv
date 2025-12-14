
`timescale 1ns/10ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic	[2:0]	cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	// 64th bit will tell if the number is negative
	assign negative = result[63];

	logic [1:0] carryInSelect;
	logic carryInput;
	logic [64:0] carryInAndOut;
	
	// Carry in is 0 or 1 for addition or subtraction
	assign carryInSelect[0] = 1'b0;
	assign carryInSelect[1] = 1'b1;
	
	// Determine add or subtract
	// logic andSelect;
	// and #50 control10 (andSelect, cntrl[1], cntrl[0]);

	// Determines to select 0 or 1 for addition or subtraction
	mux2_1 mux2 (.out(carryInput), .i(carryInSelect), .sel(cntrl[0]));
	
	// Assign the first bit as either 0 or 1 for addition and subtraction
	assign carryInAndOut[0] = carryInput;
	
	// Generate 64 of the ALUs
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin: fullAdders
			alu_1bit alu_64 (.a(A[j]), .b(B[j]), .carryIn(carryInAndOut[j]), .selector(cntrl), .carryOut(carryInAndOut[j+1]), .result(result[j]));
		end
	endgenerate
	
	// Outputs if output is zero or not
	largeOR OR (.in(result), .zeroOutput(zero));
	
	// Determine addition or subtraction
	// logic notC2, notC0, bit10, addition, subtraction, arithmeticOperation;
	// not #50 invert1 (notC2, cntrl[2]);
	// not #50 invert2 (notC0, cntrl[0]);
	// and #50 bits10 (bit10, notC2, cntrl[1]);
	// and #50 add (addition, bit10, notC0);
	// and #50 sub (subtraction, bit10, cntrl[0]);
	// or #50 select (arithmeticOperation, addition, subtraction);

	// Signal to determine ARITHMETIC from control
	// logic notC2, arithmetic;
	// not #50 topBit (notC2, cntrl[2]);
	// and #50 isArithmetic (arithmetic, notC2, cntrl[1]);
	
	// Outputs carry_out for ADD and SUB only
	// and #50 carrying (carry_out, carryInAndOut[64], arithmetic);
	assign carry_out = carryInAndOut[64];
	
	// Outputs if overflow occurs
	// logic over;
	xor #50 XOR (overflow, carryInAndOut[64], carryInAndOut[63]);  
	// and #50 overflowing (overflow, over, arithmetic);
endmodule

module alu_testbench ();
	logic [63:0] A, B;
	logic	[2:0]	cntrl;
	logic [63:0] result;
	logic negative, zero, overflow, carry_out;
	
	alu aluTest (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);
	
	initial begin
		A = 64'b0; B = 64'b0; cntrl = 3'b000; #25000; // Passing B through
		A = {64{1'b1}}; B = {64{1'b1}}; cntrl = 3'b000; #25000; // Passing B through
		
		A = 64'b0; B = 64'b0; cntrl = 3'b010; #25000; // Adding A + B
		A = 64'b0; B = 64'b000000111111111000000; cntrl = 3'b010; #25000; // Adding A + B
		A = 64'b1000000000000000000000000000000000000000000000000000000000000000; B = 64'b1000000000000000000000000000000000000000000000000000000000000000; cntrl = 3'b010; #25000;
		
		A = 64'b0; B = 64'b0; cntrl = 3'b011; #25000; // Subtracting A - B
		A = 64'h0000000000000003; B = 64'h0000000000000002; cntrl = 3'b011; #25000; // Subtracting A - B
		A = 64'h0000000000000001; B = 64'h0000000000000001; cntrl = 3'b011; #25000;
		
		A = 64'b0; B = 64'b0; cntrl = 3'b100; #25000; // AND
		A = {64{1'b1}}; B = {64{1'b1}}; cntrl = 3'b100; #25000; // AND
		
		A = 64'b0; B = 64'b0; cntrl = 3'b101; #25000; // OR
		A = 64'b0; B = {64{1'b1}}; cntrl = 3'b101; #25000; // OR
		A = {64{1'b1}}; B = 64'b0; cntrl = 3'b101; #25000; // OR
		A = {64{1'b1}}; B = {64{1'b1}}; cntrl = 3'b101; #25000; // OR
		
		A = 64'b0; B = 64'b0; cntrl = 3'b110; #25000; // XOR
		A = {64{1'b1}}; B = 64'b0; cntrl = 3'b110; #25000; // XOR
		$finish;
	end
endmodule
