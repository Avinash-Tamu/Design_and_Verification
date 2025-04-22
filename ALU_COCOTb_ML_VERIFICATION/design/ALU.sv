

module ALU (
    input logic clk,           
    input logic [31:0] a,      
    input logic [31:0] b,      
    input int operation_type,  
    output logic [31:0] c     
);

   
    logic [31:0] result;

   
    always_ff @(posedge clk) begin
        case (operation_type)
            0 : begin 
                result <= a + b;
            end

            1 : begin 
                result <= a - b;
            end

            2 : begin 
                result <= a * b;
            end

            3 : begin 
                if (b != 0) begin
                    result <= a / b;
                end else begin
                    result <= 0;  
                end
            end

            4 : begin 
                result <= a & b;
            end

            5 : begin 
                result <= a | b;
            end

            6 : begin 
                result <= a ^ b;
            end

            7 : begin 
                result <= ~a;
            end

            8 : begin // Logical Shift Left (LSL)
                result <= a << b;
            end

            9 : begin // Logical Shift Right (LSR)
                result <= a >> b;
            end

            default: begin
                result <= 0;
            end
        endcase

        // Output the result
        c <= result;
    end

endmodule

