/////////////////////////////////////////////////////////////////////
////                                                             ////
////  FPU                                                        ////
////  Floating Point Unit (Single precision)                     ////
////                                                             ////
////  TEST BENCH                                                 ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000 Rudolf Usselmann                         ////
////                    rudi@asics.ws                            ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////


`timescale 1ns / 100ps

// BELOW FROM GORAZD
`include "../pre_norm_fmul.v"
`include "../primitives.v"
`include "../post_norm.v"
`include "../pre_norm.v"
`include "../except.v"
`include "../fpu.v"


module test;

   reg		clk;
   reg [31:0] 	opa;
   reg [31:0] 	opb;
   wire [31:0] 	sum;
   wire		inf, snan, qnan;
   wire		div_by_zero;
   reg [31:0] 	exp;
   reg [2:0] 	fpu_op;
  
   wire		ine;
   wire		overflow, underflow;
   wire		zero;
   reg [1:0] 	fpu_rmode;
 //  event 	error_event;


   always #50 clk = ~clk;

   initial begin
      clk = 0;
      fpu_op = 3'h0;
      fpu_rmode = 2'b00;
      opa = 32'b10010101000101000100101000101001;
      opb = 32'b10010101011101001100001000101001;
   end

   always @(posedge clk) begin
      opa = opa + 1;
      
      $display("clk = %b, op = %b , opb = %b, out = %b\n", clk, opa, opa, sum);

   end

   fpu u0(clk, fpu_rmode, fpu_op, opa, opb, sum, inf, snan, qnan, ine, overflow, underflow, zero, div_by_zero);  

endmodule
