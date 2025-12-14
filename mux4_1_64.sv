`timescale 1ns/10ps

module mux4_1_64 (in, out, sel);
    input  logic [3:0][63:0] in;   // 4 inputs, each 64 bits wide
    output logic [63:0] out;       // 64-bit output
    input  logic [1:0] sel;        // 2-bit selector

    genvar j, k;
    generate
        for (j = 0; j < 64; j++) begin : eachMuxes
            logic [3:0] muxInput;  // inputs for this bit position
            for (k = 0; k < 4; k++) begin : eachInput
                assign muxInput[k] = in[k][j];
            end
            mux4_1 muxes (.i(muxInput), .out(out[j]), .sel(sel));
        end
    endgenerate
endmodule
