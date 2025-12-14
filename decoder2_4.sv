
`timescale 1ns/10ps
module decoder2_4 (in, out, enable);
	input logic [1:0] in;
	output logic [3:0] out;
	input logic enable;
	
	logic s4, s3;
	
	not #50 input3 (s3, in[0]); // s3 = 0
	not #50 input4 (s4, in[1]); // s4 = 0
	
	and #50 output0 (out[0], enable, s4, s3);        // 00 output
	and #50 output1 (out[1], enable, s4, in[0]);     // 01 output
	and #50 output2 (out[2], enable, in[1], s3);     // 10 output
	and #50 output3 (out[3], enable, in[1], in[0]);  // 11 output
endmodule

module decoder2_4_testbench();
	logic [1:0] in;
	logic [3:0] out;
	logic enable;
	
	decoder2_4 decoder (.in(in), .out(out), .enable(enable));
	
	initial begin
		enable = 1;
		in = 2'b00; #500;
		in = 2'b01; #500;
		in = 2'b10; #500;
		in = 2'b11; #500;
		enable = 0; #500;
		$finish;
	end
endmodule
