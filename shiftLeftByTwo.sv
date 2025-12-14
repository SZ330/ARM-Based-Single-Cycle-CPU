`timescale 1ns/10ps

module shiftLeftByTwo (inputNum, shiftedNum);
    input logic [63:0] inputNum;
    output logic [63:0] shiftedNum;

    // Shift two bits of zeros into the right of the number
    logic [1:0] bottomBits;
    assign bottomBits = 2'b0;

    // Store all the bits except the first two bits
    logic [61:0] restOfNum;
    assign restOfNum = inputNum[61:0];

    // Concatenate original 62 bits and then put two bits of zeros at the end
    assign shiftedNum = {restOfNum, bottomBits};
endmodule

module shiftLeftByTwo_testbench ();
    logic [63:0] inputNum;
    logic [63:0] shiftedNum;

    shiftLeftByTwo testing (.inputNum, .shiftedNum);

    initial begin
        inputNum = 64'h0123456789123456; #1;
        inputNum = 64'hAFCDA76549802136; #1;
        inputNum = 64'hDCFAE98031274653; #1;
        $finish;
    end
endmodule
