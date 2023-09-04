module bin_to_gray 
#(
    parameter DATA_WIDTH = 32
) 
(
    input [DATA_WIDTH-1:0] bin,
    output reg [DATA_WIDTH-1:0] gray
);

always @ (posedge clk, negedge rst)
begin
    if (!rst)
        gray <= 0;

    else
        gray <= bin ^ (bin >> 1);
end

endmodule