
`timescale 1ns/10ps
module mux32_1_64 (in, out, sel);
	input logic [31:0][63:0] in;
	output logic [63:0] out;
	input logic [4:0] sel;
	
	genvar j, k;
	generate
		for (j = 0; j < 64; j++) begin : eachMuxes
			logic [31:0] muxInput;
			for (k = 0; k < 32; k++) begin: eachInput
				assign muxInput[k] = in[k][j];
			end
			mux32_1 muxes (.i(muxInput), .out(out[j]), .sel(sel));
		end
	endgenerate
endmodule

module mux32_1_64_testbench();
	logic [63:0][31:0] in;
	logic [63:0] out;
	logic [4:0] sel;

	mux32_1_64 dut (.in(in), .out(out), .sel(sel));

	initial begin
		integer i, j;
		for (i = 0; i < 64; i = i + 1) begin
			for (j = 0; j < 32; j = j + 1) begin
				in[i][j] = i + j;
			end
		end

		// Apply a few selector values
		sel = 5'd0; #10000; 

		sel = 5'd5; #10000;;

		sel = 5'd10; #10000;

		sel = 5'd31; #10000;

		$finish;
	end
endmodule
