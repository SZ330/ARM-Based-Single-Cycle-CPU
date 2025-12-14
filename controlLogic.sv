`timescale 1ns/10ps

// More inputs???
module controlLogic (instruction, zeroFlag, negative, overflow, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, UseShift, setFlag, ALUOp);
    input logic [31:0] instruction;
    input logic zeroFlag, negative, overflow;
    output logic Reg2Loc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, UseShift, setFlag;
    output logic [1:0] ALUSrc;
    output logic [2:0] ALUOp;

    // Wires for opcodes
    logic [10:0] opcode11;
    logic [9:0] opcode10;
    logic [7:0] opcode8;
    logic [5:0] opcode6;
    logic [4:0] opcode5;

    // Grab the corresponding opcodes for certain operations
    assign opcode11 = instruction[31:21];
    assign opcode10 = instruction[31:22];
    assign opcode8 = instruction[31:24];
    assign opcode6 = instruction[31:26];
    assign opcode5 = instruction [4:0];

    // Wire for each opcode
    logic Add, Sub, Ldur, Stur, Branch, Cbz, AddI, And, BranchLT, Eor, Lsr;

    assign Add = (opcode11 == 11'b10101011000); // Opcode good
    assign Sub = (opcode11 == 11'b11101011000); // Opcode good
    assign Ldur = (opcode11 == 11'b11111000010); // Opcode good
    assign Stur = (opcode11 == 11'b11111000000); // Opcode good
    assign Branch = (opcode6 == 6'b000101); // Opcode good
    assign Cbz = (opcode8 == 8'b10110100); // Opcode good
    assign AddI = (opcode10 == 10'b1001000100); // Opcode good
    assign And = (opcode11 == 11'b10001010000); // Opcode good
    assign BranchLT = ((opcode8 == 8'b01010100) && (opcode5 == 5'b01011)); // Opcode good
    assign Eor = (opcode11 == 11'b11001010000);
    assign Lsr = (opcode11 == 11'b11010011010);

    always_comb begin
        Reg2Loc = 0;
        ALUSrc = 2'b00;
        MemToReg = 0;
        RegWrite = 0;
        MemWrite = 0;
        BrTaken = 0;
        UncondBr = 0;
        UseShift = 0;
        setFlag = 0;
        ALUOp = 3'b010;

        // ADDS
        if (Add) begin
            Reg2Loc = 1;
            RegWrite = 1;
            setFlag = 1;
        end

        // SUBS
        else if (Sub) begin
            Reg2Loc = 1;
            RegWrite = 1;
            setFlag = 1;
            ALUOp = 3'b011;
        end

        // LDUR
        else if (Ldur) begin
            ALUSrc = 2'b01;
            MemToReg = 1;
            RegWrite = 1;
        end

        // STUR
        else if (Stur) begin
            ALUSrc = 2'b01;
            MemWrite = 1;
        end

        //B
        else if (Branch) begin
            BrTaken = 1;
            UncondBr = 1;
        end

        // CBZ 
        // Uses immediate zero from ALU as it needs to check if the register is 0 or not
        else if (Cbz) begin
            if (zeroFlag) begin
                BrTaken = 1;
            end
            ALUOp = 3'b000;
        end
        
        // ADDI
        else if (AddI) begin
            RegWrite = 1;
            ALUSrc = 2'b10;
        end

        // AND
        else if (And) begin
            RegWrite = 1;
            Reg2Loc = 1;
            ALUOp = 3'b100;
        end

        // B.LT
        // Uses from flag register as it needs values from previous comparison
        else if (BranchLT) begin
            if (negative != overflow) begin
                BrTaken = 1;
            end
        end

        // EOR
        else if (Eor) begin
            Reg2Loc = 1;
            RegWrite = 1;
            ALUOp = 3'b110;
        end

        // LSR
        else if (Lsr) begin
            RegWrite = 1;
            UseShift = 1;
        end
    end
endmodule
