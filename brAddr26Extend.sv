`timescale 1ns/10ps

module brAddr26Extend (brAddr26, brAddr26Extended);
    input logic [25:0] brAddr26;
    output logic [63:0] brAddr26Extended;

    // Concatenate [63:26] with sign bit and [25:0] with brAddr26
    assign brAddr26Extended = {{38{brAddr26[25]}}, brAddr26};
endmodule

module brAddr26Extend_testbench();
    logic [25:0] brAddr26;
    logic [63:0] brAddr26Extended;

    brAddr26Extend testing (.brAddr26, .brAddr26Extended);

    initial begin 
        brAddr26 = 26'b000000000; #1;
        brAddr26 = 26'b111111111; #1;
        brAddr26 = 26'b11111111111111111000011111; #1;
        brAddr26 = 26'b11111111111111111111110000; #1;
        $finish;
    end
endmodule