`timescale 1ns/1ps

//------------------------------------------------------------------------------
// Module: weight_rom_fc1
// Description: Weight ROM for fc1 (quant_pkg format, packed per line)
//   - Depth: 256, each line = one packed word
//------------------------------------------------------------------------------
module weight_rom_fc1 #(
    parameter int ADDR_WIDTH = $clog2(256),
    parameter int DATA_WIDTH = 160
)(
    input  logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] data
);

    logic [DATA_WIDTH-1:0] mem [0:256-1];

    initial begin
        $readmemh("src/rtl/systemverilog/mem/fc1_weights_packed.mem", mem);
    end

    assign data = mem[addr];

endmodule
