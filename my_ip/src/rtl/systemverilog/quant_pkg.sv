`define Q_INT16
`ifndef Q_INT4
`ifndef Q_INT8
`ifndef Q_INT16
`define Q_INT16
`endif
`endif
`endif
package quant_pkg;

   `ifdef Q_INT4
      localparam int Q_WIDTH = 4;
   `elsif Q_INT8
      localparam int Q_WIDTH = 8;
   `elsif Q_INT16
      localparam int Q_WIDTH = 16;
   `endif
   
   `ifdef Q_INT4
      localparam int FRAC_WIDTH = 2;
   `elsif Q_INT8
      localparam int FRAC_WIDTH = 4;
   `elsif Q_INT16
      localparam int FRAC_WIDTH = 8;
   `endif
   
   `ifdef Q_INT4
      localparam int SATURATION_H = 32'sd7;
   `elsif Q_INT8
      localparam int SATURATION_H = 32'sd127;
   `elsif Q_INT16
      localparam int SATURATION_H = 32'sd32767;
   `endif
   
   `ifdef Q_INT4
      localparam int SATURATION_L = -32'sd8;
   `elsif Q_INT8
      localparam int SATURATION_L = -32'sd128;
   `elsif Q_INT16
      localparam int SATURATION_L = -32'sd32768;
   `endif
   
   `ifdef Q_INT4
      localparam int LIMIT_H = 4'sd7;
   `elsif Q_INT8
      localparam int LIMIT_H = 8'sd127;
   `elsif Q_INT16
      localparam int LIMIT_H = 16'sd32767;
   `endif
   
   `ifdef Q_INT4
      localparam int LIMIT_L = -4'sd8;
   `elsif Q_INT8
      localparam int LIMIT_L = -8'sd128;
   `elsif Q_INT16
      localparam int LIMIT_L = -16'sd32768;
   `endif
   
   typedef logic signed [Q_WIDTH-1:0]  q_data_t;
   typedef logic        [Q_WIDTH-1:0]  pred_t;
   typedef logic signed [31:0]         acc_t;

endpackage
