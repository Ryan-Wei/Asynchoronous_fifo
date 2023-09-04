module write_ctrl
#(
    parameter ADDR_WIDTH = 32
)
(
    input w_clk,
    input w_rst,
    input [ADDR_WIDTH:0] r_gray,
    input push,
    output reg full,
    output wen,
    output [ADDR_WIDTH-1:0] w_addr,
    output reg [ADDR_WIDTH:0] w_gray
);

reg [ADDR_WIDTH : 0] w_bin;

wire [ADDR_WIDTH : 0] w_bin_next;
wire [ADDR_WIDTH : 0] w_gray_next;
wire full_next;


assign wen = push & ~full;
assign w_addr = w_bin[ADDR_WIDTH-1 : 0];

// generate next state
assign w_bin_next = w_bin + wen;

bin_to_gray // generate w_gray_next
#(
    .DATA_WIDTH(ADDR_WIDTH + 1)
)
BIN_TO_GRAY_w
(
    .bin(w_bin_next),
    .gray(w_gray_next)
);

/*
assign full = (w_gray[ADDR_WIDTH : ADDR_WIDTH-1] == ~r_gray[ADDR_WIDTH : ADDR_WIDTH-1]) 
            && (w_gray[ADDR_WIDTH-2 : 0] == r_gray[ADDR_WIDTH-2 : 0]);
simplified to:
*/
assign full_next = (w_gray_next == {~r_gray[ADDR_WIDTH : ADDR_WIDTH-1], r_gray[ADDR_WIDTH-2 : 0]});
// end generate next state


always @ (posedge w_clk, negedge w_rst)
begin
    if (!w_rst)
    begin
        w_bin <= 0;
        w_gray <= 0;
        full <= 0;
    end

    else
    begin
        w_bin <= w_bin_next;
        w_gray <= w_gray_next;
        full <= full_next;
    end
end


endmodule