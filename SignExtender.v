`timescale 1ns / 1ps
`default_nettype none

module SignExtender(BusImm, Imm26, Ctrl);
	
	//Define input and output
	output reg [63:0] BusImm;
	input [25:0] Imm26;
	input [1:0] Ctrl;
	
	always @(*) begin
		case(Ctrl)
			2'b00: begin //D-type
				BusImm = {{55{Imm26[20]}}, Imm26[20:12]};
			end
			2'b01: begin //CBZ, CB-type
				BusImm = {{45{Imm26[23]}}, Imm26[23:5]};
			end
			2'b10: begin //B-type
				BusImm = {{38{Imm26[25]}}, Imm26[25:0]};
			end
			2'b11: begin //I-type
				BusImm = {52'b0, Imm26[21:10]};
			end
		endcase
	end 

endmodule 
