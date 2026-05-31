`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 11:16:31 AM
// Design Name: 
// Module Name: agu
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


module agu(
    input start,
    input clk,
    input rst,
    input bfu_done,
    output fft_done,
    // output read_mem_select,
    output reg [2:0] twiddle_address,
    output reg [2:0] address_x,
    output reg [2:0] address_y,
    output reg valid_in,
    output read, write
);

    reg [2:0] present_state, next_state;
    reg [2:0] counter_done;
    reg read_delay_1;
    reg bfu_done_d1;

    wire trigger_read = (present_state == IDLE && start) || (bfu_done_d1 && !(present_state == STAGE_3 && counter_done == 3'd3));
   
    localparam IDLE = 3'b000,
        STAGE_1 = 3'b001,
        STAGE_2 = 3'b010,
        STAGE_3 = 3'b011;

    always@(*) begin
        next_state = present_state;
        case(present_state)
            IDLE: if (start) next_state = STAGE_1;
            STAGE_1: if(counter_done == 3'd3 && bfu_done_d1) next_state = STAGE_2;
            STAGE_2: if(counter_done == 3'd3 && bfu_done_d1) next_state = STAGE_3;
            STAGE_3: if(counter_done == 3'd3 && bfu_done_d1) next_state = IDLE;
        endcase
    end
    
    always@(posedge clk) begin
        if(rst) begin 
            present_state <= IDLE;
            counter_done <= 3'b000;
            // read <= 1'b0;
            // write <= 1'b0;
            // valid <= 1'b0;
        end
        else begin
            // write <= 1'b0;
            bfu_done_d1 <= bfu_done;
            if(bfu_done_d1) begin
                // write <= 1'b1;
                if(counter_done != 3'd3) begin 
                    counter_done <= counter_done + 1'b1;
                end
                else counter_done <= 3'd0;
            end
            present_state <= next_state;
        end
    end
    
    always@(*) begin

        case(present_state)
            STAGE_1: begin
                address_x       = counter_done << 1;
                address_y       = (counter_done << 1) + 1;
                twiddle_address = 0;
            end
        
            STAGE_2: begin
                address_x = {counter_done[1], 1'b0, counter_done[0]}; 
                address_y = {counter_done[1], 1'b1, counter_done[0]};
                twiddle_address = counter_done[0] << 1;
            end
             
            STAGE_3: begin
                address_x = counter_done;
                address_y = counter_done + 3'b100;
                twiddle_address = counter_done;
            end
                
            IDLE: begin 

                address_x = 3'b111;
                address_y = 3'b111;
                twiddle_address = 3'b111;
            end
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            read_delay_1 <= 1'b0;
            valid_in     <= 1'b0;
        end else begin
            read_delay_1 <= trigger_read;
            valid_in     <= read_delay_1; 
        end
    end
    
    assign read = read_delay_1;
    assign write = bfu_done_d1;
    assign fft_done = (next_state == IDLE & ~rst) ? 1'b1 : 1'b0;
        
endmodule
