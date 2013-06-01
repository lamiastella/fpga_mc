
// implementing the fpu 
// `include "../fpu/pre_norm_fmul.v"
// `include "../fpu/primitives.v"
// `include "../fpu/post_norm.v"
// `include "../fpu/pre_norm.v"
// `include "../fpu/except.v"
// `include "../fpu/fpu.v"
`include "../rng/rng.v"

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
   output [63:0] q;
   input 	 clk;
   input [31:0]  eps;
   input [7:0] 	 step;

   parameter drift = 63'b1;
   parameter vol = 63'b10;
   parameter S0 = 63'b1;
   parameter K = 63'b11111111111111111111111111111111111111111111111111111111111111; // just some large number 
   
   
   wire [63:0] 	a1, a2, aq;
   wire [63:0] 	res; // result of option computation
   reg [63:0] 	aq_reg;
   
   always @(posedge clk)
     aq_reg = aq;

   assign aq = a1 * a2;  
   assign a1 = drift + vol * eps; 

   assign a2 = (step == 0) ? S0 : aq_reg;

   assign res = (aq_reg -K) > 0 ? aq_reg - K : 63'b0;
   
   assign q = (step == 8'b1010 ) ? res : aq_reg ;

endmodule


// Testing:
//   Monte-Carlo test case 
// module mc_tb();
   
//    reg clk; // clock
//    wire [63:0] q;

//    reg [7:0]  step;

//    reg loadseed_i;
//    reg [31:0] seed_i;
//    wire [31:0] eps1;
   
//    initial begin
//       $display ("time \t clk \t step \t eps \t q");
//       $monitor ("%g\t %b \t %b \t %b \t %b", $time, clk, step, eps1, q);
      
//       loadseed_i = 1'b0; // for rng 
//       seed_i=32'b111;     

//       clk = 1;
//       step = 0;
//       #1000 $finish;
   
//    end
   
//    always begin
//       #5 clk = ~clk;
//       //step = step + 1;
//    end

//    always @(posedge clk)
//      if (step == 10)
//        step = 0;
//      else
//        step = step + 1;
   
//    mc_naive mc1 (q, clk, eps1, step); // monte carlo simulator
//    rng r1(clk, loadseed_i, seed_i, eps1); // rng 
   
   
// endmodule // mc_tb


// Testing:
//   Monte-Carlo test case for 2 modules 
// module mc_tb2();

//    parameter nb_cores =10;
   
//    reg clk; // clock
//    wire [63:0] q1, q2;

//    reg [7:0]  step;

//    reg loadseed_i1, loadseed_i2;
//    reg [31:0] seed_i1, seed_i2;
//    wire [31:0] eps1, eps2;
   
//    initial begin
//       $display ("time \t clk \t step \t eps \t q1 \t eps2 \t q2");
//       $monitor ("%g\t %b \t %b \t %b \t %b", $time, clk, step, eps1, q1, eps2, q2);
      
//       loadseed_i1 = 1'b0; // for rng
//       loadseed_i2 = 1'b0; // for rng 
//       seed_i1=32'b111;
//       seed_i2=32'b101;     

//       clk = 1;
//       step = 0;
//       #1000 $finish;
   
//    end
   
//    always begin
//       #5 clk = ~clk;
//       //step = step + 1;
//    end

//    always @(posedge clk)
//      if (step == 10)
//        step = 0;
//      else
//        step = step + 1;

//    // parallel monte carlos 
//    mc_naive mc1 (q1, clk, eps1, step); // monte carlo simulator
//    rng r1(clk, loadseed_i1, seed_i1, eps1); // rng 

//    mc_naive mc2 (q2, clk, eps2, step); // monte carlo simulator
//    rng r2(clk, loadseed_i2, seed_i2, eps2); // rng 

   
   
// endmodule // mc_tb2


module mc_tb3();

   parameter nb_cores =3;
   
   reg clk; // clock
   wire [63:0] q[0:nb_cores-1];
   reg [7:0]   step;

   reg 	       loadseed_i [0:nb_cores-1];
   reg [31:0]  seed_i[0:nb_cores-1];
   wire [31:0] eps[0:nb_cores-1];
   integer     k;
   
   initial begin
      $display ("time \t clk \t step \t eps \t q1 \t eps2 \t q2");
      $monitor ("%g\t %b \t %b \t %b \t %b \t %b \t %b", $time, clk, step, eps[0], q[0], eps[1], q[1]);
      
      for (k=0; k<nb_cores; k = k+1) begin 
	 loadseed_i[k] = 1'b0; // for rng
	 seed_i[k]=32'b111; // SHOULD BE CHANGED 
      end
      
	 
      clk = 1;
      step = 0;
      #1000 $finish;
   
   end
   
   always begin
      #5 clk = ~clk;
      //step = step + 1;
   end

   always @(posedge clk)
     if (step == 10)
       step = 0;
     else
       step = step + 1;

   // parallel monte carlos
   mc_naive mc1 (q[0], clk, eps[0], step); // monte carlo simulator
   rng r1 (clk, loadseed_i[0], seed_i[0], eps[0]); // rng 
   mc_naive mc2 (q[1], clk, eps[1], step); // monte carlo simulator
   rng r2 (clk, loadseed_i[1], seed_i[1], eps[1]); // rng 
   mc_naive mc3 (q[2], clk, eps[2], step); // monte carlo simulator
   rng r3 (clk, loadseed_i[2], seed_i[2], eps[2]); // rng 

   
   
endmodule