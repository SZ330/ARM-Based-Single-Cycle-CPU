// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B					value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		// 1 + 1
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'd1; B = 64'd1;
		#(delay);
		assert(result == 64'd2 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		// 1 + (-1)
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'd1; B = -64'd1;
		#(delay);
		assert(result == 64'd0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		// -1 + (-1)
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = -64'd1; B = -64'd1;
		#(delay);
		assert(result == -64'd2  && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		// -1 + 2
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = -64'd1; B = 64'd2;
		#(delay);
		assert(result == 64'd1 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);
		
		// 1532 + (-3200)
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'd1532; B = -64'd3200;
		#(delay);
		assert(result == -64'd1668 && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);

		// -4500 + (-3200)
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = -64'd4500; B = -64'd3200;
		#(delay);
		assert(result == -64'd7700 && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		
		// 1 - 1
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'd1; B = 64'd1;
		#(delay);
		assert(result == 64'd0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		// 3 - 2
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'd3; B = 64'd2;
		#(delay);
		assert(result == 64'd1 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);
		
		// 2 - 3
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'd2; B = 64'd3;
		#(delay);
		assert(result == -64'd1 && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		// 2 - (-3)
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'd2; B = -64'd3;
		#(delay);
		assert(result == 64'd5 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		// 1500 - 3200
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'd1500; B = 64'd3200;
		#(delay);
		assert(result == -64'd1700 && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		
		
		// 2 AND 2
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		A = 64'h0000000000000002; B = 64'h0000000000000002;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
	
		// 0 AND 0
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		A = 64'h1234567890ABCDEF; B = 64'hFEDCBA0987654321;
		#(delay);
		assert(result == 64'h1214120880214121 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		
		
		// 2 OR 2
		$display("%t testing OR", $time);
		cntrl = ALU_OR;
		A = 64'h0000000000000002; B = 64'h0000000000000002;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		// 0 OR 0
		$display("%t testing OR", $time);
		cntrl = ALU_OR;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		$display("%t testing OR", $time);
		cntrl = ALU_OR;
		A = 64'h1234567890ABCDEF; B = 64'hFEDCBA0987654321;
		#(delay);
		assert(result == 64'hFEFCFE7997EFCFEF && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		$display("%t testing OR", $time);
		cntrl = ALU_OR;
		A = -64'd53; B = 64'd53;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		
		
		// 2 XOR 2
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		A = 64'h0000000000000002; B = 64'h0000000000000002;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		// 0 XOR 0
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		A = 64'h1234567890ABCDEF; B = 64'hFEDCBA0987654321;
		#(delay);
		assert(result == 64'hECE8EC7117CE8ECE && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
	end
endmodule
