
// Two input AND
`timescale 1ns/10ps
module bitwiseAND (a, b, out);
	input logic a, b;
	output logic out;
	
	and #50 AND (out, a, b);
endmodule

module bitwiseAND_testbench ();
	logic a, b;
	logic out;

	bitwiseAND AND (.a, .b, .out);
	
	initial begin
		a = 0; b = 0; #6000;
		a = 0; b = 1; #6000;
		a = 1; b = 0; #6000;
		a = 1; b = 1; #6000;
		$finish;
	end
endmodule
