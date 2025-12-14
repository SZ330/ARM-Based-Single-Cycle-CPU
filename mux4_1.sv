
`timescale 1ns/10ps
module mux4_1 (i, out, sel);
	input logic [3:0] i;
	output logic out;
	input logic [1:0] sel;
	
	logic [1:0] muxOutput;
	
	mux2_1 mux1 (.out(muxOutput[0]), .i(i[1:0]), .sel(sel[0]));
	mux2_1 mux2 (.out(muxOutput[1]), .i(i[3:2]), .sel(sel[0]));
	
	mux2_1 mux3 (.out(out), .i(muxOutput), .sel(sel[1]));
endmodule

module mux4_1_testbench();
	logic [3:0] i;
	logic out;
	logic [1:0] sel;
	
	mux4_1 muxTest (.i(i), .out(out), .sel(sel));
	
	integer j;
	initial begin
		sel=2'b00; i = 4'b0000; #500;   
		sel=2'b00; i = 4'b0001; #500;   
		sel=2'b00; i = 4'b0010; #500;   
		sel=2'b00; i = 4'b0011; #500;   
		sel=2'b01; i = 4'b1000; #500;   
		sel=2'b01; i = 4'b1001; #500;   
		sel=2'b01; i = 4'b1010; #500;   
		sel=2'b01; i = 4'b1011; #500;  
		$finish;
	end
endmodule
