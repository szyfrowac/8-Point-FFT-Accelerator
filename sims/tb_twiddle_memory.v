`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 10:13:39 AM
// Design Name: 
// Module Name: tb_twiddle_memory
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


module tb_twiddle_memory();

reg [2:0] index;
reg mem_read;
wire [31:0] twiddle_factor_re;
wire [31:0] twiddle_factor_im;
wire valid;

twiddle_memory dut(
	index,
	mem_read,
	twiddle_factor_re,
	twiddle_factor_im,
	valid
);

initial begin
	mem_read = 1'b1;
	index = 3'b000;
	#10
	
	mem_read = 1'b0;
	index = 3'b001;
	#10
	
	mem_read = 1'b1;
	index = 3'b010;
	#10
	
	mem_read = 1'b0;
	index = 3'b011;
	#10
	
	mem_read = 1'b1;
	index = 3'b100;
	#10
	
	mem_read = 1'b0;
	index = 3'b101;
	#10
	
	mem_read = 1'b1;
	index = 3'b110;
	#10
	
	mem_read = 1'b0;
	index = 3'b111;
	#10;
	
	$finish;
end

endmodule
