`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2019 17:11:28
// Design Name: 
// Module Name: vga_ctrl
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


module vga_ctrl(
    input clk_65M,
    input clear,
    output reg V_sync,
    output reg H_sync,
    output [16:0] H_cnt,
    output [16:0] V_cnt,
    output reg Vid_on
    );
    
    parameter HPIXELS =1344;
    parameter VLINES=806;
    parameter HBP=296;
    parameter HFP=1320;
    parameter VBP=35;
    parameter VFP=803;
    parameter HSP=136;
    parameter VSP=6;
    
    reg [16:0] H_count_reg, H_count_next;
    reg [16:0] V_count_reg, V_count_next;
    always @(posedge clk_65M)
    begin
    if(clear==1'b1)
    begin
            H_count_reg<= 17'd0;
            V_count_reg<=17'd0;
    end
    else
    begin
            H_count_reg<=H_count_next;
            V_count_reg<=V_count_next;
    end
    end
    
    always @(*)
    begin
        H_count_next=H_count_reg;
        if(H_count_reg==HPIXELS-1)
            H_count_next=17'd0;
        else 
            H_count_next=H_count_reg+1;
    end
    
    assign H_cnt = H_count_reg;
    
    always @(*)
    begin
      if( H_count_reg < HSP )
        H_sync=1'b0;
      else
        H_sync=1'b1; //reason
   end
    
    reg V_count_en;
    always @(*)
    begin
    if (H_count_reg==HPIXELS-1)
    V_count_en=1'b1;
    else 
    V_count_en=1'b0;
    end
   
    always @(*)
    begin
    V_count_next=V_count_reg;
    if (V_count_en)
    begin
        if(V_count_reg==VLINES-1)
        V_count_next=17'd0;
        else 
        V_count_next=V_count_reg+1;
        end
//    else 
//    begin
//    V_count_next=V_count_reg;
//    end
    end
    assign V_cnt=V_count_reg;
    
    always @(*)
    begin
        if( V_count_reg <VSP)
        V_sync=1'b0;
        else
        V_sync=1'b1; //reason
    end
        
   always @(*)
   begin
       if((H_count_reg>HBP) && (H_count_reg<HFP) && (V_count_reg>VBP) && (V_count_reg<VFP))
       Vid_on=1'b1;
       else
       Vid_on=1'b0;
   end
    
    
    
    
endmodule

