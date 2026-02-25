`timescale 1ns/1ps
import quant_pkg::*;

module fc_out #(
    parameter int NUM_MULT = 2
)(
    input  logic clk,
    input  logic rst_n,
    input  logic en,

    input  q_data_t    fc_in   [NUM_MULT],
    input  q_data_t    weights [NUM_MULT],
    input  q_data_t    bias,

    output logic       fc_out_valid,
    output q_data_t    fc_out
);

    (* use_dsp = "yes" *) logic signed [63:0] mult_res [NUM_MULT];
    logic signed [63:0] mult_res_tmp [NUM_MULT];
    logic signed [63:0] sum_comb;

    genvar i;
    generate
        for (i = 0; i < NUM_MULT; i++) begin : GEN_MULT
            assign mult_res[i]     = $signed(fc_in[i]) * $signed(weights[i]);
            assign mult_res_tmp[i] = (mult_res[i] >>> FRAC_WIDTH);
        end
    endgenerate

    integer k;
    always_comb begin
        sum_comb = {{64-Q_WIDTH{bias[Q_WIDTH-1]}}, bias};
        for (k = 0; k < NUM_MULT; k++)
            sum_comb = sum_comb + mult_res_tmp[k];
    end

    always_ff @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           fc_out       <= '0;
           fc_out_valid <= 1'b0;
       end
       else if (en) begin
          fc_out_valid <= 1'b1;
          if (sum_comb > SATURATION_H)
             fc_out <= LIMIT_H;
          else if (sum_comb < SATURATION_L)
             fc_out <= $signed(LIMIT_L);
          else
             fc_out <= sum_comb[Q_WIDTH:0];
       end
       else
          fc_out_valid <= 1'b0;
    end

endmodule
