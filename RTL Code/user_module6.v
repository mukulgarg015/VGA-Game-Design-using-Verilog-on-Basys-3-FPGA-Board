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


module user_module6(
   input clk_1H,
   input reset,
   input endf,
   input [9:0] seg_out,
   output [3:0]seg_out6
   );
   reg [3:0] count_reg=0;
   
   reg [3:0] count_next=0;
   always @(posedge clk_1H or posedge reset)
   begin
   if (reset)
   count_reg<=0;
   else
   count_reg<=count_next;
   end
   always@(*)
   begin
   if (count_reg ==4'd8)
   count_next=0;
   else if (!endf && seg_out==10'd0)
   count_next=count_reg+1;

   end
  assign seg_out6=count_reg;
  endmodule
 