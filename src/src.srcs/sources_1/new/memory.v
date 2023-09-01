module dual_memory 
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 3
) 
(
    input clk,
    input rst,
    input [ADDR_WIDTH-1:0] w_addr,
    input [ADDR_WIDTH-1:0] r_addr,
    input [DATA_WIDTH-1:0] data_in,
    input wen,
    output [DATA_WIDTH-1:0] data_out
);

reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];   
integer i;

always @ (posedge clk, negedge rst)
begin
    if (!rst)
    begin
        for (i = 0; i < 2**ADDR_WIDTH; i = i + 1)
        begin
            mem[i] <= 0;
        end
    end

    else if (wen)
    begin
        mem[w_addr] <= data_in;
    end

end

assign data_out = mem[r_addr];

endmodule