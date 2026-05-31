`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 04:41:48 PM
// Design Name: 
// Module Name: tb_top_module
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


`timescale 1ns / 1ps

module tb_top_module();

    // ---------------------------------------------------------
    // Signal Declarations
    // ---------------------------------------------------------
    // Inputs to DUT are declared as reg
    reg start;
    reg clk;
    reg rst;

    // Outputs from DUT are declared as wire
    wire fft_done;

    // ---------------------------------------------------------
    // Device Under Test (DUT) Instantiation
    // ---------------------------------------------------------
    top_module uut (
        .start(start),
        .clk(clk),
        .rst(rst),
        .fft_done(fft_done)
    );

    // ---------------------------------------------------------
    // Clock Generation (100 MHz)
    // ---------------------------------------------------------
    initial begin
        clk = 0;
        // Toggle clock every 5 ns to create a 10 ns period
        forever #5 clk = ~clk; 
    end

    // ---------------------------------------------------------
    // Stimulus Block
    // ---------------------------------------------------------
    initial begin
        // Initialize Inputs
        start = 0;
        rst = 1;

        // Apply Reset
        // Hold reset high for a few clock cycles to ensure 
        // the AGU and memory valid pipes initialize properly
        #15;  
        rst = 0;
        start = 1;
        #10;  

        // Trigger the FFT sequence
        // Send a single-cycle pulse to the 'start' signal
        $display("[%0t] Asserting start signal...", $time);
        start = 0;
        #20;
       

        // Wait for the FFT sequence to complete
        // The AGU will transition back to IDLE and assert fft_done
        $display("[%0t] Waiting for fft_done...", $time);
        wait(fft_done == 1'b1);
        
        // Add a small buffer after completion before ending the simulation
        #50;
        $display("[%0t] FFT Computation Completed Successfully!", $time);
        
        // Terminate simulation
        $finish;
    end

    // ---------------------------------------------------------
    // Optional: Monitor Signals
    // ---------------------------------------------------------
    // Uncomment the block below if you want to print state changes to the console
    /*
    initial begin
        $monitor("Time=%0t | rst=%b | start=%b | fft_done=%b", 
                 $time, rst, start, fft_done);
    end
    */

endmodule
