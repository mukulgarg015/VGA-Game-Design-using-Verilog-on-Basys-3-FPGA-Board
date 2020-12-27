module user_module(
    input clk_65M,
    input clk_1H,
    input clk_10H,
    input reset,
    input game_on,
    input game_start,
    input pause,
    input endf,
    input timef,
    output [9:0] seg_out
   
    );
   
    reg [9:0] count_reg=10'd500;
    reg [9:0] count_next;
   
    reg [9:0] count_reg1=10'd520;
    reg [9:0] count_next1;
   
    reg [9:0] count_reg2;
     

   
    reg switch_reg,switch_next;
    always@(posedge clk_65M)
    begin
    switch_reg<=switch_next;
    end
   
    always @(*)
    begin
    switch_next=switch_reg;
    if(timef==1'b1)
    switch_next<=1'b1;
    else if(reset==1'b1 || game_start==1'b0)
    switch_next<=1'b0;
    end


     
    always@(*)
    begin
   
    if(switch_reg==1'b0)
    count_reg2=count_reg;
   
    else
    count_reg2=count_reg1;
   
    end
   
   
     
   
    always @(posedge clk_1H or posedge reset)
    begin
    if (reset || game_start==1'b0)
    count_reg1<=10'd520;
   
   
    else
    count_reg1<=count_next1;
    end
 
   always@(*)
    begin
    count_next1=count_reg1;
   
    if(pause || endf || count_reg1==10'd0)
    count_next1=count_reg1;
   
   
    else
    count_next1=count_reg1-1;
   
    end
   
   
   
   
    always @(posedge clk_1H or posedge reset)
    begin
    if (reset || game_start==1'b0)
    count_reg<=10'd500;
   
    else
    count_reg<=count_next;
    end
 
   always@(*)
    begin
    count_next=count_reg;
   
    if(pause || endf || count_reg==10'd0)
    count_next=count_reg;
 
    else
    count_next=count_reg-1;
   
    end
   
  assign seg_out=count_reg2;
 
   
   endmodule