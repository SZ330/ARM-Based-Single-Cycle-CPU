`timescale 1ns/10ps
module fullAdder_64 (input1, input2, finalResult);  
    input logic [63:0] input1, input2;
    output logic [63:0] finalResult;

    logic [64:0] carryBit;
    assign carryBit[0] = 1'b0;

    genvar i;
	generate
		for (i = 0; i < 64; i++) begin : eachAdder
			fullAdder fullAdders (.a(input1[i]), .b(input2[i]), .carryIn(carryBit[i]), .carryOut(carryBit[i+1]), .sum(finalResult[i]), .control(1'b0));
		end
	endgenerate
endmodule

module fullAdder_64_testbench ();
    logic [63:0] input1, input2;
    logic [63:0] finalResult;

    fullAdder_64 fullAdder64 (.input1, .input2, .finalResult);

    initial begin
        input1 = 64'd5; input2 = 64'd6; #1000;

        input1 = 64'd35; input2 = 64'd35; #1000;
        $finish;
    end
endmodule
