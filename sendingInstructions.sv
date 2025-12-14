`timescale 1ns/10ps

module sendingInstructions (clk, reset, enable, currentPC, UncondBr, BrTaken, instruction);
    output logic [63:0] currentPC;
    output logic [31:0] instruction;
    input logic clk, reset, enable, UncondBr, BrTaken;

    // Grab the output of the program counter
    // assign nextPC = 64'b0;
    logic [63:0] nextPC;
    programCounter counter (.clk(clk), .reset(reset), .enable(1'b1), .nextPC(nextPC), .currentPC(currentPC));
    
    // Access instruction memory
    instructmem memory (.address(currentPC), .instruction, .clk);
    
    // Extending CondAddr19 and BrAddr26
    logic [63:0] condAddr19_64bits, brAddr26_64bits;
    logic [18:0] condAddr19;
    logic [25:0] brAddr26;

    // Grab immediates from instruction
    assign condAddr19 = instruction[23:5];
    assign brAddr26 = instruction[25:0];    

    // Sign extend the immediates
    condAddr19Extend extend1 (.condAddr19, .condAddr19Extended(condAddr19_64bits));
    brAddr26Extend extend2 (.brAddr26, .brAddr26Extended(brAddr26_64bits));

    // Use a 2:1 mux to determine which immediate will be used
    logic [63:0] muxOutput;
    mux2_1_64 mux1 (.in({brAddr26_64bits, condAddr19_64bits}), .out(muxOutput), .sel(UncondBr));

    // Shift the number that comes out of the 2:1 mux by 2 to the left
    logic [63:0] shifterOutput;
    shiftLeftByTwo shifting (.inputNum(muxOutput), .shiftedNum(shifterOutput));

    // Two adders used to compute the next address depending on the instruction
    logic [63:0] adder1Output, adder2Output;
    fullAdder_64 adder1 (.input1(shifterOutput), .input2(currentPC), .finalResult(adder1Output));
    fullAdder_64 adder2 (.input1(currentPC), .input2(64'd4), .finalResult(adder2Output)); 

    // Use a 2:1 mux to determine which PC address to output
    mux2_1_64 mux2 (.in({adder1Output, adder2Output}), .out(nextPC), .sel(BrTaken));
endmodule
