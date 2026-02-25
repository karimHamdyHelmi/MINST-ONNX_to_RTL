`timescale 1ns/1ps

//------------------------------------------------------------------------------
// Module: bias_rom_fc1
// Description: Bias ROM (quant_pkg format - single packed line)
//------------------------------------------------------------------------------
module bias_rom_fc1 #(
    parameter int DATA_WIDTH = 160
)(
    output logic [DATA_WIDTH-1:0] data
);

    logic [DATA_WIDTH-1:0] mem [0:0];

    initial begin
        $readmemh("src/rtl/systemverilog/mem/fc1_biases.mem", mem);
    end

    assign data = mem[0];

endmodule
