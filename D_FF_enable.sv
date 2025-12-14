
`timescale 1ns/10ps
module D_FF_enable (q, d, reset, clk, enable);
	output reg q; 
	input d, reset, clk, enable;
	
	logic [1:0] muxInputs;
	logic muxOutput;

	assign muxInputs[0] = q;
	assign muxInputs[1] = d;
	
	mux2_1 mux0 (.out(muxOutput), .i(muxInputs), .sel(enable));
	
	D_FF dff0 (.q(q), .d(muxOutput), .reset(reset), .clk(clk));
endmodule

module D_FF_enable_testbench();
	logic q;
	logic d, reset, clk, enable;
	
	D_FF_enable dut (.q(q), .d(d), .reset(reset), .clk(clk), .enable(enable));
	
	initial begin
		clk = 0;
		forever #100 clk = ~clk;
	end
	
	initial begin
		d = 0;
		enable = 0;
		reset = 1; #10;
		reset = 0; #10;
		
      	d = 0; enable = 0; #20;
		reset = 1; #10;
		reset = 0; #10;
		
      	d = 1; enable = 1; #20;
		reset = 1; #10;
		reset = 0; #10;
		
      	d = 0; enable = 1; #20;
		reset = 1; #10;
		reset = 0; #10;
		
      	d = 1; enable = 0; #20;
		$finish;
	end
endmodule
