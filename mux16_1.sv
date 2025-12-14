
`timescale 1ns/10ps
module mux16_1 (i, out, sel);
	input logic [15:0] i;
	output logic out;
	input logic [3:0] sel;
	
	logic [1:0] muxOutput;
	
	mux8_1 mux1 (.i(i[7:0]), .out(muxOutput[0]), .sel(sel[2:0]));
	mux8_1 mux2 (.i(i[15:8]), .out(muxOutput[1]), .sel(sel[2:0]));
	
	mux2_1 mux3 (.i(muxOutput), .out(out), .sel(sel[3]));
endmodule

module mux16_1_testbench();
	logic [15:0] i;
	logic out;
	logic [3:0] sel;
	
	mux16_1 muxTest (.i, .out, .sel);
	
	initial begin
		sel=4'b0000; i = 16'b0000000000000011; #500;   
		sel=4'b0000; i = 16'b0000000100000011; #500;   
		sel=4'b0000; i = 16'b0000001000000011; #500;   
		sel=4'b0000; i = 16'b0000001100000011; #500;   
		
		sel=4'b0010; i = 16'b0000100001110100; #500;   
		sel=4'b0010; i = 16'b0000100101110101; #500;   
		sel=4'b0010; i = 16'b0000101001110110; #500;   
		sel=4'b0010; i = 16'b0000101101110111; #500;
		
		sel=4'b1011; i = 16'b0110110000011100; #500;   
		sel=4'b1011; i = 16'b0110110100111101; #500;   
		sel=4'b1011; i = 16'b0110111000111110; #500;   
		sel=4'b1011; i = 16'b0110111100011111; #500;   
		
		sel=4'b1101; i = 16'b1111000001110000; #500;   
		sel=4'b1101; i = 16'b1111000101110001; #500;   
		sel=4'b1101; i = 16'b1111001001110010; #500;   
		sel=4'b1101; i = 16'b1111001101110011; #500;  
		$finish;		
	end
endmodule
