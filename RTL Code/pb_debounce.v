`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 16:16:13
// Design Name: 
// Module Name: pb_debounce
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


module pb_debounce(
    input clk_250H,
    input inp_pb,
    output out_deb
    );
    reg FF1_reg,FF2_reg,FF3_reg;
    reg FF1_next,FF2_next,FF3_next;
    
    always @(posedge clk_250H)
    begin
    FF1_reg<=FF1_next;
    FF2_reg<=FF2_next;
    FF3_reg<=FF3_next;
    end
    
    always @(*)
    begin
    FF1_next=inp_pb;
    end
    
    always @(*)
    begin
    FF2_next=FF1_reg;
    end
    
    always @(*)
    begin
    FF3_next=FF2_reg;
    end
    
    assign out_deb=FF1_reg & FF2_reg & FF3_reg;
endmodule
