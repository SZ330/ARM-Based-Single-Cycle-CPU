`timescale 1ns/10ps

module dAddr9Extend (dAddr9, dAddr9Extended);
    input logic [8:0] dAddr9;
    output logic [63:0] dAddr9Extended;

    // Concatenate [63:9] with sign bit and [8:0] with condAddr19
    assign dAddr9Extended = {{55{dAddr9[8]}}, dAddr9};
endmodule

module dAddr9Extend_testbench();
    logic [8:0] dAddr9;
    logic [63:0] dAddr9Extended;

    dAddr9Extend testing (.dAddr9, .dAddr9Extended);

    initial begin 
        dAddr9 = 9'b000000000; #1;
        dAddr9 = 9'b111111111; #1;
        dAddr9 = 9'b000011111; #1;
        dAddr9 = 9'b111110000; #1;
        $finish;
    end
endmodule
