`timescale 1ns / 100ps

// including the FPU module 
`include "../verilog/pre_norm_fmul.v"
`include "../verilog/primitives.v"
`include "../verilog/post_norm.v"
`include "../verilog/pre_norm.v"
`include "../verilog/except.v"
`include "../verilog/fpu.v"

module test1;

   reg		clk;
   reg [31:0] 	opa;
   reg [31:0] 	opb;
   wire [31:0] 	sum;
   wire		inf, snan, qnan;
   wire		div_by_zero;

   reg [2:0] 	fpu_op;
   reg [1:0] 	rmode;
   wire		ine;
   wire		overflow, underflow;
   wire		zero;

   always #50 clk = ~clk;
   
   initial begin
      $display ("\n\nFloating Point Unit testbench \n\n");
      clk = 0;
      rmode = 2'b00; // round to nearest integer 
      fpu_op = 3'b000; // adding 32-bit floats 
      opa = 32'b10010101000101000100101000101001;
      opb = 32'b10010101011101001100001000101001;
   end
   
   always @(posedge clk) begin
      $display("op = %b , opb = %b, out = %b\n", opa, opb, sum);
      
   end
   
   //fpu u0(clk, rmode, fpu_op, opa, opb, sum, inf, snan, qnan, ine, overflow, underflow, zero, div_by_zero);




endmodule // test_1
