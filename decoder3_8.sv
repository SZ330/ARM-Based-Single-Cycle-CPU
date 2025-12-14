
`timescale 1ns/10ps
module decoder3_8 (in, out, enable);
	input logic [2:0] in;
	output logic [7:0] out;
	input logic enable;
	
	logic s2, s1, s0;
	
	not #50 input0 (s0, in[0]);	// s0 = 0
	not #50 input1 (s1, in[1]); // s1 = 0
	not #50 input2 (s2, in[2]); // s2 = 0
	
	and #50 output0 (out[0], enable, s2, s1, s0);
	and #50 output1 (out[1], enable, s2, s1, in[0]);
	and #50 output2 (out[2], enable, s2, in[1], s0);
	and #50 output3 (out[3], enable, s2, in[1], in[0]);
	and #50 output4 (out[4], enable, in[2], s1, s0);
	and #50 output5 (out[5], enable, in[2], s1, in[0]);
	and #50 output6 (out[6], enable, in[2], in[1], s0);
	and #50 output7 (out[7], enable, in[2], in[1], in[0]);
endmodule

module decoder3_8_testbench();
	logic [2:0] in;
	logic [7:0] out;
	logic enable;
	
	decoder3_8 decoder (.in(in), .out(out), .enable(enable));
	
	initial begin
		enable = 1; in = 3'b000; #200;
		enable = 1; in = 3'b001; #200;
		enable = 1; in = 3'b010; #200;
		enable = 1; in = 3'b011; #200;
		enable = 1; in = 3'b100; #200;
		enable = 1; in = 3'b101; #200;
		enable = 1; in = 3'b110; #200;
		enable = 1; in = 3'b111; #200;

		enable = 0; in = 3'b000; #200;
		enable = 0; in = 3'b111; #200;
	
		$finish;
	end
endmodule
