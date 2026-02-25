`timescale 1ns / 1ps
import quant_pkg::*;

module relu_layer #(
   parameter int NUM_NEURONS = 8
)(
    input  logic         clk,
    input  logic         rst_n,
    input  logic         valid_in,
    input  q_data_t      data_in  [NUM_NEURONS],   

    output q_data_t      data_out [NUM_NEURONS],  
    output logic         valid_out
);

    logic valid_pipeline;
    integer i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            valid_pipeline <= 1'b0;
        else
            valid_pipeline <= valid_in;
    end

    assign valid_out = valid_pipeline;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_NEURONS; i++)
                data_out[i] <= '0;
        end
        else if (valid_in) begin
            for (i = 0; i < NUM_NEURONS; i++) begin
                if (data_in[i] < 0)
                    data_out[i] <= '0;
                else
                    data_out[i] <= data_in[i];
            end
        end
    end

endmodule
