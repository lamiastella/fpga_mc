`timescale 10ns/1ns

`include "../rng.v"

module test1;

   reg loadseed_i;
   reg [31:0] seed_i;
   wire [31:0] number_1;
   wire        slowclk; 
   reg clk = 0;
   reg clk2 = 1;
   wire [2:0] number_2;
   reg       rst;
   
   initial begin
      rst = 1'b0;
      # 20 rst = 1'b1;
      
      loadseed_i = 1'b0;
      seed_i=32'h12345678;     
      $monitor ("output = %H, state = %b, clk = %b, clk2 = %b, rst = %b, time= %t", number_1, number_2, clk, clk2, rst, $time);
   end

   always begin 
      #2 clk = !clk;
      #5 clk2 = !clk2;
   end
   
   fsm fsm1(number_2, rst, clk, {clk,clk2});      
   //sc sc1(slowclk, clk);
   
   rng r1(clk, loadseed_i, seed_i, number_1); // random number generator 

endmodule
