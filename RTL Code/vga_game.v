`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2019 06:40:43 PM
// Design Name: 
// Module Name: vga_game
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


module vga_game(
    input clk_100M,
    input pause,
    input down,
    input up,
    input left,
    input right,
    input clk_65M,
    input clk_1H,
    input clear,
    input vid_on,
    input game_on,
    input game_start,
    input restart,
    input clk_10H,
    input clk_2H,
    input clk_50H,
    input [16:0] H_count,
    input [16:0] V_count,
    
    
    output reg [3:0] VGA_red,
    output reg [3:0] VGA_green,
    output reg [3:0] VGA_blue,
    
    //module definition for ball
    output wire [4:0]brom_ball_addr,
    input wire [0:19]brom_ball_data,
    
    //module definition for maze

    output wire [9:0] brom_maze_addr,
    input wire [0:699] brom_maze_data,
    
    
    //module definition for smileyhurdle

    output wire [5:0] brom_smiley_addr,
    input wire [0:24] brom_smiley_data,
    
 
    
    //module definition for count
    output reg [8:0] brom_counting_addr,
    input wire [0:31] brom_counting_data,
    
  
//intro screen
   output wire [9:0] brom_disp_addr , //intro screen
   input wire [0:265] brom_disp_data,
   
 // CHECK POST
   output reg [4:0] brom_check_addr , //intro screen
   input wire [0:24] brom_check_data,
   
    output wire [4:0] brom_ghost_addr , //intro screen
   input wire [0:24] brom_ghost_data,
   
   output reg [9:0] brom_letter_addr , //intro screen
   input wire [0:31] brom_letter_data,
   
     // Ports for timeplus brom
   output wire [4:0] brom_timeplus_addr,
   input wire [0:32] brom_timeplus_data,
 
   // Ports foe shield brom
   output wire [4:0] brom_shield_addr,
   input wire [0:32] brom_shield_data,
   
   output reg ghostf
   
//   output wire [9:0] end_addr ,  // game over screen
//   input wire [0:1023] end_data,
   
//    output wire [9:0] won_addr ,  // won screen
//   input wire [0:1023] won_data
    );
    
    parameter HPIXELS=1344; //PIXELS IN HORIZONTAL LINE
    parameter VLINES=806; //PIXELS IN VERTICAL LINE
    parameter HBP=296; //AT WHICH BACK PORCH ENDS
    parameter HFP=1320; //AT WHICH DISPLAY ENDS AND FRONT PORCH STARTS
    parameter VBP=35;
    parameter VFP=803;
    parameter HSP=136;
    parameter VSP=6;
    parameter HSCREEN=1024;
    parameter VSCREEN=768;
    parameter BALL_X_START=95;
    parameter BALL_Y_START=63;
    parameter BALL_SIZE=20;
//    parameter BALL_SIZE=20;
   parameter END_X_START=725;
   parameter END_Y_START=683 ;
   parameter END_X_SIZE= 32;
   parameter END_Y_SIZE= 32;

    parameter VELOCITY_SQ_DEFAULT=2;
    parameter MAZE_X_START=62;
    parameter MAZE_X_SIZE=699;
    parameter MAZE_Y_START=60;
    parameter MAZE_Y_SIZE=674;
    
    parameter COUNTING_X_START=5;
    parameter COUNTING_X_SIZE=27;
    parameter COUNTING_Y_START= 10;
    parameter COUNTING_Y_SIZE=31;
    parameter TIME1_X_START=578;
    parameter TIME1_Y_START=248;
    parameter TIME_SIZE=32;
    //smile display
    parameter SMILEY1_Y_START=543;
    parameter SMILEY1_X_START=765;
   
   //  FOR DISPLAY TIME COE
    parameter TIME2_X_START=765;
    parameter TIME2_Y_START=444;
//    parameter TIME2_SIZE=32;
   //SHIELD
    parameter SHIELD_X_START=364;
    parameter SHIELD_Y_START=87;
    parameter SHIELD_SIZE=32;
    // SHIELD COE
    parameter SHIELD1_X_START=765;
    parameter SHIELD1_Y_START=755;
//    parameter SHIELD1_SIZE=20;
    
    
    parameter MOVE_WITH_VEL=1000;
    parameter DISPLAY_XSTART=763;
    parameter DISPLAY_YSTART= 2;
    parameter DISPLAY_XSIZE= 266;
    parameter DISPLAY_YSIZE= 768;
    parameter SMILEY_Y_START=305;
    parameter SMILEY_X_START=95;
    parameter SMILEY_X_SIZE=25;
    parameter SMILEY_Y_SIZE=25;
    parameter CHECK_X_START1=203;
    parameter CHECK_Y_START1=525;
    parameter CHECK_X_START2=587;
    parameter CHECK_Y_START2=305;
    parameter CHECK_X_START3=532;
    parameter CHECK_Y_START3=579;
    parameter CHECK_XSIZE=24;
    parameter CHECK_YSIZE=24;
    
   parameter ghost_XSTART=370;
   parameter ghost_XSIZE=24;
   parameter ghost_YSTART=144;
   parameter ghost_YSIZE=24;
   
    wire refr_tick;
    assign refr_tick=((V_count==0)&&(H_count==0));
   
//refresh tick made 
    
//ball_on

reg sq_on;
wire [16:0] sq_xstart,sq_xstop,sq_ystart,sq_ystop;

always @(*)
begin
        if(((H_count>=sq_xstart+HBP)&&(H_count<HBP+sq_xstop))&&
        ((V_count>=sq_ystart+VBP)&&(V_count<VBP+sq_ystop)))
        sq_on=1;
        else
        sq_on=0;
end

// maze_on
reg maze_on;
always @(*)
begin
       if(((H_count>=MAZE_X_START+HBP)&&
        (H_count<HBP+MAZE_X_START +MAZE_X_SIZE ))
        &&((V_count>=MAZE_Y_START+VBP)&&
        (V_count<VBP+MAZE_Y_START+MAZE_Y_SIZE)))
        
        maze_on=1;
        else
        maze_on=0;
end

//smiley on
reg smiley_on;
reg smiley_on1;
always @(*)
begin
       if(((H_count>=SMILEY_X_START+HBP)&&
        (H_count<HBP+SMILEY_X_START +SMILEY_X_SIZE ))
        &&((V_count>=SMILEY_Y_START+VBP)&&
        (V_count<VBP+SMILEY_Y_START+SMILEY_Y_SIZE)))
        
        smiley_on=1;
        
         else
         begin
        smiley_on=0;
        
        end
end

reg timeplus_on;
reg timeplus_on2;
wire [16:0] move_xstart;
always @(*)
begin
       if((((H_count>=move_xstart+HBP)&&
        (H_count<HBP+move_xstart + TIME_SIZE ))
        &&((V_count>=TIME1_Y_START+VBP)&&
        (V_count<VBP+TIME1_Y_START+ TIME_SIZE)))  ) 
        
        timeplus_on=1;
       
         else
         begin
        timeplus_on=0;
       
        end
end

reg shield_on;
reg shield_on1;
wire [16:0] shield_xstart;
always @(*)
begin
       if((((H_count>=shield_xstart+HBP)&&
        (H_count<HBP+shield_xstart + SHIELD_SIZE ))
        &&((V_count>=SHIELD_Y_START+VBP)&&
        (V_count<VBP+SHIELD_Y_START+ SHIELD_SIZE)))  )
       
        shield_on=1;
  
         else
        shield_on=0;
       
end
    
wire [9:0]maze_pix;
reg path_on;
reg path;

 assign brom_maze_addr = V_count[9:0]-VBP[9:0]-MAZE_Y_START[9:0];
 assign maze_pix = H_count[9:0]-HBP[9:0]-MAZE_X_START[9:0];

  always @(*)
  begin
  path = brom_maze_data[maze_pix];
  if (path==1'b1)
  path_on=1'b1;
  else
  path_on=1'b0;
  end
 
 //end_on 
 reg end_on;
 always @(*)
begin
       if(((H_count>=END_X_START+HBP)&&
        (H_count<HBP+END_X_START +END_X_SIZE ))
        &&((V_count>=END_Y_START+VBP)&&
        (V_count<VBP+END_Y_START+END_Y_SIZE)))
        
        end_on=1;
         else
        end_on=0;
end
 
parameter END_X_START4=765;
parameter END_X_SIZE4=30;
parameter END_Y_START4=380;
parameter END_Y_SIZE4=30;
 
 
 // disp_on
   reg disp_on;
 always @(*)
begin
       if(((H_count>=DISPLAY_XSTART+HBP)&&
        (H_count<HBP+DISPLAY_XSTART +DISPLAY_XSIZE ))
        &&((V_count>=DISPLAY_YSTART+VBP)&&
        (V_count<VBP+DISPLAY_YSTART+DISPLAY_YSIZE)))
        
        disp_on=1;
         else
        disp_on=0;
end
  

  // checkposts
  reg check_on1;
  reg check_on2;
  reg check_on3;
 always @(*)
begin
       if(((H_count>=CHECK_X_START1+HBP)&&
        (H_count<HBP+CHECK_X_START1 +CHECK_XSIZE ))
        &&((V_count>=CHECK_Y_START1 +VBP)&&
        (V_count<VBP+CHECK_Y_START1 +CHECK_YSIZE)))
        begin
        check_on1=1;
        check_on2=0;
        check_on3=0;
        end
        
         else if (((H_count>=CHECK_X_START2+HBP)&&
        (H_count<HBP+CHECK_X_START2 +CHECK_XSIZE ))
        &&((V_count>=CHECK_Y_START2 +VBP)&&
        (V_count<VBP+CHECK_Y_START2 +CHECK_YSIZE)))
        begin
        check_on2=1;
        check_on1=0;
        check_on3=0;
        end
        
         else if (((H_count>=CHECK_X_START3+HBP)&&
        (H_count<HBP+CHECK_X_START3 +CHECK_XSIZE ))
        &&((V_count>=CHECK_Y_START3 +VBP)&&
        (V_count<VBP+CHECK_Y_START3 +CHECK_YSIZE)))
        begin
        check_on3=1;
        check_on1=0;
        check_on2=0;
        end
        
        else
        begin
        check_on1=0;
        check_on2=0;
        check_on3=0;
        end
        
     
        
        
end


////////////////////////////////

reg[16:0] sq_xstart_reg,sq_ystart_reg;

reg[16:0] sq_xstart_reg1,sq_ystart_reg1; // registors to hold the previous value
reg[16:0] sq_xstart_reg2,sq_ystart_reg2;

assign sq_xstart=sq_xstart_reg;
assign sq_xstop=sq_xstart+BALL_SIZE;
assign sq_ystart=sq_ystart_reg;
assign sq_ystop=sq_ystart+BALL_SIZE;


//fsm for position updation
reg[16:0] sq_xstart_next,sq_ystart_next;
always @(posedge clk_65M)
    begin
        if(clear==1)   //reset
         begin
            sq_xstart_reg<=BALL_X_START;
            sq_ystart_reg<=BALL_Y_START;
        end
else
    begin
        sq_xstart_reg<=sq_xstart_next;
        sq_ystart_reg<=sq_ystart_next;
    end
end

always@(posedge refr_tick)
    begin
   
        sq_xstart_reg1<=sq_xstart_reg;
        sq_ystart_reg1<=sq_ystart_reg;
       
        sq_xstart_reg2<=sq_xstart_reg1;
        sq_ystart_reg2<=sq_ystart_reg1;
   
     end

reg flag;
always@(*)
begin
if(sq_on==1'b1 && path_on==1'b0)
flag=1;
else
flag=0;
end

reg timef;
wire endf;
assign endf = (sq_xstart>=END_X_START && sq_xstop <= END_X_START + END_X_SIZE  && sq_ystart >= END_Y_START  && sq_ystop <=END_Y_START +END_Y_SIZE );


always @(*)
begin
if(sq_xstart>=move_xstart &&  sq_xstop<=(move_xstart + TIME_SIZE) &&  sq_ystart>=TIME1_Y_START  &&  sq_ystop<=(TIME1_Y_START + TIME_SIZE))
timef=1;
else
timef=0;
end

wire [9:0]seg_out;
user_module um2(.clk_1H(clk_1H),.clk_65M(clk_65M),.reset(clear),.clk_10H(clk_10H),.game_on(game_on),.timef(timef),
.game_start(game_start),.endf(endf),.pause(pause),.seg_out(seg_out));

//bcs conversion
wire [3:0]hundreds,tens, ones;
bin2bcd #(.N(9))
b1(.number(seg_out),.hundreds(hundreds),.tens(tens),.ones(ones));

reg[16:0] move_xstart_reg;
reg[16:0] move_xstart_next;
always @(posedge clk_10H or posedge clear)
    begin
        if(clear==1)   //reset
           move_xstart_reg<=TIME1_X_START;
        else
            move_xstart_reg<=move_xstart_next;
    end
    always @(*)
    begin
       move_xstart_next = move_xstart_reg;
    if( timef)
    	move_xstart_next = move_xstart_reg+MOVE_WITH_VEL;
     end
   
assign move_xstart=move_xstart_reg;

reg shield_flag;

wire [4:0]seg_out5;   
user_module5 um5(.clk_1H(clk_1H),.reset(clear),.game_start(game_start),.game_on(game_on),.seg_out5(seg_out5));
parameter DOWN= 47;
parameter GO_BACK= 4 ;
reg[16:0] sq_xstart_delta_reg,sq_ystart_delta_reg;

wire seg_out3;

parameter PADDLE_X_START4=765;
parameter PADDLE_X_SIZE4=35;
parameter PADDLE_Y_START4=480;
parameter PADDLE_Y_SIZE4=25;

reg paddle_on4;
always @(*)
begin
if(((H_count>=PADDLE_X_START4 + HBP)&&(H_count<PADDLE_X_SIZE4 +PADDLE_X_START4 +HBP))&&
        ((V_count>=PADDLE_Y_START4 + VBP)&&(V_count<PADDLE_Y_START4 + PADDLE_Y_SIZE4+ VBP)))
        paddle_on4=1;
        else
        paddle_on4=0;
end

 parameter PADDLE_X_START=198;
parameter PADDLE_X_SIZE=34;
parameter PADDLE_Y_START=63;
parameter PADDLE_Y_SIZE=25;

reg paddle_on;
wire [16:0] paddle_ystart,paddle_ystop;
always @(*)
begin
if(((H_count>=PADDLE_X_START + HBP)&&(H_count<PADDLE_X_SIZE+PADDLE_X_START +HBP))&&
        ((V_count>=paddle_ystart + VBP)&&(V_count<paddle_ystart+PADDLE_Y_SIZE+ VBP)))
        paddle_on=1;
        else
        paddle_on=0;
end
reg [16:0] paddle_Y_reg, paddle_Y_next;
assign paddle_ystart= paddle_Y_reg;
assign paddle_ystop= paddle_ystart+PADDLE_Y_SIZE;

reg game_fstop;
//fsm_for_paddle
always@(posedge clk_65M)
    begin
         if(clear == 1'b1)
            begin
                paddle_Y_reg <= PADDLE_Y_START+VBP;
            end
            else
                paddle_Y_reg <= paddle_Y_next; 
    end
//refresh tick made here
parameter VELOCITY_PADDLE_DEFAULT=2;

reg [16:0] paddle_Y_delta_reg,paddle_Y_delta_next;
always@(*)
    begin
            paddle_Y_next = paddle_Y_reg;
            
                
           if( pause==1'b1|| endf)
                paddle_Y_next= paddle_Y_reg;
                
            else if(refr_tick==1'b1)  //go down
                paddle_Y_next = paddle_Y_reg + paddle_Y_delta_reg;
              
           
    end
    
always @(posedge clk_65M)
begin
  
            paddle_Y_delta_reg <= paddle_Y_delta_next;
   
end



always@(*)
    begin
            paddle_Y_delta_next = paddle_Y_delta_reg;
            
            if(paddle_ystart<=MAZE_Y_START)  
                paddle_Y_delta_next = VELOCITY_PADDLE_DEFAULT;
            else if(paddle_ystop>=MAZE_Y_START+MAZE_Y_SIZE)  
                paddle_Y_delta_next = -VELOCITY_PADDLE_DEFAULT ;
                //paddle2
                //paddle2
                end
parameter PADDLE_X_START_1=650;
parameter PADDLE_X_SIZE_1=32;
parameter PADDLE_Y_START_1=710;
parameter PADDLE_Y_SIZE_1=25;

reg paddle_on_1;
wire [16:0] paddle_ystart_1,paddle_ystop_1;
always @(*)
begin
if(((H_count>=PADDLE_X_START_1 + HBP)&&(H_count<PADDLE_X_SIZE_1+PADDLE_X_START_1 +HBP))&&
        ((V_count>=paddle_ystart_1 + VBP)&&(V_count<paddle_ystart_1+PADDLE_Y_SIZE_1+ VBP)))
        paddle_on_1=1;
        else
        paddle_on_1=0;
end
reg [16:0] paddle_Y_reg_1, paddle_Y_next_1;
assign paddle_ystart_1= paddle_Y_reg_1;
assign paddle_ystop_1= paddle_ystart_1+PADDLE_Y_SIZE_1;


//fsm_for_paddle
always@(posedge clk_65M)
    begin
         if(clear == 1'b1)
            begin
                paddle_Y_reg_1 <= PADDLE_Y_START_1+VBP;
            end
            else
                paddle_Y_reg_1 <= paddle_Y_next_1; 
    end
//refresh tick made here
parameter VELOCITY_PADDLE_DEFAULT_1=2;
reg [16:0] paddle_Y_delta_reg_1,paddle_Y_delta_next_1;
always@(*)
    begin
            paddle_Y_next_1 = paddle_Y_reg_1;
            
                
           if( pause==1'b1||endf)
                paddle_Y_next_1= paddle_Y_reg_1;
                
          
                
            else if(refr_tick==1'b1)  //go down
                paddle_Y_next_1 = paddle_Y_reg_1 + paddle_Y_delta_reg_1;
              
           
    end
    
always @(posedge clk_65M)
begin
  
            paddle_Y_delta_reg_1 <= paddle_Y_delta_next_1;
   
end



always@(*)
    begin
            paddle_Y_delta_next_1 = paddle_Y_delta_reg_1;
            
            if(paddle_ystart_1<=MAZE_Y_START)  
                paddle_Y_delta_next_1 = VELOCITY_PADDLE_DEFAULT_1;
            else if(paddle_ystop_1>=MAZE_Y_START+MAZE_Y_SIZE)  
                paddle_Y_delta_next_1 = - VELOCITY_PADDLE_DEFAULT_1 ;
                  
    end
    //paddle1_end
    //horizontal_paddle
//paddle2
parameter PADDLE_X_START_2=66;
parameter PADDLE_X_SIZE_2=32;
parameter PADDLE_Y_START_2=223;
parameter PADDLE_Y_SIZE_2=25;

reg paddle_on_2;
wire [16:0] paddle_xstart_2,paddle_xstop_2;
always @(*)
begin
if(((H_count>=paddle_xstart_2+HBP)&&(H_count<PADDLE_X_SIZE_2+paddle_xstart_2+HBP))&&
        ((V_count>=PADDLE_Y_START_2+ VBP)&&(V_count<PADDLE_Y_START_2+PADDLE_Y_SIZE_2+ VBP)))
        paddle_on_2=1;
        else
        paddle_on_2=0;
end
reg [16:0] paddle_X_reg_2, paddle_X_next_2;
assign paddle_xstart_2= paddle_X_reg_2;
assign paddle_xstop_2= paddle_xstart_2+PADDLE_X_SIZE_2;


//fsm_for_paddle
always@(posedge clk_65M)
    begin
         if(clear == 1'b1)
            begin
                paddle_X_reg_2 <= PADDLE_X_START_2+HBP;
            end
            else
                paddle_X_reg_2 <= paddle_X_next_2; 
    end
//refresh tick made here
parameter VELOCITY_PADDLE_DEFAULT_2=2;
reg [16:0] paddle_X_delta_reg_2,paddle_X_delta_next_2;
always@(*)
    begin
            paddle_X_next_2 = paddle_X_reg_2;
            
                
           if( pause==1'b1||endf)
                paddle_X_next_2= paddle_X_reg_2;
                
          
                
            else if(refr_tick==1'b1)  //go down
                paddle_X_next_2 = paddle_X_reg_2 + paddle_X_delta_reg_2;
              
           
    end
    
always @(posedge clk_65M)
begin
  
            paddle_X_delta_reg_2 <= paddle_X_delta_next_2;
   
end



always@(*)
    begin
            paddle_X_delta_next_2 = paddle_X_delta_reg_2;
            
            if(paddle_xstart_2<=MAZE_X_START)  
                paddle_X_delta_next_2 = VELOCITY_PADDLE_DEFAULT_2;
            else if(paddle_xstop_2>=MAZE_X_START+MAZE_X_SIZE)  
                paddle_X_delta_next_2 = - VELOCITY_PADDLE_DEFAULT_2 ;
                  
    end
    //horizontal 
    //paddle3
    //horizontal_paddle
//paddle3
parameter PADDLE_X_START_3=580;
parameter PADDLE_X_SIZE_3=30;
parameter PADDLE_Y_START_3=575;
parameter PADDLE_Y_SIZE_3=25;

reg paddle_on_3;
wire [16:0] paddle_xstart_3,paddle_xstop_3;
always @(*)
begin
if(((H_count>=paddle_xstart_3+HBP)&&(H_count<PADDLE_X_SIZE_3+paddle_xstart_3+HBP))&&
        ((V_count>=PADDLE_Y_START_3+ VBP)&&(V_count<PADDLE_Y_START_3+PADDLE_Y_SIZE_3+ VBP)))
        paddle_on_3=1;
        else
        paddle_on_3=0;
end
reg [16:0] paddle_X_reg_3, paddle_X_next_3;
assign paddle_xstart_3= paddle_X_reg_3;
assign paddle_xstop_3= paddle_xstart_3+PADDLE_X_SIZE_3;


//fsm_for_paddle
always@(posedge clk_65M)
    begin
         if(clear == 1'b1)
            begin
                paddle_X_reg_3 <= PADDLE_X_START_3+HBP;
            end
            else
                paddle_X_reg_3 <= paddle_X_next_3; 
    end
//refresh tick made here
parameter VELOCITY_PADDLE_DEFAULT_3=3;
reg [16:0] paddle_X_delta_reg_3,paddle_X_delta_next_3;
always@(*)
    begin
            paddle_X_next_3 = paddle_X_reg_3;
            
                
           if( pause==1'b1|| endf)
                paddle_X_next_3= paddle_X_reg_3;
                
          
                
            else if(refr_tick==1'b1)  //go down
                paddle_X_next_3 = paddle_X_reg_3 + paddle_X_delta_reg_3;
              
           
    end
    
always @(posedge clk_65M)
begin
  
            paddle_X_delta_reg_3 <= paddle_X_delta_next_3;
   
end



always@(*)
    begin
            paddle_X_delta_next_3 = paddle_X_delta_reg_3;
            
            if(paddle_xstart_3<=MAZE_X_START)  
                paddle_X_delta_next_3 = VELOCITY_PADDLE_DEFAULT_3;
            else if(paddle_xstop_3>=MAZE_X_START+MAZE_X_SIZE)  
                paddle_X_delta_next_3 = - VELOCITY_PADDLE_DEFAULT_3 ;
                  
    end
    
            
           
 
   parameter cord_ystart=142;
   parameter cord_ystop=170;
   parameter cord_xstart=420;
   parameter cord_xstop=712;
   parameter CHECK_X_START=214;
   parameter CHECK_Y_START=200;
    always @(*)
    begin
    if(sq_ystop>cord_ystart&&sq_ystop<cord_ystop&&sq_xstart>cord_xstart&&sq_xstop<cord_xstop)
    ghostf=1;
    else
    ghostf=0;
      end

   wire[16:0]ghost_xstart,ghost_xstop,ghost_ystart,ghost_ystop;
   
    reg ghost_on;
    reg ghost_on1;
   parameter VELOCITY_GHOST_DEFAULT=2;
   parameter DEFAULT_VELOCITY=1000;
  always @(*)
begin
       if(((H_count>=ghost_xstart+HBP)&&
        (H_count<HBP+ghost_xstart +ghost_XSIZE ))
        &&((V_count>=ghost_YSTART+VBP)&&
        (V_count<VBP+ghost_YSTART+ghost_YSIZE)))
        
        ghost_on=1;
        
       
         else
         begin
        ghost_on=0;
      
        end
end

reg[16:0]ghost_xstart_reg;
assign ghost_xstart=ghost_xstart_reg;
assign ghost_xstop=ghost_xstart+ghost_XSIZE;
reg[16:0] ghost_velocity_reg = VELOCITY_GHOST_DEFAULT;


//fsm for position updation
reg[16:0] ghost_xstart_next,ghost_ystart_next;
always @(posedge clk_65M)
    begin
        if(clear==1)   //reset
         begin
            ghost_xstart_reg<=ghost_XSTART;
        end
       else
    begin
        ghost_xstart_reg<=ghost_xstart_next;
    end
end
always @(*)
    begin
        ghost_xstart_next = ghost_xstart_reg;
             
       if(pause==1'b1 && ghostf)
        ghost_xstart_next = ghost_xstart_reg;
       else if((ghost_xstop>=sq_xstart)&& ghostf)
       ghost_xstart_next = ghost_XSTART;
//       else if (ghostf && ghost_off)
//        ghost_xstart_next = ghost_xstart_reg+DEFAULT_VELOCITY;
       else if(refr_tick==1'b1 && ghostf)  //go down
        ghost_xstart_next = ghost_xstart_reg + ghost_velocity_reg;
                 
    end
   
   

    
wire [4:0] brom_ghost_pix;
reg ghostp;

assign brom_ghost_addr = V_count[4:0] - VBP[4:0] - ghost_YSTART;
assign brom_ghost_pix = H_count[4:0] - HBP[4:0] - ghost_XSTART;


//x direction
always @(*)
    begin
        sq_xstart_next = sq_xstart_reg;
             
       if(pause==1'b1 || endf==1'b1 || seg_out==10'd0)
        sq_xstart_next = sq_xstart_reg;
        
       else if (game_start==1'b0)
       sq_xstart_next = BALL_X_START;
        
         else if((ghost_xstop>=sq_xstart)&& ghostf)
      sq_xstart_next = CHECK_X_START;
        
       
       else if (seg_out3==1'b0 && sq_on && smiley_on)
       sq_xstart_next = BALL_X_START;
        
         else if (sq_on && (paddle_on==1||paddle_on_1==1||paddle_on_2||paddle_on_3))
             sq_xstart_next = BALL_X_START;
//       else if (refr_tick && (left || right))
//      sq_xstart_next = sq_xstart_reg + sq_xstart_delta_reg  ;
          
          else if( (refr_tick==1'b1)&&(left==1'b1))
         
       sq_xstart_next = sq_xstart_reg - 2 ;
       
       else if( (refr_tick==1'b1)&&(right==1'b1))
         
       sq_xstart_next = sq_xstart_reg + 2  ;
       
       
       else if(flag && ~shield_flag)
       sq_xstart_next= BALL_X_START;
       
       else if(flag && shield_flag)
       sq_xstart_next=sq_xstart_reg2; // go to saved state only if shield flag==1 else go to start
    end
    
    
    
//y direction
always @(*)
    begin
    sq_ystart_next = sq_ystart_reg;

    if(pause==1'b1 || endf==1'b1 || seg_out==10'd0)
    sq_ystart_next = sq_ystart_reg;
    
    else if (game_start==1'b0)
    sq_ystart_next = BALL_Y_START; 
    
     else if((ghost_xstop>=sq_xstart)&& ghostf)
      sq_ystart_next = CHECK_Y_START;
      
    
    else if (seg_out3==1'b0 && sq_on && smiley_on)
    sq_ystart_next = BALL_Y_START; 
    
   
    
    else if ((sq_xstart>=CHECK_X_START1 && sq_xstop<CHECK_X_START1 +CHECK_XSIZE && sq_ystart>=CHECK_Y_START1 && sq_ystop<CHECK_Y_START1 + CHECK_YSIZE && seg_out5>=0 && seg_out5<10) 
    ||(sq_xstart>=CHECK_X_START2 && sq_xstop<CHECK_X_START2 +CHECK_XSIZE && sq_ystart>=CHECK_Y_START2 && sq_ystop<CHECK_Y_START2 + CHECK_YSIZE && seg_out5>=10 && seg_out5<20) ||
    (sq_xstart>=CHECK_X_START3 && sq_xstop<CHECK_X_START3 +CHECK_XSIZE && sq_ystart>=CHECK_Y_START3 && sq_ystop<CHECK_Y_START3 + CHECK_YSIZE && seg_out5>=20 && seg_out5<30))
    sq_ystart_next = sq_ystart_reg + DOWN; 
      
//    else if (refr_tick &&(up==1'b1||down==1'b1) )
//    sq_ystart_next = sq_ystart_reg + sq_ystart_delta_reg;
    
    else if( (refr_tick==1'b1)&&(up==1'b1))
         
       sq_ystart_next = sq_ystart_reg - 2 ;
       
       
        else if((refr_tick==1'b1)&&(down==1'b1))
         
       sq_ystart_next = sq_ystart_reg + 2  ;
       

        else if(flag && ~shield_flag)
        sq_ystart_next= BALL_Y_START;
       
        else if(flag && shield_flag)
        sq_ystart_next= sq_ystart_reg2;
        
        else if (sq_on && (paddle_on==1||paddle_on_1==1||paddle_on_2||paddle_on_3))
          sq_ystart_next= BALL_Y_START;   
    
   

    end

// fsm for shield power
   
   
    reg[16:0] shield_xstart_reg;
    reg[16:0] shield_xstart_next;
   


// shlied_move_flag=1 when shield and player overlap
reg move_shield_flag;
always @(*)
begin

if(sq_xstart>=shield_xstart &&  sq_xstop<=(shield_xstart + SHIELD_SIZE) &&  sq_ystart>=SHIELD_Y_START  &&  sq_ystop<=(SHIELD_Y_START + SHIELD_SIZE))
move_shield_flag=1;
else
move_shield_flag=0;
end



// To make power disappear
   
always @(posedge clk_10H or posedge clear)
    begin
        if(clear==1)   //reset
           shield_xstart_reg<=SHIELD_X_START;
        else
            shield_xstart_reg<=shield_xstart_next;
    end
    always @(*)
    begin
       shield_xstart_next = shield_xstart_reg;
    if( move_shield_flag )
    shield_xstart_next = shield_xstart_reg+MOVE_WITH_VEL;
     end
     
assign shield_xstart=shield_xstart_reg;

// deriving constant signal for counter from move_shield_flag

reg const_signal_reg,const_signal_next;
    always@(posedge clk_65M)
    begin
    const_signal_reg<=const_signal_next;
    end
   
    always @(*)
    begin
    const_signal_next=const_signal_reg;
    if(move_shield_flag==1'b1)
    const_signal_next<=1'b1;
    else if(clear==1'b1 || game_start==1'b0)
    const_signal_next<=1'b0;
    end


// starting the counter when shield power disappear to create flag for wall hold stop
   
    reg [9:0] count_reg;
    reg [9:0] count_next;
   
    always @(posedge clk_1H or posedge clear)
    begin
    if (clear || game_start==1'b0)
    count_reg<=0;
   
    else
    count_reg<=count_next;
    end
 
   always@(*)
    begin
    count_next=count_reg;
   
    if(pause || endf)
    count_next=count_reg;
   
   
    else if(const_signal_reg)
    count_next=count_reg+1;
   
    end
   
    // shield flag is 1 when counter counts from 0 to 10
   
    always@(*)
    begin
    if(count_reg>10'd0 && count_reg<10'd900)
    shield_flag=1;
    else
    shield_flag=0;
    end
 

 


//// timer_on

//// timer

// blinking smiley counter


user_module3 i3(.clk_1H(clk_1H),.reset(clear),.seg_out3(seg_out3));
 
reg smiley;
wire [4:0]brom_smiley_pix;
 

assign brom_smiley_addr=V_count[5:0]-VBP[5:0]-SMILEY_Y_START[5:0] + seg_out3 *  25;

assign brom_smiley_pix=H_count[4:0]-HBP[4:0]-SMILEY_X_START[4:0];


wire [2:0] seg_out4;

user_module4 i4(.clk_1H(clk_10H),.reset(clear),.seg_out4(seg_out4));
 
 ////Adding Round Ball //////
 //RMB5
 reg ball;
 wire [4:0]rom_ball_pix;
 assign brom_ball_addr = V_count[4:0]-VBP[4:0]-sq_ystart[4:0];
 assign rom_ball_pix = H_count[4:0]-HBP[4:0]-sq_xstart[4:0];


reg counting_on1; 
reg counting_on2; 
reg counting_on3;

always@(*)
    begin
        if(((H_count>=COUNTING_X_START+HBP)&&
        (H_count<HBP+COUNTING_X_START + COUNTING_X_SIZE))
        &&((V_count>=COUNTING_Y_START+VBP)&&
        (V_count<VBP+COUNTING_Y_START+COUNTING_Y_SIZE)))
        
        counting_on1=1;
        
        else if(((H_count>=COUNTING_X_START+COUNTING_X_SIZE+HBP)&&
        (H_count<HBP+COUNTING_X_START + COUNTING_X_SIZE + COUNTING_X_SIZE))
        &&((V_count>=COUNTING_Y_START+VBP)&&
        (V_count<VBP+COUNTING_Y_START+COUNTING_Y_SIZE)))
        
        counting_on2=1;
        
         else if(((H_count>=COUNTING_X_START+COUNTING_X_SIZE+COUNTING_X_SIZE+HBP)&&
        (H_count<HBP+COUNTING_X_START + COUNTING_X_SIZE + COUNTING_X_SIZE + COUNTING_X_SIZE))
        &&((V_count>=COUNTING_Y_START+VBP)&&
        (V_count<VBP+COUNTING_Y_START+COUNTING_Y_SIZE)))
        
        
        counting_on3=1;
        
        else 
        begin
        counting_on1=0;
        counting_on2=0;
        counting_on3=0;
        end
       end
       
wire [16:0] rom_counting_addr  ; 
reg [16:0] rom_counting_pix; 
reg counting;

assign rom_counting_addr=V_count[4:0] - VBP[4:0] - COUNTING_Y_START;
always @(*)
begin
if(counting_on3)
brom_counting_addr = rom_counting_addr[4:0] + ones*32;
else if (counting_on2)
brom_counting_addr = rom_counting_addr[4:0] + tens*32;
else if(counting_on1)
brom_counting_addr = rom_counting_addr[4:0] + hundreds*32;
end

always @(*)
begin
if(counting_on3)
rom_counting_pix = H_count[4:0] - HBP[4:0] - COUNTING_X_START - COUNTING_X_SIZE - COUNTING_X_SIZE ;
else if (counting_on2)
rom_counting_pix = H_count[4:0] - HBP[4:0] - COUNTING_X_START - COUNTING_X_SIZE ;
else if(counting_on1)
rom_counting_pix =H_count[4:0] - HBP[4:0] - COUNTING_X_START ;
end


wire [8:0] brom_disp_pix;
reg display;

assign brom_disp_addr = V_count[9:0] - VBP[9:0] - DISPLAY_YSTART;
assign brom_disp_pix = H_count[8:0] - HBP[8:0] - DISPLAY_XSTART;
//////////////////////////////////////////////////////////////////////////////



reg [4:0] brom_check_pix; 
reg post;
always @ (*)
begin
if (check_on1  && seg_out5>=0 && seg_out5<10)
brom_check_addr = V_count[4:0] - VBP[4:0] - CHECK_Y_START1;
else if (check_on2 && seg_out5>=10 && seg_out5<20)
brom_check_addr = V_count[4:0] - VBP[4:0] - CHECK_Y_START2;
else if (check_on3 && seg_out5>=20 && seg_out5<30)
brom_check_addr = V_count[4:0] - VBP[4:0] - CHECK_Y_START3;
end

always @(*)
begin
if(check_on1 && seg_out5>=0 && seg_out5<10)
brom_check_pix = H_count[4:0] - HBP[4:0] - CHECK_X_START1 ;
else if (check_on2 && seg_out5>=10 && seg_out5<20)
brom_check_pix = H_count[4:0] - HBP[4:0] - CHECK_X_START2 ;
else if(check_on3  && seg_out5>=20 && seg_out5<30)
brom_check_pix =H_count[4:0] - HBP[4:0] - CHECK_X_START3 ;
end


//////////////////////////////////
wire [3:0] seg_out6;
  wire [4:0] seg_out7;
  wire [3:0] ones6,ones7;
//gamestop
user_module6 u1(.clk_1H(clk_50H),.reset(clear),.endf(endf),.seg_out(seg_out),.seg_out6(seg_out6));


user_module7 u2 (.clk_1H(clk_50H),.reset(clear),.endf(endf),.seg_out(seg_out),.seg_out7(seg_out7));



reg endx_on;

parameter END_X_START1=400;
parameter END_X_SIZE1=31;
parameter END_Y_START1=15;
parameter END_Y_SIZE1=31;

always@(*)
    begin

 if(((H_count>=END_X_START1+ seg_out6*END_X_SIZE1 +(seg_out7- 5'd10) * END_X_SIZE1 +  + HBP)&&
        (H_count<HBP + END_X_START1 + seg_out6*END_X_SIZE1 + (seg_out7 - 5'd10)* END_X_SIZE1 +   END_X_SIZE1))
        &&((V_count>=END_Y_START1+VBP)&&
        (V_count<VBP+END_Y_START1+ END_Y_SIZE1)))
       
        endx_on=1;
        else
        endx_on=0;
       end
       
wire [16:0] rom_letter_addr  ;
reg [16:0] rom_letter_pix;
reg letter;

assign rom_letter_addr= V_count[9:0] - VBP[9:0] - END_Y_START1[9:0];

always @(*)
begin
if(seg_out==10'd0 && endf!=1'b1)
brom_letter_addr= rom_letter_addr[9:0] + seg_out6*32 ;
else if (seg_out!=10'd0 && endf)
brom_letter_addr= rom_letter_addr[9:0] + seg_out7 * 32 ;
end

always @(*)
begin
if (seg_out==10'd0 && endf!=1'b1)
rom_letter_pix=H_count[4:0] - HBP[4:0] - END_X_START1[4:0]- seg_out6*END_X_SIZE1 ;
else if (seg_out!=10'd0 && endf)
rom_letter_pix=H_count[4:0] - HBP[4:0] - END_X_START1[4:0]- (seg_out7-5'd10)*END_X_SIZE1 ;
end

/////////////////////////////////////////
 reg timeplus;
wire [4:0] rom_timeplus_pix;

assign brom_timeplus_addr = V_count[4:0]-VBP[4:0]-TIME1_Y_START[4:0];
assign rom_timeplus_pix = H_count[4:0]-HBP[4:0]-move_xstart[4:0];

reg shield;
wire [4:0] rom_shield_pix;
assign brom_shield_addr = V_count[4:0]-VBP[4:0]-SHIELD_Y_START[4:0];
assign rom_shield_pix = H_count[4:0]-HBP[4:0]-shield_xstart[4:0];


//////color////

always @(*)
    begin
        VGA_red=4'b0000;
        VGA_green=4'b0000;
        VGA_blue=4'b0000;
 if (vid_on==1 && game_start && endx_on && ((seg_out==10'd0 && !endf) || (seg_out!=10'd0 && endf)) )
         begin
         letter= brom_letter_data[rom_letter_pix];
         if (letter)
         begin
          VGA_red=4'b1111;
          VGA_green=4'b1111;
          VGA_blue=4'b1111;
           end
           else
           begin
            VGA_red=4'b0000;
          VGA_green=4'b0111;
          VGA_blue=4'b0000;  
         end
         end
   
 
    
    else if (vid_on==1 &&  game_on==1'b1 && disp_on==1'b1 && maze_on==1'b0  )
        begin
         display = brom_disp_data[brom_disp_pix];
            if(display==1'b1)
            begin
            VGA_red=4'b0000;
            VGA_green=4'b0000;
            VGA_blue=4'b0000;
            end
        
            else
             begin
             VGA_red=4'b0000;
             VGA_green=4'b0111;
             VGA_blue=4'b0000;
            end
            end
 else if (vid_on==1 &&  game_on==1'b1  && maze_on && ghost_on==1'b1 && ghostf) 
        begin
         ghostp = brom_ghost_data[brom_ghost_pix];
            if(ghostp==1'b1)
            begin
            VGA_red=4'b0000;
            VGA_green=4'b0000;
            VGA_blue=4'b0000;
            end
           else
            begin
            VGA_red=4'b0000;
            VGA_green=4'b0111;
            VGA_blue=4'b0000;
            end
      end    
         
            

          
    else if (vid_on==1 && game_start==1 && game_on==1 && paddle_on==1  && maze_on)
           begin
            VGA_red=4'b1111;
            VGA_green=4'b1111;
            VGA_blue=4'b0000;
          end
    else if(vid_on==1&&game_on==1&&(paddle_on==1||paddle_on_1==1||paddle_on_2||paddle_on_3)&& game_start && maze_on)
      begin
     VGA_red=4'b1111;
     VGA_green=4'b1111;
     VGA_blue=4'b0000;
     end     
    
//    else if (vid_on==1 && game_on==1 && path_on==1'b1 && timeplus_on==1)// time booster colour
//     begin
//     VGA_red=4'b0000;
//     VGA_green=4'b1111;
//     VGA_blue=4'b1111; 
//     end  

  else if (vid_on==1 && game_on==1 && path_on==1'b1 && timeplus_on==1)// time booster colour
    begin
   
    timeplus=brom_timeplus_data[rom_timeplus_pix];
   
    if(timeplus==1'b0)
               begin
               VGA_red=4'b0000;
               VGA_green=4'b0111;
               VGA_blue=4'b0000;
               end
    else if(timeplus==1'b1)
               begin
                   VGA_red=4'b0000;
                   VGA_green=4'b0000;
                   VGA_blue=4'b0100;
               end
      end
             
             
     
//     else if (vid_on==1 && game_on==1 && path_on==1'b1 && shield_on==1)// shield booster colour
//     begin
//     VGA_red=4'b1110;
//     VGA_green=4'b0110;
//     VGA_blue=4'b0000;
//     end

  else if (vid_on==1 && game_on==1 && path_on==1'b1 && shield_on==1)// shield colour
    begin
   
    shield=brom_shield_data[rom_shield_pix];
   
    if(shield==1'b0)
               begin
               VGA_red=4'b0000;
               VGA_green=4'b0111;
               VGA_blue=4'b0000;
               end
    else if(shield==1'b1)
               begin
                   VGA_red=4'b0000;
                   VGA_green=4'b0000;
                   VGA_blue=4'b0100;
               end
     end
     
     
     else if (vid_on==1 && game_start==1 && path_on==1 && ((check_on1 && seg_out5>=0 && seg_out5<10) ||
      (check_on2 && seg_out5>=10 && seg_out5<20) || (check_on3 && seg_out5>=20 && seg_out5<30)))
        begin
          post = brom_check_data [brom_check_pix];
          
          if (post==1'b1)
          begin
                VGA_red=4'b1111;
                VGA_green=4'b1111;
                VGA_blue=4'b1111;
          end
          else
          begin
                VGA_red=4'b0000;
                VGA_green=4'b0111;
                VGA_blue=4'b0000;
          end
       end
       
       
          
    else if(vid_on==1 && game_on==1&& sq_on==1) //ball colour
       begin
           ball = brom_ball_data[rom_ball_pix];
       
           if(ball==1'b0)
               begin
               VGA_red=4'b0000;
               VGA_green=4'b0111;
               VGA_blue=4'b0000;
               end
           else if (ball==1'b1 && seg_out4==3'b000 && shield_flag)
               begin
                    VGA_red=4'b0000;
                   VGA_green=4'b0000;
                   VGA_blue=4'b0100;
               end
               
            else if (ball==1'b1 && seg_out4==3'b001&& shield_flag)
               begin
                    VGA_red=4'b1100;
                   VGA_green=4'b1100;
                   VGA_blue=4'b1100;
               end
               
             else if (ball==1'b1 && seg_out4==3'b010&& shield_flag)
               begin
                    VGA_red=4'b1110;
                   VGA_green=4'b0110;
                   VGA_blue=4'b0000;
               end
               
              else if (ball==1'b1 && seg_out4==3'b011&& shield_flag)
               begin
                    VGA_red=4'b0100;
                   VGA_green=4'b0100;
                   VGA_blue=4'b0110;
               end
               
                else if (ball==1'b1 && seg_out4==3'b100&& shield_flag)
               begin
                    VGA_red=4'b1111;
                   VGA_green=4'b0000;
                   VGA_blue=4'b1000;
               end
               
                else if (ball==1'b1 && seg_out4==3'b101 && shield_flag)
               begin
                    VGA_red=4'b0000;
                   VGA_green=4'b0110;
                   VGA_blue=4'b1100;
               end
               
                else if (ball==1'b1 && seg_out4==3'b110 && shield_flag)
               begin
                    VGA_red=4'b0010;
                   VGA_green=4'b1111;
                   VGA_blue=4'b0001;
               end
               
                else if (ball==1'b1 && seg_out4==3'b111 && shield_flag)
               begin
                    VGA_red=4'b0111;
                   VGA_green=4'b0001;
                   VGA_blue=4'b1100;
               end
               
               else if(ball==1'b1 && ~shield_flag)
               begin
                VGA_red=4'b1110;
                VGA_green=4'b0110;
                VGA_blue=4'b0000;  
                end
               
        end 

       else if(vid_on==1 && game_on==1 && maze_on && smiley_on==1) //ball colour
        begin
            smiley = brom_smiley_data[brom_smiley_pix];
         
            if(smiley==1'b0)
                begin
                VGA_red=4'b0000;
                VGA_green=4'b0111;
                VGA_blue=4'b0000;
                end
            else
                begin
                     VGA_red=4'b1011;
                    VGA_green=4'b0000;
                    VGA_blue=4'b0100;
                end
         end 
         
        
          else if (vid_on==1 && game_on==1 && maze_on==1'b0  && (counting_on1==1||counting_on2==1||counting_on3==1))
            begin
                 counting = brom_counting_data[rom_counting_pix];
                 
           
                 if(counting==1'b1)
                        begin
                            VGA_red=4'b1111;
                            VGA_green=4'b1111;
                            VGA_blue=4'b0000;
                        end
                 else
                        begin
                             VGA_red=4'b0000;
                            VGA_green=4'b0111;
                            VGA_blue=4'b0000;
                        end
             end
         
         
           
       else if (vid_on==1 && game_on==1 && path_on==1  && end_on==1'b0)
       begin
            VGA_red=4'b0000;
            VGA_green=4'b0111;
            VGA_blue=4'b0000;
        end
          
    
         
     else if (vid_on==1 && game_on==1 && maze_on==1'b0)
     begin
     VGA_red=4'b0000;
     VGA_green=4'b0111;
     VGA_blue=4'b0000;
     end
   
  
  else if (vid_on==1 && game_on==1 && path_on==1'b1 && end_on==1)
     begin
     VGA_red=4'b1111;
     VGA_green=4'b0000;
     VGA_blue=4'b0000;
     end
    
  
 end       

endmodule
          
            
//    else if (vid_on==1 &&  game_on==1'b1  && disp_on==1'b0)
//          begin
//            VGA_red=4'b0000;
//            VGA_green=4'b0111;
//            VGA_blue=4'b0000;
//          end   
             
  
