module write_ctrl
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
) 
(
    input w_clk,
    input w_rst,
    input [ADDR_WIDTH:0] r_gray,
    input push,
    output full,
    output wen,
    output [ADDR_WIDTH-1:0] w_addr,
    output reg [ADDR_WIDTH:0] w_gray
);

reg [ADDR_WIDTH:0] w_addr_reg;

bin_to_gray BIN_TO_GRAY_w
#(
    .DATA_WIDTH(ADDR_WIDTH + 1)
)
bin_to_gray_inst (
    .bin(w_addr),
    .clk(w_clk),
    .rst(w_rst),
    .gray(w_gray)
);

always @ (posedge w_clk, negedge w_rst)
begin
    if (!w_rst)
        w_addr <= 0;

    else if (push && !full)
        w_addr <= w_addr + 1;
end

always @ (*)
begin
    full = 1'b0;

    if (w_gray[ADDR_WIDTH-1 : ADDR_WIDTH-2] ^ r_gray[ADDR_WIDTH-1 : ADDR_WIDTH-2] == 2'b11 && w_gray[ADDR_WIDTH-3 : 0] == r_gray[ADDR_WIDTH-3 : 0])
        full = 1'b1; 
end

assign wen = push && !full;

assign w_addr = w_addr_reg[ADDR_WIDTH-1 : 0];

endmodule