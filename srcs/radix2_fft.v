    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Module Name: radix2_fft
    // Description: A pipelined radix-2 butterfly unit for FFT computation using
    //              IEEE-754 single-precision floating-point arithmetic.
    // Latency:     2 clock cycles (Multiplier = 0 cycles, Adder = 2 cycles)
    //////////////////////////////////////////////////////////////////////////////////
    
    module radix2_fft(
        input clk,
        input rst,
        input [31:0] a_re, a_im,
        input [31:0] b_re, b_im,
        input [31:0] w_re, w_im,
        output reg [31:0] x_re, x_im,
        output reg [31:0] y_re, y_im,
        output done,
        input valid_in
    );
        
        wire [31:0] re_wire_1, re_wire_2, re_wire_3;
        wire [31:0] im_wire_1, im_wire_2, im_wire_3;
        wire [31:0] x_re_w, x_im_w, y_re_w, y_im_w;
        
        reg [31:0] a_re_delay_1, a_im_delay_1;
        reg [31:0] a_re_delay_2, a_im_delay_2;
        
        reg [4:0] valid_pipe;

        always @(posedge clk or negedge rst) begin
            if(rst)
                valid_pipe <= 4'b0;
            else begin
                valid_pipe[0] <= valid_in;
                valid_pipe[1] <= valid_pipe[0];
                valid_pipe[2] <= valid_pipe[1];
                valid_pipe[3] <= valid_pipe[2];
                valid_pipe[4] <= valid_pipe[3];
            end
        end
        
        assign done = valid_pipe[4];
        
        
        always @(posedge clk or negedge rst) begin
            if(rst) begin
                a_re_delay_1 <= 0;
                a_re_delay_2 <= 0;
                a_im_delay_1 <= 0;
                a_im_delay_2 <= 0;
            end
            else begin
                a_re_delay_1 <= a_re;
                a_re_delay_2 <= a_re_delay_1;
        
                a_im_delay_1 <= a_im;
                a_im_delay_2 <= a_im_delay_1;
            end
        end
        
        // ==========================================
        // COMPLEX MULTIPLICATION: Real Part of (B * W)
        // Formula: (b_re * w_re) - (b_im * w_im)
        // ==========================================
        top_fp_multiplier mul1(
            .clk(clk),
            .float_in_a(w_re),
            .float_in_b(b_re),
            .float_out(re_wire_1) // b_re * w_re
        );
        
        top_fp_multiplier mul2(
            .clk(clk),
            .float_in_a(w_im),
            .float_in_b(b_im),
            .float_out(re_wire_2) // b_im * w_im
        );
        
        // Subtractor for the real part
        IEEEFPAdd_8_23_Freq100_uid2 adder2(
            .clk(clk),
            .X(re_wire_1),
            .Y({~re_wire_2[31], re_wire_2[30:0]}),
            .R(re_wire_3) 
        );
        
        // ==========================================
        // COMPLEX MULTIPLICATION: Imaginary Part of (B * W)
        // Formula: (b_re * w_im) + (b_im * w_re)
        // ==========================================
        top_fp_multiplier mul1_im(
            .clk(clk),
            .float_in_a(w_re),
            .float_in_b(b_im),
            .float_out(im_wire_1) // w_re * b_im
        );
        
        top_fp_multiplier mul2_im(
            .clk(clk),
            .float_in_a(w_im),
            .float_in_b(b_re),
            .float_out(im_wire_2) // w_im * b_re
        );
        
        // Adder for the imaginary part
        IEEEFPAdd_8_23_Freq100_uid2 adder2_im(
            .clk(clk),
            .X(im_wire_1),
            .Y(im_wire_2),
            .R(im_wire_3)
        );
        
        // Final Real Outputs
        IEEEFPAdd_8_23_Freq100_uid2 adder1(
            .clk(clk),
            .X(a_re_delay_2),
            .Y(re_wire_3),
            .R(x_re_w) // x_re = a_re + Re(B*W)
        );
        
        IEEEFPAdd_8_23_Freq100_uid2 sub1(
            .clk(clk),
            .X(a_re_delay_2),
            .Y({~re_wire_3[31], re_wire_3[30:0]}),
            .R(y_re_w) // y_re = a_re - Re(B*W)
        );
        
        // Final Imaginary Outputs
        IEEEFPAdd_8_23_Freq100_uid2 adder1_im(
            .clk(clk),
            .X(a_im_delay_2),
            .Y(im_wire_3),
            .R(x_im_w) // x_im = a_im + Im(B*W)
        );
        
        IEEEFPAdd_8_23_Freq100_uid2 sub1_im(
            .clk(clk),
            .X(a_im_delay_2),
            .Y({~im_wire_3[31], im_wire_3[30:0]}),
            .R(y_im_w) // y_im = a_im - Im(B*W)
        );
        
        always@(posedge clk or negedge rst) begin
            if(rst) begin
                x_re <= 32'b0;
                x_im <= 32'b0;
                y_re <= 32'b0;
                y_im <= 32'b0;
            end
            else if(done) begin
                x_re <= x_re_w;
                x_im <= x_im_w;
                y_re <= y_re_w;
                y_im <= y_im_w;
            end
        end
        
    endmodule
