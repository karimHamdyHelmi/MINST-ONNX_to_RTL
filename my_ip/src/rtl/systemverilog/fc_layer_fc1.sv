`timescale 1ns/1ps
import quant_pkg::*;

//------------------------------------------------------------------------------
// Module: fc_layer_fc1
// Description: Wrapper for fc1 FC layer with ROMs (rtl-style, q_data_t)
//------------------------------------------------------------------------------
module fc_layer_fc1 #(
    parameter int NUM_NEURONS   = 10,
    parameter int INPUT_SIZE    = 256
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        valid_in,
    input  q_data_t     input_data,
    output q_data_t     fc_out [NUM_NEURONS],
    output logic        valid_out
);

    logic [$clog2(INPUT_SIZE)-1:0] weight_addr;
    logic [NUM_NEURONS*Q_WIDTH-1:0] weight_row;
    logic [NUM_NEURONS*Q_WIDTH-1:0] bias_row;

    q_data_t weights [NUM_NEURONS];
    q_data_t bias    [NUM_NEURONS];

    genvar i;

    weight_rom_fc1 u_weight_rom (
        .addr(weight_addr),
        .data(weight_row)
    );

    bias_rom_fc1 u_bias_rom (
        .data(bias_row)
    );

    generate
        for (i = 0; i < NUM_NEURONS; i++) begin : WEIGHT_SLICE
            assign weights[i] = weight_row[i*Q_WIDTH +: Q_WIDTH];
        end
    endgenerate

    generate
        for (i = 0; i < NUM_NEURONS; i++) begin : BIAS_SLICE
            assign bias[i] = bias_row[i*Q_WIDTH +: Q_WIDTH];
        end
    endgenerate

    always_ff @(posedge clk) begin
        if (!rst_n)
            weight_addr <= '0;
        else if (valid_in) begin
            if (weight_addr == INPUT_SIZE-1)
                weight_addr <= '0;
            else
                weight_addr <= weight_addr + 1'b1;
        end
    end

    fc_in #(
        .NUM_NEURONS  (NUM_NEURONS),
        .INPUT_SIZE   (INPUT_SIZE)
    ) u_fc_in (
        .clk      (clk),
        .rst_n    (rst_n),
        .in_valid (valid_in),
        .data_in  (input_data),
        .weights  (weights),
        .bias     (bias),
        .fc_out   (fc_out),
        .out_valid(valid_out)
    );

endmodule
