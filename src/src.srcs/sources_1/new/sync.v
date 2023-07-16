module sync 
#(
    parameter DATA_WIDTH = 32
) 
(
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out
);

genvar i;
generate
    for (i = 0; i < DATA_WIDTH; i = i + 1)
    begin: bit_sync
        sync_bit sync_bit_inst
        (
            .clk(clk),
            .rst(rst),
            .bit_in(data_in[i]),
            .bit_out(data_out[i])
        );
    end


endgenerate

    
endmodule