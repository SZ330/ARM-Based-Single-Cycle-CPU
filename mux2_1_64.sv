`timescale 1ns/10ps

module mux2_1_64 (in, out, sel);
	input logic [1:0][63:0] in;
	output logic [63:0] out;
	input logic sel;
	
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin : eachMuxes
			logic [1:0] muxInput;
            assign muxInput[0] = in[0][j];
            assign muxInput[1] = in[1][j];
			mux2_1 muxes (.i(muxInput), .out(out[j]), .sel(sel));
		end
	endgenerate
endmodule
