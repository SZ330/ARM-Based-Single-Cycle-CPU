`timescale 1ns/10ps

module condAddr19Extend (condAddr19, condAddr19Extended);
    input logic [18:0] condAddr19;
    output logic [63:0] condAddr19Extended;

    // Concatenate [63:19] with sign bit and [18:0] with condAddr19
    assign condAddr19Extended = {{45{condAddr19[18]}}, condAddr19};
endmodule

module condAddr19Extend_testbench();
    logic [18:0] condAddr19;
    logic [63:0] condAddr19Extended;

    condAddr19Extend testing (.condAddr19, .condAddr19Extended);

    initial begin 
        condAddr19 = 19'b000000000; #1;
        condAddr19 = 19'b111111111; #1;
        condAddr19 = 19'b1111111111000011111; #1;
        condAddr19 = 19'b1111111111111110000; #1;
        $finish;
    end
endmodule