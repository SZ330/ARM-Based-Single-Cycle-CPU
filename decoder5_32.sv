
`timescale 1ns/10ps
module decoder5_32 (in, out, enable);
	input logic [4:0] in;
	output logic [31:0] out;
	input logic enable;
	
	logic [3:0] twoToFourOutput;
	
	decoder2_4 decoder0 (.in(in[4:3]), .out(twoToFourOutput), .enable(enable));
	decoder3_8 decoder1 (.in(in[2:0]), .out(out[7:0]), .enable(twoToFourOutput[0]));
	decoder3_8 decoder2 (.in(in[2:0]), .out(out[15:8]), .enable(twoToFourOutput[1]));
	decoder3_8 decoder3 (.in(in[2:0]), .out(out[23:16]), .enable(twoToFourOutput[2]));
	decoder3_8 decoder4 (.in(in[2:0]), .out(out[31:24]), .enable(twoToFourOutput[3]));
endmodule

module decoder5_32_testbench();
	logic [4:0] in;
	logic [31:0] out;
	logic enable;
	
	decoder5_32 decoder (.in(in), .out(out), .enable(enable));
	
	initial begin
		enable = 0;
		enable = 1;
		in = 5'b00000; #500;
		in = 5'b00001; #500;
		in = 5'b00010; #500;
		enable = 0; #500;
		$finish;
	end
endmodule
