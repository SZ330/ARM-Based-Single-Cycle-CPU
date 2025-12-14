`timescale 1ns/10ps

module programCounter (clk, reset, enable, nextPC, currentPC);
    input logic clk, reset, enable;
    input logic [63:0] nextPC;
    output logic [63:0] currentPC;

    // PC is a register that stores the memory address of the next instruction to be executed
    registers pc (.in(nextPC), .out(currentPC), .clk, .reset(reset), .enable(enable));
endmodule

module programCounter_testbench ();
    logic clk, reset, enable;
    logic [63:0] previousAddress;
    logic [63:0] nextAddress;

    programCounter counting (.clk, .reset, .enable, .previousAddress, .nextAddress);

    initial begin
		clk = 0;
		forever #100 clk = ~clk;
	end

    initial begin
        reset = 1; #1;  @(posedge clk);  
        reset = 0; #1;  @(posedge clk);  
        enable = 1; #1; @(posedge clk);  

        previousAddress = 64'h0;                #1; @(posedge clk);  
        previousAddress = 64'h0000000000000004; #1; @(posedge clk);  
        previousAddress = 64'h0000000000000008; #1; @(posedge clk);  
        previousAddress = 64'h000000000000000C; #1; @(posedge clk);  
        previousAddress = 64'h0000000000000010; #1; @(posedge clk);  
        $finish;
    end
endmodule
