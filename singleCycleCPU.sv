`timescale 1ns/10ps

module singleCycleCPU (clk, reset);
    input logic clk, reset;

    logic [63:0] addressForMem;
    logic Reg2Loc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, UseShift, setFlag;
    logic [1:0] ALUSrc;
    logic [2:0] ALUOp; 

    // Grabbing the address memory and sending the instruction for it

    logic [31:0] instructions;
    // Sending PC to the instruction memory
    sendingInstructions programCounterCalc (.clk, .reset(reset), .enable(1'b1), .currentPC(addressForMem), .UncondBr, .BrTaken, .instruction(instructions));

    // Flags for the entire CPU
    logic set_zero, set_negative, set_overflow, set_carry_out;
    controlLogic controls (.instruction(instructions), .zeroFlag(set_zero), .negative(negativeFlag), .overflow(overflowFlag), .Reg2Loc, .ALUSrc, .MemToReg, .RegWrite, .MemWrite,  
                                        .BrTaken, .UncondBr, .UseShift, .setFlag, .ALUOp);
    
    // Declare wires for RegFile
    logic [63:0] ReadData1, ReadData2, WriteData;
    logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;

    // Grab the instructions to indicate which register is which
    logic [4:0] Rm, Rn, Rd;
    assign Rm = instructions[20:16];
    assign Rn = instructions[9:5];
    assign Rd = instructions[4:0];
    assign ReadRegister1 = Rn;
    assign WriteRegister = Rd;

    // Pick between Rm and Rd for the ReadRegister2
    mux2_1_5 registerSelect (.in({Rm, Rd}), .out(ReadRegister2), .sel(Reg2Loc));

    // Wires
    logic [63:0] extendedWithZeros;
    logic [63:0] extendedDAddr9;
    logic [11:0] immediate12;
    logic [8:0] dAddress9;
    logic [63:0] muxOutput4_1;

    // Bit extensions for Imme12 and DAddr9
    assign immediate12 = instructions[21:10];
    assign dAddress9 = instructions[20:12];
    zeroExtend extendingZeros (.imm12(immediate12), .zeroExtended(extendedWithZeros));
    dAddr9Extend extendDAddr9 (.dAddr9(dAddress9), .dAddr9Extended(extendedDAddr9));
    
    // Pick between immediates and ReadData2
    mux4_1_64 immediateSelect (.in({64'd0, extendedWithZeros, extendedDAddr9, ReadData2}), .out(muxOutput4_1), .sel(ALUSrc));
    
    // Register file
    regfile registerFile (.ReadData1, .ReadData2, .WriteData(WriteData), .ReadRegister1, .ReadRegister2, .WriteRegister, .RegWrite, .reset, .clk);
    
    // ALU for computation and shifter, picking between those outputs
    logic [63:0] ALUResult;
    logic [5:0] shiftAmount;
    logic [63:0] shiftResult;
    logic [63:0] shifterMuxResult;
    assign shiftAmount = instructions[15:10];
    shifter logicalShiftRight (.value(ReadData1), .direction(1'b1), .distance(shiftAmount), .result(shiftResult));
    alu bigALU (.A(ReadData1), .B(muxOutput4_1), .cntrl(ALUOp), .result(ALUResult), .negative(set_negative), .zero(set_zero), .overflow(set_overflow), .carry_out(set_carry_out)); 
    mux2_1_64 shifterOrALU (.in({shiftResult, ALUResult}), .out(shifterMuxResult), .sel(UseShift));     
 
    // Flag register
    flagRegister flags (.negative(set_negative), .zero(set_zero), .overflow(set_overflow), .carry_out(set_carry_out), .negativeFlag(negativeFlag), .zeroFlag(zeroFlag), .overflowFlag(overflowFlag), .carry_outFlag(carry_outFlag), .setFlag(setFlag), .reset(reset), .clk(clk));

    // Data memory
    logic [63:0] dataFromMem;
    datamem dataMemory (.address(ALUResult), .write_enable(MemWrite), .read_enable(1'b1), .write_data(ReadData2), .clk, .xfer_size(4'd8), .read_data(dataFromMem));

    // Pick between ALU result and data memory output and put it back into the register
    mux2_1_64 memoryMux (.in({dataFromMem, shifterMuxResult}), .out(WriteData), .sel(MemToReg));                                 
endmodule

module singleCycleCPU_testbench();
    logic clk, reset;

    singleCycleCPU cpu (.clk, .reset);

    parameter CLOCK_PERIOD = 50000;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    // For last two tests
    int i;
    initial begin
        reset <= 1; @(posedge clk);
                    @(posedge clk);
        reset <= 0; @(posedge clk);

        for (i = 0; i < 2000; i++) begin
            @(posedge clk);
        end
        $stop;
    end

    // For every other test besides the last two
    // int i;
    // initial begin
    //     reset <= 1; @(posedge clk);
    //                 @(posedge clk);
    //     reset <= 0; @(posedge clk);

    //     for (i = 0; i < 100; i++) begin
    //         @(posedge clk);
    //     end
    //     $stop;
    // end
endmodule
