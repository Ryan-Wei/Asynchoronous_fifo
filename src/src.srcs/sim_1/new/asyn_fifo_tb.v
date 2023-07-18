`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2023 07:55:53 PM
// Design Name: 
// Module Name: asyn_fifo_tb
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


module asyn_fifo_tb;


parameter FIFO_DEPTH = 8;
parameter DATA_WIDTH = 32;
parameter W_CLK_PERIOD = 100;
parameter R_CLK_PERIOD = 150;

reg                     w_clk;
reg                     w_rst;
reg [DATA_WIDTH-1:0]    w_data;
reg                     push;
reg                     r_clk;
reg                     r_rst;
reg                     pop;
wire [DATA_WIDTH-1:0]   r_data;


initial 
begin
    w_clk = 1'b0;
    w_rst = 1'b1;
    w_data = 32'h00000000;
    push = 1'b0;

    # 100;
    w_rst = 1'b0;

    # 100;
    w_rst = 1'b1;
    w_data = 32'h00000001;
    push = 1'b1;

end

initial
begin
    r_clk = 1'b0;
    r_rst = 1'b1;
    pop = 1'b0;

    # 100;
    r_rst = 1'b0;

    # 100;
    r_rst = 1'b1;
    pop = 1'b1;
    
end

always #(W_CLK_PERIOD * 1.7) w_data = w_data + 1'b1;

always #W_CLK_PERIOD w_clk = ~w_clk;
always #R_CLK_PERIOD r_clk = ~r_clk;


async_fifo_top
#(
    .FIFO_DEPTH(FIFO_DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
)
async_fifo_top_inst
(
    .w_clk(w_clk),
    .w_rst(w_rst),
    .w_data(w_data),
    .push(push),
    .r_clk(r_clk),
    .r_rst(r_rst),
    .r_data(r_data),
    .pop(pop)
);


endmodule
