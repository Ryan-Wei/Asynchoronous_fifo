module write_ctrl
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)
(
    input w_clk,
    input w_rst,
    input [ADDR_WIDTH:0] r_gray,
    input push,
    output full,
    output wen,
    output [ADDR_WIDTH-1:0] w_addr,
    output [ADDR_WIDTH:0] w_gray
);

reg [ADDR_WIDTH:0] w_gray;
reg [ADDR_WIDTH:0] w_addr_reg;

bin_to_gray 
#(
    .DATA_WIDTH(ADDR_WIDTH + 1)
)
BIN_TO_GRAY_w
(
    .bin(w_addr),
    .clk(w_clk),
    .rst(w_rst),
    .gray(w_gray)
);

always @ (posedge w_clk, negedge w_rst)
begin
    if (!w_rst)
        w_addr_reg <= 0;

    else if (push && !full)
        w_addr_reg <= w_addr_reg + 1;
end


assign full = w_gray[ADDR_WIDTH-1 : ADDR_WIDTH-2] ^ r_gray[ADDR_WIDTH-1 : ADDR_WIDTH-2] == 2'b11 && w_gray[ADDR_WIDTH-3 : 0] == r_gray[ADDR_WIDTH-3 : 0];
assign wen = push && !full;
assign w_addr = w_addr_reg[ADDR_WIDTH-1 : 0];

endmodule