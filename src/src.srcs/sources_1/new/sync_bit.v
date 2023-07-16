module sync_bit
(
    input clk,
    input rst,
    input bit_in,
    output reg bit_out
);

reg bit_out_reg;

always @ (posedge clk, negedge rst)
begin
    if (!rst)
    begin
        bit_out_reg <= 0;
    end

    else
    begin
        bit_out_reg <= bit_in;
    end
end

always @ (posedge clk, negedge rst)
begin
    if (!rst)
    begin
        bit_out <= 0;
    end

    else
    begin
        bit_out <= bit_out_reg;
    end
end
    
endmodule