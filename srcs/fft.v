`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 03:58:16 PM
// Design Name: 
// Module Name: fft
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


module fft(

    );
    
    radix2_fft f1(
      clk,
      a_re, a_im,
      b_re, b_im,
      w_re, w_im,
      x_re, x_im,
      y_re, y_im
    );
    
    radix2_fft f2(
      clk,
      c_re, c_im,
      d_re, d_im,
      w_re, w_im,
      x_re, x_im,
      y_re, y_im
    );
    
    radix2_fft f3(
      clk,
      a_re, a_im,
      b_re, b_im,
      w_re, w_im,
      x_re, x_im,
      y_re, y_im
    );
    
   radix2_fft f4(
      clk,
      a_re, a_im,
      b_re, b_im,
      w_re, w_im,
      x_re, x_im,
      y_re, y_im
    );
endmodule
