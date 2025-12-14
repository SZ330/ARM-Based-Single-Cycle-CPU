
`timescale 1ns/10ps
module mux8_1 (i, out, sel);
	input logic [7:0] i;
	output logic out;
	input logic [2:0] sel;
	
	logic [1:0] muxOutput;
	
	mux4_1 mux1 (.i(i[3:0]), .out(muxOutput[0]), .sel(sel[1:0]));
	mux4_1 mux2 (.i(i[7:4]), .out(muxOutput[1]), .sel(sel[1:0]));
	
	mux2_1 mux3 (.out(out), .i(muxOutput), .sel(sel[2]));
endmodule

module mux8_1_testbench();
	logic [7:0] i;
	logic out;
	logic [2:0] sel;
	
	mux8_1 muxTest (.i, .out, .sel);
	
	initial begin
		sel=3'b000; i = 8'b00000000; #500;   
		sel=3'b000; i = 8'b00000001; #500;   
		sel=3'b000; i = 8'b00000010; #500;   
		sel=3'b000; i = 8'b00000011; #500;   
		
		sel=3'b001; i = 8'b00001000; #500;   
		sel=3'b001; i = 8'b00001001; #500;   
		sel=3'b001; i = 8'b00001010; #500;   
		sel=3'b001; i = 8'b00001011; #500;
		
		sel=3'b101; i = 8'b00001100; #500;   
		sel=3'b101; i = 8'b00001101; #500;   
		sel=3'b101; i = 8'b00001110; #500;   
		sel=3'b101; i = 8'b00001111; #500;   
		
		sel=3'b110; i = 8'b11110000; #500;   
		sel=3'b110; i = 8'b11110001; #500;   
		sel=3'b110; i = 8'b11110010; #500;   
		sel=3'b110; i = 8'b11110011; #500;  
		$finish;		
	end
endmodule
