module read_ctrl 
#(
    parameter ADDR_WIDTH = 32
) 
(
    input r_clk,
    input r_rst,
    input [ADDR_WIDTH:0] w_gray,
    input pop,
    output reg empty,
    output [ADDR_WIDTH-1:0] r_addr,
    output reg [ADDR_WIDTH:0] r_gray
);


reg [ADDR_WIDTH : 0] r_bin;

wire [ADDR_WIDTH : 0] r_bin_next;
wire [ADDR_WIDTH : 0] r_gray_next;
wire empty_next;

assign r_addr = r_bin[ADDR_WIDTH-1 : 0];

// generate next state
assign r_bin_next = r_bin + (pop & ~empty);

bin_to_gray
#(
    .DATA_WIDTH(ADDR_WIDTH + 1)
)
BIN_TO_GRAY_r
(
    .bin(r_bin_next),
    .gray(r_gray_next)
);

assign empty_next = r_gray_next == w_gray;
// end generate next state


always @ (posedge r_clk, negedge r_rst)
begin
    if (!r_rst)
    begin
        r_bin <= 0;
        r_gray <= 0;
        empty <= 1;
    end

    else
    begin
        r_bin <= r_bin_next;
        r_gray <= r_gray_next;
        empty <= empty_next;
    end
end
    

endmodule