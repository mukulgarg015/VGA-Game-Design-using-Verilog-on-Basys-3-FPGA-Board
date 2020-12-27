`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2019 16:31:14
// Design Name: 
// Module Name: clk_div
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



/*module clk_div
#(parameter COUNT_DIV=100000)
(input reset,
input clk_in,
output clk_div
    );
    wire [22:0] count_next;
    reg [22:0] count_reg=0;
    always @(posedge clk_in)
    if (reset==1'b1)
    count_reg<=0;
    else
    count_reg<=count_next;*/
/*always @ (*)
begin
count_next=count_reg;
if(count_reg==COUNT_DIV-1)
count_next=0;
else
count_next=count_reg+1;
end*/
/*assign count_next=count_reg+1'b1;
assign clk_div=count_reg[COUNT_DIV];
endmodule*/


module clk_div
#(parameter COUNT_DIV=150000000)
(input clear,
input clk_in,
output reg clk_div
    );
    reg [40:0] count_next=0;
    reg [40:0] count_reg=0;
    reg clk_div_next;
    always @(posedge clk_in)
    if (clear==1'b1)
    count_reg<=0;
    else
    count_reg<=count_next;
    always @ (*)
        begin
            count_next=count_reg;
            if(count_reg==COUNT_DIV-1)
            count_next=0;
            else
            count_next=count_reg+1;
        end
    always @(posedge clk_in)
        if (clear==1'b1)
        clk_div<=1;
        else
        clk_div<=clk_div_next;
    always @(*) 
    begin
        clk_div_next=clk_div;
            if(count_reg==COUNT_DIV-1)
            clk_div_next=~clk_div;
    end
    
endmodule
