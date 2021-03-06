`timescale 10ns/1ns

//`include "rng.v"

///-- start rng
// ----------------- rng starts 
module rng( clk, loadseed_i, seed_i, number_o );
   input clk;
   input loadseed_i;
   input [31:0] seed_i;
   output [31:0] number_o;
   integer 	 i;
   reg [31:0] 	 number_o;
   reg [42:0] 	 LFSR_reg;
   reg [36:0] 	 CASR_reg;


   //CASR:
   reg [36:0] 	 CASR_varCASR,CASR_outCASR;
   // LFSR:
   reg[42:0] LFSR_varLFSR;
   reg 	     outbitLFSR;
   
	
   initial begin 
      CASR_reg  = (1);
      LFSR_reg  = (1);
      number_o  = (0);	
   end
	
   always @(posedge clk) begin 

      if (loadseed_i ) begin 
         CASR_varCASR [36:32]=0;
         CASR_varCASR [31:0]=seed_i ;
         CASR_reg  = (CASR_varCASR );
      end
      else begin 
         CASR_varCASR =CASR_reg ;
	 
         CASR_outCASR [36]=CASR_varCASR [35]^CASR_varCASR [0];

	 for (i=28; i <= 35; i=i+1)
	   CASR_outCASR [i]=CASR_varCASR [i-1]^CASR_varCASR [i+1];

         CASR_outCASR [27]=CASR_varCASR [26]^CASR_varCASR [27]^CASR_varCASR [28];

	 for (i=1; i <= 26; i=i+1)
	   CASR_outCASR [i]=CASR_varCASR [i-1]^CASR_varCASR [i+1];
            
	 CASR_outCASR [0]=CASR_varCASR [36]^CASR_varCASR [1];

         CASR_reg  = (CASR_outCASR );
      end
   end

   always @(posedge clk) begin 

      if (loadseed_i ) begin
	 LFSR_varLFSR [42:32]=0;
         LFSR_varLFSR [31:0]=seed_i ;
         LFSR_reg  = (LFSR_varLFSR );
      end
      else begin
         LFSR_varLFSR =LFSR_reg ;
         outbitLFSR =LFSR_varLFSR [42];

         LFSR_varLFSR [42]=LFSR_varLFSR [41];
         LFSR_varLFSR [41]=LFSR_varLFSR [40]^outbitLFSR ;
	 for (i=21; i <= 40; i= i+1)
	   LFSR_varLFSR [i]=LFSR_varLFSR [i-1];
         LFSR_varLFSR [20]=LFSR_varLFSR [19]^outbitLFSR ;
	 for (i=2; i <= 19; i= i+1)
	   LFSR_varLFSR [i]=LFSR_varLFSR [i-1];
         LFSR_varLFSR [1]=LFSR_varLFSR [0]^outbitLFSR ;
         LFSR_varLFSR [0]=LFSR_varLFSR [42];

         LFSR_reg  = (LFSR_varLFSR );

      end
   end

   //combinate:
   always @(posedge clk)
     number_o  = (LFSR_reg [31:0]^CASR_reg[31:0]);

endmodule

// slowclock module 
module sc (output slowclk, input clk);
   
   wire clk;
   reg 	slowclk;

   reg [64:0] i = 64'd0;
   
   parameter delay = 2;
   
   always @(posedge clk) begin 
      if (i <delay) begin
	 i = i+1;
	 slowclk = slowclk;
      end
      else begin 
	 i = 64'd0;
	 slowclk = ~slowclk;
      end
   end

endmodule // sc

// module rn_normal (output rn1, output rn2, input un1, input un2, input clk, input step);

//    reg [31:0] rn1;
//    reg [31:0] rn2;
//    wire [31:0] next_rn1;
//    wire [31:0] next_rn2;
//    wire [31:0] ln_un1;
//    wire [31:0] sin_un2;
//    wire [31:0] cos_un2;
//    reg        step;
   
   
//    // combinatorial logic 
//    // ln_un1 = sqrt(-2 * ln(un1))
//    // sin_un2 = sin (2 * pi * un2)
//    // cos_un2 = cos (2 * pi * un2)

//    if (step) 
//       next_rn1 = rn1;
//       //next_rn1 <= ln_un1 * sin_un2;
//       //next_rn2 <= ln_un1 * cos_un2;
//    else 
//       ln_un1 = rn2;
//       //ln_un1 <= sqrt(-2 * ln(un1)); // THIS THREE LINES HAVE TO BE REWRITTEN 
//       //sin_un2 <= sin (2 * pi * un2);
//       //cos_un2 <= cos (2 * pi * un2);

   
//    always @(clk, un1, un2) begin
//       rn1 = next_rn1;
//       rn2 = next_rn2;
//    end

// endmodule // rn_normal

// implements
// S_0 * exp ( - sigma**2 * dt + sigma * W)
// module mc_step (output S_next, input S_0, input W, input clk, input step);

//    wire [31:0] S_n;
//    reg [31:0]  S_next;
   
   
//    parameter sigma = 0.2;
//    parameter dt = 0.1;
      
//    assign S_n = S_0 * exp (- sigma**2 * dt + sigma * W);
   
//    always @(posedge clk)
//      S_next = S_n;
   
   
// endmodule // mc_step

//module mc (output S_final, input S_0, input S1);
   

//endmodule // mc


module fsm (o, rst, clk, i);
   output [2:0] o;
   input 	rst;
   input 	clk;
   input [1:0] 	i;
   parameter s0 = 3'b001, s1 = 3'b101, s2 = 3'b110;
   reg [2:0] 	o;
   wire [2:0] 	next_o;

   always @(posedge clk)
     if (rst)
       o = next_o;
     else
       o = s0;

   // this is basically a gate assignement
   assign next_o = (o == s0) ? s1: //((i[0] | i[1]) ? s1 : s0) :
    		   (o == s1) ? s2: //(i[0] & i[1] ? s1 : (i[1] ? s2 : s1)) :
    		   (o == s2) ? s0: s1; //(i[1] ? s0 : s2) : s2 ;
   
endmodule // fsm

module sel1 (r, d, c, clk);

   input [7:0] d;
   input       clk;
   output [7:0] r;
   input 	c;
   
   wire [7:0] next_r;
   reg [7:0]  r;
   
   
   assign next_r = c ? d : r;

   always @(posedge clk)
     r = next_r;
    

endmodule // sel1
