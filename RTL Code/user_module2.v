
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2019 17:23:13
// Design Name: 
// Module Name: user_module1
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


module user_module2(
    input clk_10H,
    input timef,
    input reset,
    input d,
    output [6:0] seg_out1
    );
    reg [6:0] count_reg=0;
    reg [6:0] count_next=0;
   
    
    always @(posedge clk_10H )
    begin
    if(~d)
    count_reg<=0;
    else
     count_reg<=count_next;
    end


    
   always@(*)
    begin
    count_next=count_reg;
    if(count_reg==7'd50)
    count_next=count_reg;
    else
    count_next=count_reg+1;
    end
    
   assign seg_out1=count_reg;
   
   endmodule
    
