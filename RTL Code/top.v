`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2019 15:45:16
// Design Name: 
// Module Name: top
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


module top(
    input clk_100M,
    input clear, //reset
    input pause,
    input game_on,
    input game_start,
    input restart,
    input up,
    input down,
    input right,
    input left,
    
    
    output H_sync,
    output V_sync,
    output  [3:0] VGA_r,
    output  [3:0] VGA_g,
    output  [3:0] VGA_b
    );
    
    
    wire clk_65M;
    clk_gen i1
   (
    // Clock out ports
    .clk_65M(clk_65M),     // output clk_65M
   // Clock in ports
    .clk_100M(clk_100M));
    
    wire clk_250H;
    clk_div #(.COUNT_DIV(130000)) clk1(.clear(clear),.clk_in(clk_65M),.clk_div(clk_250H));
    
    wire clk_10H;
    clk_div #(.COUNT_DIV(3250000)) clk2(.clear(clear),.clk_in(clk_65M),.clk_div(clk_10H));
   
    wire clk_1H;
    clk_div #(.COUNT_DIV(32500000)) clk3(.clear(clear),.clk_in(clk_65M),.clk_div(clk_1H));
   
    wire clk_2H;
    clk_div #(.COUNT_DIV(16250000)) clk4(.clear(clear),.clk_in(clk_65M),.clk_div(clk_2H));
   
   wire clk_50H;
   clk_div #(.COUNT_DIV(650000)) clk6(.clear(clear),.clk_in(clk_65M),.clk_div(clk_50H));
//    wire game_startd;
//    pb_debounce i4(.clk_250H( clk_250H),.inp_pb(game_start),.out_deb(game_startd));
    wire [16:0] H_cnt,V_cnt;
    wire Vid_on;
    
   vga_ctrl v1(.clk_65M(clk_65M),.clear(clear),.H_sync(H_sync),.V_sync(V_sync),.H_cnt(H_cnt),.V_cnt(V_cnt),.Vid_on(Vid_on)); 
   
   //BROMS
   wire [4:0] brom_ball_addr;     //ball
   wire [0:19] brom_ball_data;
   
  dotball your_instance_name (
  .clka(clk_65M),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(brom_ball_addr),  // input wire [3 : 0] addra
  .douta(brom_ball_data)  // output wire [19 : 0] douta
);
  
  wire [9:0] brom_maze_addr;      //maze
  wire [0:699] brom_maze_data;
  brom_maze h2(
  .clka(clk_65M),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(brom_maze_addr),  // input wire [9 : 0] addra
  .douta(brom_maze_data)  // output wire [699 : 0] douta
);
   wire [0:31]brom_counting_data;
   wire [8:0]brom_counting_addr;
  
   brom_counter i2 (
  .clka(clk_65M),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(brom_counting_addr),  // input wire [8 : 0] addra
  .douta(brom_counting_data)  // output wire [31 : 0] douta
);

wire [0:265] brom_disp_data;
wire [9:0] brom_disp_addr;

display d1(
  .clka(clk_65M),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(brom_disp_addr),  // input wire [9 : 0] addra
  .douta(brom_disp_data)  // output wire [404 : 0] douta
);


wire [0:24] brom_smiley_data;
wire [5:0] brom_smiley_addr;

smiley s1 (
  .clka(clk_65M),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(brom_smiley_addr),  // input wire [5 : 0] addra
  .douta(brom_smiley_data)  // output wire [24 : 0] douta
);


wire [4:0] brom_check_addr;
wire [0:24] brom_check_data;

checkpost c1 (
  .clka(clk_100M),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(brom_check_addr),  // input wire [4 : 0] addra
  .douta(brom_check_data)  // output wire [24 : 0] douta
);
wire [4:0] brom_ghost_addr;     //ball
   wire [0:24] brom_ghost_data;
   wire ghostf;
   
   brom_ghost in9 (
  .clka(clk_100M),    // input wire clka
  .ena(ghostf),      // input wire ena
  .addra(brom_ghost_addr),  // input wire [4 : 0] addra
  .douta(brom_ghost_data) // output wire [24 : 0] douta
);
 wire [9:0] brom_letter_addr;
 wire [0:31] brom_letter_data;
 letter l1 (
 .clka(clk_65M),    // input wire clka
 .ena(1'b1),      // input wire ena
 .addra(brom_letter_addr),  // input wire [9 : 0] addra
 .douta(brom_letter_data)  // output wire [31 : 0] douta
);

 wire [4:0] brom_timeplus_addr;
   wire [0:31] brom_timeplus_data;
   
   brom_timeplus timeplus(
 .clka(clk_65M),    // input wire clka
 .ena(1'b1),      // input wire ena
 .addra(brom_timeplus_addr),  // input wire [4 : 0] addra
 .douta(brom_timeplus_data)  // output wire [31 : 0] douta
);

   wire [4:0] brom_shield_addr;
   wire [0:31] brom_shield_data;
brom_shield shield(
 .clka(clk_65M),    // input wire clka
 .ena(1'b1),      // input wire ena
 .addra(brom_shield_addr),  // input wire [4 : 0] addra
 .douta(brom_shield_data)  // output wire [31 : 0] douta
);

 vga_game v2(.brom_ball_addr(brom_ball_addr),.brom_ball_data(brom_ball_data),.brom_maze_addr(brom_maze_addr),.brom_maze_data(brom_maze_data),
             .up(up),.brom_ghost_addr(brom_ghost_addr),.brom_letter_addr(brom_letter_addr),.ghostf(ghostf),.brom_letter_data(brom_letter_data),.brom_ghost_data(brom_ghost_data),.down(down),.right(right),.left(left),.restart(restart),.clk_1H(clk_1H),.clk_10H( clk_10H),.brom_check_addr(brom_check_addr),
             .brom_check_data(brom_check_data),.brom_counting_addr(brom_counting_addr),.brom_counting_data(brom_counting_data),.clk_2H(clk_2H),.brom_timeplus_addr(brom_timeplus_addr),.brom_timeplus_data(brom_timeplus_data),.brom_shield_addr(brom_shield_addr),
            .brom_shield_data(brom_shield_data), .pause(pause),.clk_65M(clk_65M),.clk_50H(clk_50H),.clear(clear),.game_on(game_on),.game_start(game_start),.vid_on(Vid_on),.clk_100M(clk_100M),
             .brom_disp_addr(brom_disp_addr),.brom_disp_data(brom_disp_data),.brom_smiley_addr(brom_smiley_addr),.brom_smiley_data(brom_smiley_data),
             .H_count(H_cnt),.V_count(V_cnt),.VGA_red(VGA_r),.VGA_blue(VGA_b),.VGA_green(VGA_g));
    
endmodule
