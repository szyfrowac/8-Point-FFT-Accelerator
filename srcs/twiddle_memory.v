`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2026 06:01:26 PM
// Design Name: 
// Module Name: twiddle_memory
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


module twiddle_memory(
    input clk,
    input rst,
    input [2:0] index,
    input mem_read,
    output reg [31:0] twiddle_factor_re,    
    output reg [31:0] twiddle_factor_im,
    output reg valid
    );
    
    reg [31:0] mem [0:7];
    reg [31:0] mem_im [0:7];

    initial begin
        $readmemh("twiddle_re_init.mem", mem);
        $readmemh("twiddle_re_init.mem", mem_im);
    end

    always @(posedge clk) begin
        if(rst) begin
            valid <= 1'b0;
            // done <= 1'b0;
        end else begin 
            if (mem_read) begin
                twiddle_factor_re <= mem[index];
                twiddle_factor_im <= mem[index+4];
                valid <= 1'b1;
            end
            else begin
                valid <= 1'b0;
            end
        end
    end

endmodule
