module read_ctrl 
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
) 
(
    input r_clk,
    input r_rst,
    input [ADDR_WIDTH:0] w_gray,
    input pop,
    output empty,
    output [ADDR_WIDTH-1:0] r_addr,
    output reg [ADDR_WIDTH:0] r_gray
);

reg [ADDR_WIDTH:0] r_addr_reg;

bin_to_gray BIN_TO_GRAY_r
#(
    .DATA_WIDTH(ADDR_WIDTH + 1)
)
bin_to_gray_inst (
    .bin(r_addr),
    .clk(r_clk),
    .rst(r_rst),
    .gray(r_gray)
);

always @ (posedge r_clk, negedge r_rst)
begin
    if (!r_rst)
        r_addr <= 0;

    else if (pop && !empty)
        r_addr <= r_addr + 1;
end

always @ (*)
begin
    empty = 1'b0;

    if(r_gray == w_gray)
        empty = 1'b1;
end

assign r_addr = r_addr_reg[ADDR_WIDTH-1 : 0];
    
endmodule