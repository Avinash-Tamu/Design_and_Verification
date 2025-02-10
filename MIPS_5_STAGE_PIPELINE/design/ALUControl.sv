`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ALUControl 
//////////////////////////////////////////////////////////////////////////////////
 module ALUControl( ALU_Control, ALUOp, Function);  
    output reg[2:0] ALU_Control;  
    input [1:0] ALUOp;  
    input [5:0] Function;  

 wire [7:0] ALUControlIn;  
 assign ALUControlIn = {ALUOp,Function};  
 always @(ALUControlIn)  
    casex (ALUControlIn)  
        8'b11xxxxx: ALU_Control=3'b000;  
        8'b10xxxxxx: ALU_Control=3'b100;  
        8'b01xxxxx: ALU_Control=3'b001;  
        8'b00000000: ALU_Control=3'b000;  
        8'b00000001: ALU_Control=3'b001;  
        8'b00000010: ALU_Control=3'b010;  
        8'b00000011: ALU_Control=3'b011;  
        8'b00000100: ALU_Control=3'b100;  
        default: ALU_Control=3'b000;  
    endcase  
 endmodule  

module JR_Control( input[1:0] alu_op, 
       input [5:0] funct,
       output JRControl
    );
assign JRControl = ({alu_op,funct}==8'b00001000) ? 1'b1 : 1'b0;
endmodule