
`timescale 1ns/10ps
module registers (in, out, clk, reset, enable);
	input logic [63:0] in;
	output logic [63:0] out;
	input logic clk, reset, enable; // Write enable comes from decoder output
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : eachDff
			D_FF_enable dffs (.q(out[i]), .d(in[i]), .reset(reset), .clk(clk), .enable(enable));
		end
	endgenerate
endmodule

module registers_testbench();
	logic [63:0] in;
	logic [63:0] out;
	logic clk, reset, enable;
	
	registers register (.in(in), .out(out), .clk(clk), .reset(reset), .enable(enable));
	
	initial begin
		clk = 0;
		forever #100 clk = ~clk;
	end
	
	initial begin
		reset = 0;
		reset = 1;
		reset = 0;
		in = 64'hAAAAAAAAAAAAAAAA; enable = 0; #1000;

		in = 64'hAAAAAAAAAAAAAAAA; enable = 1; #1000;

		in = 64'hBBBBBBBBBBBBBBBB; enable = 0; #1000;
		
		in = 64'hBBBBBBBBBBBBBBBB; enable = 1; #1000;

		in = 64'hFFFFFFFFFFFFFFFF; enable = 0; #1000;
		
		$finish;
	end
endmodule
