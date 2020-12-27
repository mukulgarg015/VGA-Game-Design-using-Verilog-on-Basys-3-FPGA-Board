`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2019 15:51:42
// Design Name: 
// Module Name: user_module7
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



module user_module7(
   input clk_1H,
   input reset,
   input endf,
   input [9:0] seg_out,
   output [4:0]seg_out7
   );
   reg [4:0] count_reg=5'd10;
   
   reg [4:0] count_next=5'd10;
   always @(posedge clk_1H or posedge reset)
   begin
   if (reset)
   count_reg<=5'd10;
   else
   count_reg<=count_next;
   end
   always@(*)
   begin
    if (count_reg ==5'd18)
   count_next=5'd10;
   else if (seg_out!=10'd0 && endf)
   count_next=count_reg+1;
 
   end
  assign seg_out7=count_reg;
  
endmodule
