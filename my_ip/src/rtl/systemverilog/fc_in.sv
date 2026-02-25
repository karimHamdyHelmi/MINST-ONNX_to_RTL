`timescale 1ns/1ps
import quant_pkg::*;

module fc_in #(
   parameter int NUM_NEURONS = 8,
   parameter int INPUT_SIZE  = 16
)(
   input  logic                 clk,
   input  logic                 rst_n,

   input  logic                 in_valid,
   input  q_data_t              data_in,

   input  q_data_t              weights [NUM_NEURONS],
   input  q_data_t              bias    [NUM_NEURONS],

   output q_data_t              fc_out  [NUM_NEURONS],
   output logic                 out_valid
);

   acc_t mac_acc     [NUM_NEURONS];
   acc_t mac_acc_tmp [NUM_NEURONS];
   acc_t acc_tmp [NUM_NEURONS];
   acc_t bias_32 [NUM_NEURONS];

   logic [$clog2(INPUT_SIZE+1)-1:0] out_count;
   logic mac_enable;
   logic mac_clear;
   logic [NUM_NEURONS-1:0]mac_out_valid;
   logic all_mac_valid;

   genvar i;
   generate
      for (i = 0; i < NUM_NEURONS; i++) begin : FC_MACS
         mac mac_inst (
            .clk       (clk),
            .rst_n     (rst_n),
            .enable    (mac_enable),
            .clear     (mac_clear),
            .a         (data_in),
            .b         (weights[i]),
            .out_valid (mac_out_valid[i]),
            .acc       (mac_acc[i])
         );
      end
   endgenerate

   assign all_mac_valid = &mac_out_valid;
   
   always_ff @(posedge clk) begin
      if (!rst_n) begin
         out_count  <= '0;
         out_valid <= 1'b0;
      end else begin
         out_valid <= 1'b0;
         if (all_mac_valid) begin
            if (out_count == INPUT_SIZE-1) begin
               out_count  <= '0;
               out_valid <= 1'b1;
            end else begin
               out_count <= out_count + 1'b1;
            end
         end
      end
   end

   assign mac_enable = in_valid;
   assign mac_clear  = out_valid;

   generate
      for (i = 0; i < NUM_NEURONS; i++) begin : FC_BIAS_ADD
         assign mac_acc_tmp[i] = (mac_acc[i] >>> FRAC_WIDTH);
         assign bias_32[i] = {{32-Q_WIDTH{bias[i][Q_WIDTH-1]}}, bias[i]};
         assign acc_tmp[i] = mac_acc_tmp[i] + bias_32[i];
         always_ff @(posedge clk) begin
            if (!rst_n)
               fc_out[i] <= '0;
            else if (out_count == INPUT_SIZE-1)
               if (acc_tmp[i] > SATURATION_H)
                  fc_out[i] <= LIMIT_H;
               else if (acc_tmp[i] < SATURATION_L)
                  fc_out[i] <= $signed(LIMIT_L);
               else
                  fc_out[i] <= acc_tmp[i][Q_WIDTH:0];
         end
      end
   endgenerate

endmodule
