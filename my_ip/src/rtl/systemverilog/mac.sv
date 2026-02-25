`timescale 1ns/1ps
import quant_pkg::*;

module mac (
   input  logic clk,
   input  logic rst_n,
   input  logic enable,
   input  logic clear,

   input  q_data_t a,
   input  q_data_t b,

   output logic out_valid,
   output acc_t acc
);

   (* use_dsp = "yes" *) logic signed [63:0] mult_reg;
   logic signed [63:0] acc_reg;
   logic               enable_q;
   logic               enable_qq;

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         mult_reg <= '0;
      else if (enable)
         mult_reg <= $signed(a) * $signed(b);
   end

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         acc_reg <= '0;
      else if (clear)
         acc_reg <= '0;
      else if (enable)
         acc_reg <= acc_reg + mult_reg;
   end

   always_ff @(posedge clk) begin
      if (acc_reg > $signed(32'h7FFFFFFF))
         acc <= 32'h7FFFFFFF;
      else if (acc_reg < $signed(32'h80000000))
         acc <= 32'h80000000;
      else
         acc <= acc_reg[31:0];
   end
   
   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n)begin
         enable_q  <= 1'b0;
         enable_qq <= 1'b0;
         out_valid <= 1'b0;
      end
      else if (clear)begin
         enable_q  <= 1'b0;
         enable_qq <= 1'b0;
         out_valid <= 1'b0;
      end
      else if (enable)begin
         enable_q  <= enable;
         enable_qq <= enable_q;
         out_valid <= enable_qq;
      end
   end

endmodule
