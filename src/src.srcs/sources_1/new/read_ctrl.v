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
    output [ADDR_WIDTH:0] r_gray
);


reg [ADDR_WIDTH:0] r_addr_reg;

bin_to_gray
#(
    .DATA_WIDTH(ADDR_WIDTH + 1)
)
BIN_TO_GRAY_r
(
    .bin(r_addr_reg),
    .gray(r_gray)
);

always @ (posedge r_clk, negedge r_rst)
begin
    if (!r_rst)
        r_addr_reg <= 0;

    else if (pop && !empty)
        r_addr_reg <= r_addr_reg + 1;
end

assign empty = r_gray == w_gray;
assign r_addr = r_addr_reg[ADDR_WIDTH-1 : 0];
    
endmodule