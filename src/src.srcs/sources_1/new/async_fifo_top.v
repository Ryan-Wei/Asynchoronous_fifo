`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2023 03:24:27 PM
// Design Name: 
// Module Name: async_fifo_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module async_fifo_top
#(
    parameter FIFO_DEPTH = 8,
    parameter DATA_WIDTH = 32
)
(
    input w_clk,
    input w_rst,
    input [32-1:0] w_data,
    input push,

    input r_clk,
    input r_rst,
    output [32-1:0] r_data,
    input pop

);

parameter ADDR_WIDTH = $clog2(FIFO_DEPTH);

wire [ADDR_WIDTH-1:0] w_addr;
wire [ADDR_WIDTH-1:0] r_addr;
wire [ADDR_WIDTH : 0] w_gray;
wire [ADDR_WIDTH : 0] r_gray;
wire [ADDR_WIDTH : 0] w_gray_reg;
wire [ADDR_WIDTH : 0] r_gray_reg;
wire full;
wire empty;
wire wen;

dual_memory 
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
)
DUAL_MEMORY_inst
(
    .clk(w_clk),
    .rst(w_rst),
    .w_addr(w_addr),
    .r_addr(r_addr),
    .data_in(w_data),
    .wen(wen),
    .data_out(r_data)
);

write_ctrl 
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
)
WRITE_CTRL_inst
(
    .w_clk(w_clk),
    .w_rst(w_rst),
    .r_gray(r_gray_reg),
    .push(push),
    .full(full),
    .wen(wen),
    .w_addr(w_addr),
    .w_gray(w_gray)
);

read_ctrl 
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
)
READ_CTRL_inst
(
    .r_clk(r_clk),
    .r_rst(r_rst),
    .w_gray(w_gray_reg),
    .pop(pop),
    .empty(empty),
    .r_addr(r_addr),
    .r_gray(r_gray)
);

generate
    for (genvar i = 0; i <= ADDR_WIDTH; i = i + 1)
    begin
        sync_bit SYNC_BIT_inst
        (
            .clk(w_clk),
            .rst(w_rst),
            .bit_in(w_gray[i]),
            .bit_out(w_gray_reg[i])
        );
    end

    for (genvar i = 0; i <= ADDR_WIDTH; i = i + 1)
    begin
        sync_bit SYNC_BIT_inst
        (
            .clk(r_clk),
            .rst(r_rst),
            .bit_in(r_gray[i]),
            .bit_out(r_gray_reg[i])
        );
    end
endgenerate

endmodule
