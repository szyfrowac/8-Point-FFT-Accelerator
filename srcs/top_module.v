`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 12:59:51 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input start,
    input clk,
    input rst,
    output fft_done
    );
    
    wire bfu_done, read_mem_select;
    wire read, write, valid, valid_ram;
    wire [2:0] index, address_x, address_y;
    wire [31:0] twiddle_factor_re, twiddle_factor_im;
    wire [31:0] x_re_out, x_im_out, y_re_out, y_im_out;
    wire [31:0] x_re_in, x_im_in, y_re_in, y_im_in;
    
    agu agu1(
        .start(start),
        .clk(clk),
        .rst(rst),
        .bfu_done(bfu_done),
        .fft_done(fft_done),
        // .read_mem_select(read_mem_select),
        .twiddle_address(index),
        .address_x(address_x),
        .address_y(address_y),
        .read(read),
        .write(write)
        //.valid_in(valid_in)
    );
        
    twiddle_memory twiddle_mem1(
        .clk(clk),
        .rst(rst),
        .index(index),
        .mem_read(read),
        .twiddle_factor_re(twiddle_factor_re),    
        .twiddle_factor_im(twiddle_factor_im),
        .valid(valid)
    );
    
    data_ram data_ram1(
        .clk(clk),
        .address_x(address_x), 
        .address_y(address_y),
        .rst(rst),
        .read(read),
        .write(write),
        .x_re_in(x_re_in), 
        .x_im_in(x_im_in),
        .y_re_in(y_re_in), 
        .y_im_in(y_im_in),
        .x_re_out(x_re_out), 
        .x_im_out(x_im_out),
        .y_re_out(y_re_out), 
        .y_im_out(y_im_out),
        .valid(valid_ram),
        .done(done)
    );
    
    radix2_fft bfu(
        .clk(clk),
        .rst(rst),
        .a_re(x_re_out), 
        .a_im(x_im_out),
        .b_re(y_re_out), 
        .b_im(y_im_out),
        .w_re(twiddle_factor_re), 
        .w_im(twiddle_factor_im),
        .x_re(x_re_in), 
        .x_im(x_im_in),
        .y_re(y_re_in), 
        .y_im(y_im_in),
        .done(bfu_done),
        .valid_in(valid_ram)
    );
    
endmodule
