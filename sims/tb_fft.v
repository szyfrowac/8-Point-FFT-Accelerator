`timescale 1ns / 1ps

module tb_fft();

reg clk;
reg rst;
reg valid_in;

reg [31:0] a_re, a_im;
reg [31:0] b_re, b_im;
reg [31:0] w_re, w_im;

wire [31:0] x_re, x_im;
wire [31:0] y_re, y_im;

wire done;


// DUT
radix2_fft dut(
    .clk(clk),
    .rst(rst),

    .a_re(a_re),
    .a_im(a_im),

    .b_re(b_re),
    .b_im(b_im),

    .w_re(w_re),
    .w_im(w_im),

    .x_re(x_re),
    .x_im(x_im),

    .y_re(y_re),
    .y_im(y_im),
    
    .valid_in(valid_in),
    .done(done)
);


// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// Reset (active LOW)
initial begin
    rst = 0;
    #20;
    rst = 1;
end


initial begin

//--------------------------------
// Initialize
//--------------------------------
a_re = 0;
a_im = 0;

b_re = 0;
b_im = 0;

w_re = 0;
w_im = 0;

wait(rst);

//--------------------------------
// TEST 1
// A=(5+j0)
// B=(3+j0)
// W=(1+j0)
//
// Expected:
// X=(8+j0)
// Y=(2+j0)
//--------------------------------

@(posedge clk);

a_re = 32'h40A00000; // 5.0
a_im = 32'h00000000;

b_re = 32'h40400000; // 3.0
b_im = 32'h00000000;

w_re = 32'h3F800000; // 1.0
w_im = 32'h00000000;

valid_in = 1'b1;
#10;
valid_in = 1'b0;
#60;

$display("\nTEST1");
$display("x_re=%h x_im=%h",x_re,x_im);
$display("y_re=%h y_im=%h",y_re,y_im);


//--------------------------------
// TEST 2
// A=(5+j2)
// B=(3+j1)
// W=(1+j0)
//
// Expected:
// X=(8+j3)
// Y=(2+j1)
//--------------------------------

@(posedge clk);

a_re = 32'h40A00000; // 5
a_im = 32'h40000000; // 2

b_re = 32'h40400000; // 3
b_im = 32'h3F800000; // 1

w_re = 32'h3F800000;
w_im = 32'h00000000;

valid_in = 1'b1;
#10;
valid_in = 1'b0;
#60;

$display("\nTEST2");
$display("x_re=%h x_im=%h",x_re,x_im);
$display("y_re=%h y_im=%h",y_re,y_im);


//--------------------------------
// TEST 3
// A=(-4+j5)
// B=(2-j3)
// W=(1+j0)
//
// Expected:
// X=(-2+j2)
// Y=(-6+j8)
//--------------------------------

@(posedge clk);

a_re = 32'hC0800000; // -4
a_im = 32'h40A00000; // 5

b_re = 32'h40000000; // 2
b_im = 32'hC0400000; // -3

w_re = 32'h3F800000;
w_im = 32'h00000000;

valid_in = 1'b1;
#10;
valid_in = 1'b0;
#60;

$display("\nTEST3");
$display("x_re=%h x_im=%h",x_re,x_im);
$display("y_re=%h y_im=%h",y_re,y_im);


#50;

$display("\nSimulation Finished");

$finish;

end

endmodule