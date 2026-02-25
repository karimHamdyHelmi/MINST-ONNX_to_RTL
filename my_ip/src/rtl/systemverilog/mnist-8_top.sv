`timescale 1ns/1ps
import quant_pkg::*;

//------------------------------------------------------------------------------
// Module: mnist-8_top
// Description: Top-level module for mnist-8 neural network (rtl-style)
//   Uses quant_pkg, fc_in, relu_layer from embedded templates
//------------------------------------------------------------------------------
module mnist-8_top (
    // Input interface
    input  logic        clk,
    input  logic        rst_n,
    input  logic        in_valid,
    input  q_data_t     in_data,
    // Output interface
    output logic    out_valid,
    output q_data_t out_data [10]
);

    // fc1 layer signals
    logic      fc1_valid_out;
    q_data_t   fc1_out [10];

    logic      fc1_valid_in;
    q_data_t   fc1_data_in;


    assign fc1_valid_in = in_valid;
    assign fc1_data_in = in_data;

    // Output assignment
    assign out_valid = fc1_valid_out;
    assign out_data = fc1_out;

    // fc1 layer (fc_in style, quant_pkg format)
    fc_layer_fc1 #(
        .NUM_NEURONS  (10),
        .INPUT_SIZE   (256)
    ) u_fc1 (
        .clk       (clk),
        .rst_n     (rst_n),
        .valid_in  (fc1_valid_in),
        .input_data(fc1_data_in),
        .fc_out    (fc1_out),
        .valid_out (fc1_valid_out)
    );


endmodule
