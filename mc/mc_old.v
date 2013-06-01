
// implementing the fpu 
`include "../pre_norm_fmul.v"
`include "../primitives.v"
`include "../post_norm.v"
`include "../pre_norm.v"
`include "../except.v"
`include "../fpu.v"

// TO IMPROVE, SIN JUST LET HERE
// from webpage: http://www.mikrocontroller.net/topic/237060
  
module to_improve();

   function real Sin;
      //input [63:0]  x;
      //input real  x;

      input x;
      real  x;

      real  p,t,r,f;
      integer i;
      
      real    condition;

      
      begin

	 p= 1.0;
	 t= 1.0;
	 r = 0.0;
	 i = 0;
	 f= 1.0;


	 while( x > 2.0*3.1415926536)
	   x = x -  2.0*3.1415926536;
	 
	 while( x < -2.0*3.1415926536)
	   x = x +  2.0*3.1415926536;


	 
	 while ( (Abs(t) > 1e-5) || (Abs(r) > 1.0)) begin
	    t = p / (f);
	    r = r + Phase4(i) * t;
	    p = p * x;
	    i = i + 1;
	    f = f * i;
	    if(i == 30)  $finish;
	    
	    //  $display(" sin x %e t %e r %e p %e loop i  %d f %e  ", x,t,r,p,i,f);
	 end //while

	 Sin=r;
      end
      
   endfunction


   function real Real;
      input x;
      integer x;
      
      begin
	 Real = x;
      end
   endfunction

   function real Phase4;
      input   n;
      integer n;
      
      integer themod;
      
      begin
	 themod = mod(n,4);
	 case(themod)
	   0: Phase4 = 0.0;
	   1: Phase4 = 1.0;
	   2: Phase4 = 0.0;
	   3: Phase4 = -1.0;
	 endcase
      end
   endfunction

   function integer mod;
      input n,m;
      integer n,m;
      
      begin
	 while(n>=m) begin
	    n = n-m;
	    //$display(" mod %d %d", n,m);
	 end
	 
	 mod=n;
      end
   endfunction

   function real Abs ;
      input x;
      real  x;
      
      begin
	 if(x > 0.0) 
	   Abs = x;
	 else 
	   Abs = -1.0*x;

      end

   endfunction

endmodule // to_improve



module mc_naive (q, clk, eps, step);
   output [7:0] q;
   input 	clk;
   input [7:0] 	eps;
   input [1:0] 	step;
   parameter drift = 8'd2;
   parameter vol = 8'd1;
   parameter S0 = 8'd1;
   
   reg 		r1;

   wire [10:0] 	a1, aq;
   reg [10:0] 	aq_reg;
   
   always @(posedge clk)
     aq_reg = aq;

   assign aq = a1 * a2;
   assign a1 = drift + vol * eps;

   assign a2 = (step == 0) ? S0 : aq_reg;
   assign q = aq_reg;

endmodule



// incr ... input increment
// w, eps, q ... inputs
module mc_slow (clk, w, eps, q, incr);

   input clk;
   input [31:0] w, eps, q;
   output [31:0] incr;

   parameter S0 = 1;
   
   reg [31:0] 	 int1;
   wire [31:0]	 n_int1;


   // parameters for FPU operations 
   reg [31:0] 	 opa;
   reg [31:0] 	 opb;
   wire [31:0] 	 weps;
   wire 	 inf, snan, qnan;
   wire 	 div_by_zero;
   reg [31:0] 	 exp;
   reg [2:0] 	 fpu_op;
   
   wire 	 ine;
   wire 	 overflow, underflow;
   wire 	 zero;
   reg [1:0] 	 fpu_rmode;



   
   always @(posedge clk) begin
      int1 = n_int1;
   end

   fpu u0 (clk, fpu_rmode, fpu_op, w, eps, weps, inf, snan, qnan, ine, overflow, underflow, zero, div_by_zero);  
   fpu u1 (clk, fpu_rmode, fpu_op, weps, q, inf, snan, qnan, ine, overflow, underflow, zero, div_by_zero);  
   
   assign n_int1 = S0 * (w * eps + q);

   assign incr = int1;
   
   
endmodule // mc
