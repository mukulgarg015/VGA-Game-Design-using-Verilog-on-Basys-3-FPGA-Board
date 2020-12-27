
   `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2018 10:55:52
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd
#(parameter N=9)
(
   input  [N:0] number,
   output reg [3:0] hundreds,
   output reg [3:0] tens,
   output reg [3:0] ones
   );
   
   // Internal variable for storing bits
    reg [N+12:0] shift;
     integer i;
     
     always @(number)
     begin
        // Clear previous number and store new number in shift register
        shift[N+12:N+1] = 0;
        shift[N:0] = number;
        
        
        for (i=0; i<=N; i=i+1) begin
           if (shift[N+4:N+1] >= 5)
              shift[N+4:N+1] = shift[N+4:N+1] + 3;
              
           if (shift[N+8:N+5] >= 5)
              shift[N+8:N+5] = shift[N+8:N+5] + 3;
              
            if (shift[N+12:N+9] >= 5)
              shift[N+12:N+9] = shift[N+12:N+9] + 3;
              
           
           // Shift entire register left once
           shift = shift << 1;
        end
        
       // Push decimal numbers to output
        hundreds = shift[N+12:N+9];
        tens     = shift[N+8:N+5];
        ones     = shift[N+4:N+1];
        
        
     end
     endmodule
   
      // Clear previous number and store new number in shift register
     /* shift[31:16] = 0;
      shift[15:0] = number;
      
      // Loop sixteen times
      for (i=0; i<16; i=i+1) begin
         if (shift[19:16] >= 5)
            shift[19:16] = shift[19:16] + 3;
            
         if (shift[23:20] >= 5)
            shift[23:20] = shift[23:20] + 3;
            
         if (shift[27:24] >= 5)
            shift[27:24] = shift[27:24] + 3;
            
         if (shift[31:28] >= 5)
         shift[31:28] = shift[31:28] + 3;   
         
         // Shift entire register left once
         shift = shift << 1;
      end
     
      // Push decimal numbers to output
      thousands = shift[31:28];
      hundreds = shift[27:24];
      tens     = shift[23:20];
      ones     = shift[19:16]; */
 
 



