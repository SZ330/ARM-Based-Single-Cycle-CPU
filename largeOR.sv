
`timescale 1ns/10ps
module largeOR (in, zeroOutput);
	input logic [63:0] in;
	output logic zeroOutput;
	
	logic [31:0] firstLayerOutput;
	logic [15:0] secondLayerOutput;
	logic [7:0] thirdLayerOutput;
	logic [3:0] fourthLayerOutput;
	logic [1:0] fifthLayerOutput;
	logic sixthLayerOutput;
	
	genvar i, j, k, l, m;
	generate
		for (i = 0; i < 32; i++) begin: firstLayer
			or #50 first (firstLayerOutput[i], in[2*i], in[2*i + 1]);
		end
		
		for (j = 0; j < 16; j++) begin: secondLayer
			or #50 second (secondLayerOutput[j], firstLayerOutput[2*j], firstLayerOutput[2*j + 1]);
		end
		
		for (k = 0; k < 8; k++) begin: thirdLayer
			or #50 third (thirdLayerOutput[k], secondLayerOutput[2*k], secondLayerOutput[2*k + 1]);
		end
		
		for (l = 0; l < 4; l++) begin: fourthLayer
			or #50 fourth (fourthLayerOutput[l], thirdLayerOutput[2*l], thirdLayerOutput[2*l + 1]);
		end
		
		for (m = 0; m < 2; m++) begin: fifthLayer
			or #50 fifth (fifthLayerOutput[m], fourthLayerOutput[2*m], fourthLayerOutput[2*m + 1]);
		end
	endgenerate
		
	or #50 sixth (sixthLayerOutput, fifthLayerOutput[0], fifthLayerOutput[1]);
	
	not #50 finalOutput (zeroOutput, sixthLayerOutput);
endmodule


module largeOR_testbench ();
	logic [63:0] in;
	logic zeroOutput;
	
	largeOR OR (.in, .zeroOutput);
	
	initial begin
		in = 64'b0; #5000;
		in = 64'b111110000; #5000;
		$finish;
	end
endmodule
