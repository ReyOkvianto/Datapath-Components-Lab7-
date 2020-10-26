`timescale 1ns/1ps
`default_nettype none
`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111
`define LSL   4'b0100
`define LSR   4'b0011


module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    parameter n = 64;

    output  [n-1:0] BusW;
    input   [n-1:0] BusA, BusB;
    input   [3:0] ALUCtrl;
    output  reg Zero;
    
    reg     [n-1:0] BusW;
    
    always @(ALUCtrl or BusA or BusB) begin
        case(ALUCtrl)
            `AND: begin
                BusW <= #20 BusA & BusB;
            end
            `OR: begin
                BusW <= #20 BusA | BusB;
            end
            `ADD: begin
                BusW <= #20 BusA + BusB;
            end
            `SUB: begin
                BusW <= #20 BusA - BusB;
            end
            `PassB: begin
                if(BusA < BusB)
                    BusW <= #20 64'h1;
                else
                    BusW <= #20 64'h0;
            end
            `LSL: begin
                BusW <= #20 BusA << BusB;
            end
            `LSR: begin
                BusW <= #20 BusA >> BusB;
            end
        endcase
    end
    
    always @(BusW) begin
        case(BusW)
            64'h0: begin
                Zero <=  1'b1;
            end
            default: begin
                Zero <= 1'b0;
            end
        endcase
    end

endmodule
