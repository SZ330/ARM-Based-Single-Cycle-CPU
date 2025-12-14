
// Two input OR
`timescale 1ns/10ps
module bitwiseOR (a, b, out);
	input logic a, b;
	output logic out;
	
	or #50 OR (out, a, b);
endmodule

module bitwiseOR_testbench ();
	logic a, b;
	logic out;

	bitwiseOR OR (.a, .b, .out);
	
	initial begin
		a = 0; b = 0; #6000;
		a = 0; b = 1; #6000;
		a = 1; b = 0; #6000;
		a = 1; b = 1; #6000;
		$finish;
	end
endmodule
