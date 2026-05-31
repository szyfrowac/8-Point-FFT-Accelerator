`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 10:47:45 AM
// Design Name: 
// Module Name: data_ram
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


module data_ram(
    input clk,
    input [2:0] address_x, address_y,
    input rst,
    input read,
    input write,
    input [31:0] x_re_in, x_im_in,
    input [31:0] y_re_in, y_im_in,
    output reg [31:0] x_re_out, x_im_out,
    output reg [31:0] y_re_out, y_im_out,
    output reg valid,
    output reg done
    );
    
    reg [31:0] mem_re [0:7];
    reg [31:0] mem_im [0:7];
    
    initial begin
        $readmemh("data_re_init.mem", mem_re);
        $readmemh("data_im_init.mem", mem_im);
    end
    
    always @(posedge clk) begin
        if(rst) begin
            valid <= 1'b0;
            done <= 1'b0;
        end else begin
            if(read) begin
                x_re_out <= mem_re[address_x];
                y_re_out <= mem_re[address_y];
                x_im_out <= mem_im[address_x];
                y_im_out <= mem_im[address_y];
                valid <= 1'b1;
            end else begin
                valid <= 1'b0;
            end
            
            if(write) begin
                mem_re[address_x] <= x_re_in;
                mem_re[address_y] <= y_re_in;
                mem_im[address_x] <= x_im_in;
                mem_im[address_y] <= y_im_in;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end
    
endmodule
