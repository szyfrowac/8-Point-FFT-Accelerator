`timescale 1ns / 1ps

module tb_agu;

    reg start;
    reg clk;
    reg rst;
    reg bfu_done;

    wire fft_done;
    wire [2:0] twiddle_address;
    wire [2:0] address_x;
    wire [2:0] address_y;
    wire read;
    wire write;
    wire valid_in;

    agu dut (
        .start(start),
        .clk(clk),
        .rst(rst),
        .bfu_done(bfu_done),
        .fft_done(fft_done),
        .twiddle_address(twiddle_address),
        .address_x(address_x),
        .address_y(address_y),
        .read(read),
        .write(write),
        .valid_in(valid_in)
    );

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------
    // Stimulus
    //--------------------------------------------------
    integer i;

    initial begin
        start    = 0;
        rst      = 1;
        bfu_done = 0;

        // Reset
        #20;
        rst = 0;

        // Start FFT (using non-blocking to avoid race conditions)
        @(posedge clk);
        start <= 1;

        @(posedge clk);
        start <= 0;

        // Generate 12 butterfly completions
        for(i = 0; i < 12; i = i + 1) begin
            #60;

            @(posedge clk);
            bfu_done <= 1;

            @(posedge clk);
            bfu_done <= 0;
        end

        #50;
        $finish;
    end

    //--------------------------------------------------
    // Monitor
    //--------------------------------------------------
    initial begin
        // Aligned headers and added actual state monitoring
        $display("Time\tState\tFFT_Done\tBFU_Done\tRead\tWrite\tX\tY\tTw");

        $monitor("%0t\t%d\t%b\t\t%b\t\t%b\t%b\t%d\t%d\t%d",
                 $time,
                 dut.present_state, // Hierarchical reference to view internal state
                 fft_done,
                 bfu_done,
                 read,
                 write,
                 address_x,
                 address_y,
                 twiddle_address);
    end

endmodule