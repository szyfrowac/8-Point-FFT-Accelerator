`timescale 1ns / 1ps

module tb_data_ram();

    // 1. Added Clock Signal
    reg clk;
    
    reg [2:0] address_x, address_y;
    reg rst;
    reg read;
    reg write;

    reg [31:0] x_re_in, x_im_in;
    reg [31:0] y_re_in, y_im_in;

    wire [31:0] x_re_out, x_im_out;
    wire [31:0] y_re_out, y_im_out;
    wire valid;
    wire done;

    data_ram dut(
        .clk(clk), // 2. Connected Clock to DUT
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
        .valid(valid),
        .done(done)
    );

    //--------------------------------------------------
    // Clock Generation (100 MHz)
    //--------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    //--------------------------------------------------
    // Synchronous Stimulus
    //--------------------------------------------------
    initial begin
        // Initialize
        rst      = 1;
        read     = 0;
        write    = 0;
        address_x = 0;
        address_y = 1;
        x_re_in = 0; x_im_in = 0;
        y_re_in = 0; y_im_in = 0;

        // Hold reset for a few cycles
        repeat(2) @(negedge clk);
        rst = 0;

        //--------------------------------------------------
        // Test 1 : Read initial contents
        //--------------------------------------------------
        $display("\n====================================");
        $display("TEST 1 : READ INITIAL MEMORY");
        $display("====================================");
        
        @(negedge clk);
        read = 1;
        
        // Wait 1 cycle for RAM to process the read
        @(negedge clk); 
        read = 0;
        
        $display("Addr X = %0d", address_x);
        $display("Addr Y = %0d", address_y);
        $display("X = %h + j%h", x_re_out, x_im_out);
        $display("Y = %h + j%h", y_re_out, y_im_out);
        $display("Valid = %b", valid);

        repeat(2) @(negedge clk);

        //--------------------------------------------------
        // Test 2 : Write new values
        //--------------------------------------------------
        $display("\n====================================");
        $display("TEST 2 : WRITE");
        $display("====================================");

        @(negedge clk);
        address_x = 2;
        address_y = 3;
        x_re_in = 32'h41200000; // 10.0
        x_im_in = 32'h3F800000; // 1.0
        y_re_in = 32'h41A00000; // 20.0
        y_im_in = 32'h40000000; // 2.0
        write = 1;
        
        @(negedge clk);
        write = 0;
        $display("done = %b", done);

        repeat(2) @(negedge clk);

        //--------------------------------------------------
        // Test 3 : Read back written values
        //--------------------------------------------------
        $display("\n====================================");
        $display("TEST 3 : READ AFTER WRITE");
        $display("====================================");

        @(negedge clk);
        read = 1; // Addresses 2 and 3 are still held on the bus
        
        @(negedge clk);
        read = 0;
        $display("Addr X = %0d", address_x);
        $display("Addr Y = %0d", address_y);
        $display("X = %h + j%h", x_re_out, x_im_out);
        $display("Y = %h + j%h", y_re_out, y_im_out);

        repeat(2) @(negedge clk);

        //--------------------------------------------------
        // Test 4 : Another write/read
        //--------------------------------------------------
        $display("\n====================================");
        $display("TEST 4 : SECOND WRITE");
        $display("====================================");

        @(negedge clk);
        address_x = 6;
        address_y = 7;
        x_re_in = 32'h42280000; // 42.0
        x_im_in = 32'h40400000; // 3.0
        y_re_in = 32'h42480000; // 50.0
        y_im_in = 32'h40800000; // 4.0
        write = 1;
        
        @(negedge clk);
        write = 0;

        @(negedge clk);
        read = 1;
        
        @(negedge clk);
        read = 0;
        $display("X = %h + j%h", x_re_out, x_im_out);
        $display("Y = %h + j%h", y_re_out, y_im_out);

        repeat(2) @(negedge clk);
        $display("\nSimulation Finished.");
        $finish;
    end

endmodule