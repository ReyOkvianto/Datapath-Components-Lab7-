`timescale 1ns / 1ps
`define STRLEN 20

module SignExtenderTest;

	task passTest;
		input [63:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask
	
	// Inputs
	reg [25:0] Input;
	reg [1:0] Control;
	reg [7:0] passed;

	// Outputs
	wire [63:0] Output;

	initial //This initial block used to dump all wire/reg values to dump file
     begin
      $dumpfile("SignExtenderTest.vcd");
      $dumpvars(0,SignExtenderTest);
     end
	
	// Instantiate the Device Under Test (DUT)
	SignExtender dut (
		.BusImm(Output),
		.Imm26(Input), 
		.Ctrl(Control)
	);	
	
	initial begin
		
		Input = 0;
		passed = 0;
		
		//Put test cases here
		//D-type
		//LDUR - opcode: 11111000010
		#90; {Control, Input} = {2'b00, 26'b00010_000101110_000000110011}; #90;
			passTest(Output, 64'b0000000000000000000000000000000000000000000000000000000000101110, "LDUR (D-type) Test", passed);
		//STUR - opcode: 11111000000
		#90; {Control, Input} = {2'b00, 26'b00000_100001111_000010000001}; #90;
			passTest(Output, 64'b1111111111111111111111111111111111111111111111111111111100001111, "STUR (D-type) Test", passed);
			
		//CB-type
		//CBZ - opcode: 10110100
		#90; {Control, Input} = {2'b01, 26'b00_0000000000000000010_00001}; #90;
			passTest(Output, 64'b0000000000000000000000000000000000000000000000000000000000000010, "CBZ Test 1", passed);
		#90; {Control, Input} = {2'b01, 26'b00_1111111111111111110_00010}; #90;
			passTest(Output, 64'b1111111111111111111111111111111111111111111111111111111111111110, "CBZ Test 2", passed);
		
		//B-type - opcode: 000101
		#90; {Control, Input} = {2'b10, 26'b00000000000000000000000111}; #90;
			passTest(Output, 64'b0000000000000000000000000000000000000000000000000000000000000111, "B Test 1", passed); 
		#90; {Control, Input} = {2'b10, 26'b11111111111111111110001001}; #90;
			passTest(Output, 64'b1111111111111111111111111111111111111111111111111111111110001001, "B Test 2", passed);
					
		//I-type
		//SUBI - opcode: 1101000100
		#90; {Control, Input} = {2'b11, 26'b0100_111111110001_0000100000}; #90;
			passTest(Output, 64'b0000000000000000000000000000000000000000000000000000111111110001, "SUBI (I-type) Test", passed);
		//ADDI - opcode: 1001000100
		#90; {Control, Input} = {2'b11, 26'b0100_011000010100_0000111000}; #90;
			passTest(Output, 64'b0000000000000000000000000000000000000000000000000000011000010100, "ADDI (I-type) Test", passed);		
		
		allPassed(passed, 8);
	end
	
endmodule
