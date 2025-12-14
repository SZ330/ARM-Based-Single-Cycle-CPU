`timescale 1ns/10ps

module zeroExtend (imm12, zeroExtended);
    input logic [11:0] imm12;
    output logic [63:0] zeroExtended;

    logic [51:0] zeroExtension;

    assign zeroExtension = 52'b0;
    assign zeroExtended = {zeroExtension, imm12};
endmodule

module zeroExtend_testbench();
    logic [11:0] imm12;
    logic [63:0] zeroExtended;

    zeroExtend testing (.imm12, .zeroExtended);

    initial begin
        imm12 = 12'b0; #1;
        imm12 = 12'b111111111111; #1;
        imm12 = 12'b111111000000; #1;
        imm12 = 12'b111111111111; #1;
        $finish;
    end
endmodule
