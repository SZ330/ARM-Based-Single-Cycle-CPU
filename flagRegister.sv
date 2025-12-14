`timescale 1ns/10ps

module flagRegister (negative, zero, overflow, carry_out, negativeFlag, zeroFlag, overflowFlag, carry_outFlag, setFlag, reset, clk);
    input logic negative, zero, overflow, carry_out, setFlag, reset, clk;
    output logic negativeFlag, zeroFlag, overflowFlag, carry_outFlag;

    D_FF_enable register1 (.q(negativeFlag), .d(negative), .reset(reset), .clk(clk), .enable(setFlag));
    D_FF_enable register2 (.q(zeroFlag), .d(zero), .reset(reset), .clk(clk), .enable(setFlag));
    D_FF_enable register3 (.q(overflowFlag), .d(overflow), .reset(reset), .clk(clk), .enable(setFlag));
    D_FF_enable register4 (.q(carry_outFlag), .d(carry_out), .reset(reset), .clk(clk), .enable(setFlag));
endmodule
