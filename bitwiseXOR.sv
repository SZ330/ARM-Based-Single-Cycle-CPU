
// 2 input XOR
`timescale 1ns/10ps
module bitwiseXOR (a, b, out);
	input logic a, b;
	output logic out;
	
	xor #50 XOR (out, a, b);
endmodule

module bitwiseXOR_testbench ();
	logic a, b;
	logic out;

	bitwiseXOR XOR (.a, .b, .out);
	
	initial begin
		a = 0; b = 0; #6000;
		a = 0; b = 1; #6000;
		a = 1; b = 0; #6000;
		a = 1; b = 1; #6000;
		$finish;
	end
endmodule
