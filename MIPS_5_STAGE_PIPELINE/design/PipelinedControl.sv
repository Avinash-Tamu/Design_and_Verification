`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    control  
//////////////////////////////////////////////////////////////////////////////////
module control(
    input [5:0] opcode,  
    input reset,  bubble,
    output reg [1:0] reg_dst, mem_to_reg, alu_op,  
    output reg jump, branch, mem_read, mem_write, alu_src, reg_write, sign_or_zero, UseImmed
);  

    localparam ARITHMETIC   = 3'b000;  
    localparam SLI   = 3'b001;  
    localparam J     = 3'b010;  
    localparam JAL   = 3'b011;  
    localparam LW    = 3'b100;  
    localparam SW    = 3'b101;  
    localparam BEQ   = 3'b110;  
    localparam ADDI  = 3'b111;  

    always @(*) begin  
        if (reset == 1'b1) begin  
            reg_dst = 2'b00;  
            mem_to_reg = 2'b00;  
            alu_op = 2'b00;  
            jump = 1'b0;  
            branch = 1'b0;  
            mem_read = 1'b0;  
            mem_write = 1'b0;  
            alu_src = 1'b0;  
            reg_write = 1'b0;  
            sign_or_zero = 1'b1;  
            UseImmed 	= 1'b0;
        end  
        else begin  
            if(bubble) begin
                reg_dst = 2'b00;  
                mem_to_reg = 2'b00;  
                alu_op = 2'b00;  
                jump = 1'b0;  
                branch = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;  
                sign_or_zero = 1'b0;  
                UseImmed 	= 1'b0;

            end else begin
                case (opcode)  
                    ARITHMETIC: begin  
                        reg_dst = 2'b01;  
                        mem_to_reg = 2'b00;  
                        alu_op = 2'b00;  
                        jump = 1'b0;  
                        branch = 1'b0;  
                        mem_read = 1'b0;  
                        mem_write = 1'b0;  
                        alu_src = 1'b0;  
                        reg_write = 1'b1;  
                        sign_or_zero = 1'b1;
                        UseImmed 	= 1'b0;  
                    end  
                    SLI: begin  
                        reg_dst = 2'b00;  
                        mem_to_reg = 2'b00;  
                        alu_op = 2'b10;  
                        jump = 1'b0;  
                        branch = 1'b0;  
                        mem_read = 1'b0;  
                        mem_write = 1'b0;  
                        alu_src = 1'b1;  
                        reg_write = 1'b1;  
                        sign_or_zero = 1'b0;  
                    end  
                    J: begin  
                        reg_dst = 2'b00;  
                        mem_to_reg = 2'b00;  
                        alu_op = 2'b00;  
                        jump = 1'b1;  
                        branch = 1'b0;  
                        mem_read = 1'b0;  
                        mem_write = 1'b0;  
                        alu_src = 1'b0;  
                        reg_write = 1'b0;  
                        sign_or_zero = 1'b1; 
                        UseImmed 	= 1'b1;   
                    end  
                    JAL: begin  
                        reg_dst = 2'b10;  
                        mem_to_reg = 2'b10;  
                        alu_op = 2'b00;  
                        jump = 1'b1;  
                        branch = 1'b0;  
                        mem_read = 1'b0;  
                        mem_write = 1'b0;  
                        alu_src = 1'b0;  
                        reg_write = 1'b1;  
                        sign_or_zero = 1'b1;  
                        UseImmed 	= 1'b1;  
                end  
                LW: begin  
                    reg_dst = 2'b00;  
                    mem_to_reg = 2'b01;  
                    alu_op = 2'b11;  
                    jump = 1'b0;  
                    branch = 1'b0;  
                    mem_read = 1'b1;  
                    mem_write = 1'b0;  
                    alu_src = 1'b1;  
                    reg_write = 1'b1;  
                    sign_or_zero = 1'b1;  
                    UseImmed 	= 1'b1;  
                end  
                SW: begin  
                    reg_dst = 2'b00;  
                    mem_to_reg = 2'b00;  
                    alu_op = 2'b11;  
                    jump = 1'b0;  
                    branch = 1'b0;  
                    mem_read = 1'b0;  
                    mem_write = 1'b1;  
                    alu_src = 1'b1;  
                    reg_write = 1'b0;  
                    sign_or_zero = 1'b1; 
                    UseImmed 	= 1'b1;   
                end  
                BEQ: begin  
                    reg_dst = 2'b00;  
                    mem_to_reg = 2'b00;  
                    alu_op = 2'b10;  
                    jump = 1'b0;  
                    branch = 1'b1;  
                    mem_read = 1'b0;  
                    mem_write = 1'b0;  
                    alu_src = 1'b0;  
                    reg_write = 1'b0;  
                    sign_or_zero = 1'b1;  
                     UseImmed 	= 1'b1;  
                end  
                ADDI: begin  
                    reg_dst = 2'b00;  
                    mem_to_reg = 2'b00;  
                    alu_op = 2'b11;  
                    jump = 1'b0;  
                    branch = 1'b0;  
                    mem_read = 1'b0;  
                    mem_write = 1'b0;  
                    alu_src = 1'b1;  
                    reg_write = 1'b1;  
                    sign_or_zero = 1'b1; 
                     UseImmed 	= 1'b1;   
                end  
                default: begin  
                    reg_dst = 2'b01;  
                    mem_to_reg = 2'b00;  
                    alu_op = 2'b00;  
                    jump = 1'b0;  
                    branch = 1'b0;  
                    mem_read = 1'b0;  
                    mem_write = 1'b0;  
                    alu_src = 1'b0;  
                    reg_write = 1'b1;  
                    sign_or_zero = 1'b1;  
                     UseImmed 	= 1'b0;  
                end  
            endcase  
         end 
        end  
    end  

endmodule
