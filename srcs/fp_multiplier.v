module top_fp_multiplier (
    input clk,
    input [31:0] float_in_a,
    input [31:0] float_in_b,
    output [31:0] float_out
);

    // Internal wires for FloPoCo format (2 exn + 1 sign + 8 exp + 23 frac = 34 bits)
    wire [33:0] flopoco_a;
    wire [33:0] flopoco_b;
    wire [33:0] flopoco_res;

    // 1. Instantiate Input Converter for Operand A
    InputIEEE_8_23_to_8_23_Freq100_uid2 input_conv_a (
        .clk(clk),
        .X(float_in_a),
        .R(flopoco_a)
    );

    // 2. Instantiate Input Converter for Operand B 
    InputIEEE_8_23_to_8_23_Freq100_uid2 input_conv_b (
        .clk(clk),
        .X(float_in_b),
        .R(flopoco_b)
    );

    // 3. Instantiate the ACTUAL FloPoCo Floating-Point Multiplier
    FPMult_8_23_uid2_Freq100_uid3 fp_mult_core (
        .clk(clk),
        .X(flopoco_a),     // 34-bit input
        .Y(flopoco_b),     // 34-bit input
        .R(flopoco_res)    // 34-bit output
    );

    // 4. Instantiate Output Converter
    OutputIEEE_8_23_to_8_23_Freq100_uid2 output_conv (
        .clk(clk),
        .X(flopoco_res),
        .R(float_out)
    );

endmodule
