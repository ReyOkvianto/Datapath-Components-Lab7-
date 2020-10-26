`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab8/ALU/ALUTest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module ALUTest_v;

	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;
	
	initial //This initial block used to dump all wire/reg values to dump file
     begin
      $dumpfile("ALUTest_v.vcd");
      $dumpvars(0,ALUTest_v);
     end

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

                // Here is one example test vector, testing the ADD instruction:
		{BusA, BusB, ALUCtrl} = {64'h1234, 64'hABCD0000, 4'h2}; #40; passTest({Zero, BusW}, 65'h0ABCD1234, "ADD 0x1234,0xABCD0000", passed);
		//Reformate and add your test vectors from the prelab here following the example of the testvector above.
		//ADD	
		{BusA, BusB, ALUCtrl} = {64'h2, 64'h4, 4'h2}; #40; passTest({BusW}, 64'h6, "ADD 0x2,0x4", passed);
		{BusA, BusB, ALUCtrl} = {64'hBEEF, 64'h0, 4'h2}; #40; passTest({BusW}, 64'hBEEF, "ADD 0xBEEF,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'h2}; #40; passTest({BusW}, 64'h0, "ADD 0x0,0x0", passed);
		//SUB
		{BusA, BusB, ALUCtrl} = {64'h7DA, 64'h7DA, 4'h6}; #40; passTest({BusW}, 64'h0, "SUB 0x7DA,0x7DA", passed);
		{BusA, BusB, ALUCtrl} = {64'h9, 64'h2, 4'h6}; #40; passTest({BusW}, 64'h7, "SUB 0x9,0x2", passed);
		{BusA, BusB, ALUCtrl} = {64'h3B6C, 64'hAA, 4'h6}; #40; passTest({BusW}, 64'h3AC2, "SUB 0x3B6C,0xAA", passed);
		//OR
		{BusA, BusB, ALUCtrl} = {64'h0, 64'hAB, 4'h1}; #40; passTest({BusW}, 64'hAB, "OR 0x0,0xAB", passed);
		{BusA, BusB, ALUCtrl} = {64'h2FF, 64'hAB9, 4'h1}; #40; passTest({BusW}, 64'hAFF, "OR 0x2FF,0xAB9", passed);
		{BusA, BusB, ALUCtrl} = {64'h123, 64'h321, 4'h1}; #40; passTest({BusW}, 64'h323, "OR 0x123,0x321", passed);
		//AND
		{BusA, BusB, ALUCtrl} = {64'h0, 64'hF4C, 4'h0}; #40; passTest({BusW}, 64'h0, "AND 0x0,0xF4C", passed);
		{BusA, BusB, ALUCtrl} = {64'hAF, 64'h6, 4'h0}; #40; passTest({BusW}, 64'h6, "AND 0xAF,0x6", passed);
		{BusA, BusB, ALUCtrl} = {64'hBB, 64'h4A7, 4'h0}; #40; passTest({BusW}, 64'hA3, "AND 0xBB,0x4A7", passed);
		//LSL
		{BusA, BusB, ALUCtrl} = {64'hAB7, 64'h3, 4'h4}; #40; passTest({BusW}, 64'h55B8, "LSL 0xAB7,0x3", passed);
		{BusA, BusB, ALUCtrl} = {64'h2, 64'h7, 4'h4}; #40; passTest({BusW}, 64'h100, "LSL 0x2,0x7", passed);
		{BusA, BusB, ALUCtrl} = {64'hC36, 64'h1, 4'h4}; #40; passTest({BusW}, 64'h186C, "LSL 0xC36,0x1", passed);
		//LSR		
		{BusA, BusB, ALUCtrl} = {64'h6B, 64'h6, 4'h3}; #40; passTest({BusW}, 64'h1, "LSR 0x6B,0x6", passed);
		{BusA, BusB, ALUCtrl} = {64'h8, 64'h6, 4'h3}; #40; passTest({BusW}, 64'h0, "LSR 0x8,0x6", passed);
		{BusA, BusB, ALUCtrl} = {64'hABC, 64'h5, 4'h3}; #40; passTest({BusW}, 64'h55, "LSR 0xABC,0x5", passed);	
		//PASSB	
		{BusA, BusB, ALUCtrl} = {64'h62A, 64'h62A, 4'h7}; #40; passTest({BusW}, 64'h0, "PASSB 0x62A,0x62A", passed);
		{BusA, BusB, ALUCtrl} = {64'h1, 64'h0, 4'h7}; #40; passTest({BusW}, 64'h0, "PASSB 0x1,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'hAA, 64'hAAA, 4'h7}; #40; passTest({BusW}, 64'h1, "PASSB 0xAA,0xAAA", passed);		
		
		allPassed(passed, 22);
	end
      
endmodule

