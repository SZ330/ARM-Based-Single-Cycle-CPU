
`timescale 1ns/10ps
module registers_32 (in, out, clk, reset, enables);
	input logic [31:0][63:0] in;
	output logic [31:0][63:0] out;
	input logic clk, reset;
	input logic [31:0] enables;
	
	genvar i;
	generate
		for (i = 0; i < 31; i++) begin : eachRegister
			registers register (.in(in[i]), .out(out[i]), .clk(clk), .reset(reset), .enable(enables[i]));
		end
	endgenerate
	
	assign out[31] = 64'b0;
endmodule
