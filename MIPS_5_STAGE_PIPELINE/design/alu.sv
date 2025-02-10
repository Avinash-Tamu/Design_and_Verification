`timescale 1ns / 1ps

// Module Name:    alu 

module alu(       
    input          [31:0]     src1,            
    input          [31:0]     src2,         
    input          [2:0]      alu_control,  // function selector  
    output     reg     [31:0] result,       
    output               zero
);  

    // Define ALU control signals using localparams
    localparam ADD    = 3'b000;
    localparam SUB    = 3'b001;
    localparam AND    = 3'b010;
    localparam OR     = 3'b011;
    localparam GREATER = 3'b100;

    always @(*) begin
        case(alu_control)  
            ADD:    result = src1 + src2;  
            SUB:    result = src1 - src2; 
            AND:    result = src1 & src2; 
            OR:     result = src1 | src2; 
            GREATER: begin 
                        if (src1 < src2) 
                            result = 32'd1;  
                        else 
                            result = 32'd0;  
                    end  
            default: result = src1 + src2; 
        endcase  
    end

    // Zero flag assignment
    assign zero = (result == 32'd0) ? 1'b1 : 1'b0;  

endmodule
