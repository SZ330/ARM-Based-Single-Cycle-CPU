
`timescale 1ns/10ps
module mux2_1(out, i, sel);  
	output logic out;   
	input  logic sel;   
	input logic [1:0] i;
	
	logic v1, v0;
	logic notSel;
	
	not #50 notSelector (notSel, sel);
	and #50 first (v1, i[1], sel);
	and #50 second (v0, i[0], notSel);
	or #50 third (out, v1, v0);
endmodule  

module mux2_1_testbench();  
	logic [1:0] i;
	logic sel;   
	logic out;   
	
	mux2_1 dut (.out, .i, .sel);   
	
	initial begin  
		sel=0; i = 2'b00; #500;   
		sel=0; i = 2'b01; #500;   
		sel=0; i = 2'b10; #500;   
		sel=0; i = 2'b11; #500;   
		sel=1; i = 2'b00; #500;   
		sel=1; i = 2'b01; #500;   
		sel=1; i = 2'b10; #500;   
		sel=1; i = 2'b11; #500;   
	end  
endmodule 