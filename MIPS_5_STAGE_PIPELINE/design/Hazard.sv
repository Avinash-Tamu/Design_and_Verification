module HazardUnit (
    output reg IF_write, 
    output reg PC_write, 
    output reg bubble,
	output reg [1:0] addrSel,

	input Jump, 
    input Branch, 
    input ALUZero, 
    input memReadEX, 
	input [5:0] op,
    input clk, 
    input reset,
	input UseShamt, 
    input UseImmed,
	input [4:0] currentRs,
	input [4:0] currentRt,
	input [4:0] previousRt,
	input [4:0] previousRd
);



typedef enum logic [2:0] {
    NoHazard_state    = 3'b000,  // No hazard - Normal state
    Jump_state        = 3'b001,  // Jump
    Branch_0_state    = 3'b010,  // Branch Encountered
    Branch_1_state    = 3'b011,   // Branch Taken
	data_hazard_state    = 3'b100   // data Takhazarden
} fsm_state_t;

// HIGH when hazard exists
reg LdHazard;
reg DataHazard;

fsm_state_t state, next_state;

always @(posedge clk) begin 
    if (reset) begin
        state <= NoHazard_state;
    end else begin 
        state <= next_state;
    end
end 


 // R Type True Dependency Hazard Flowchart logic
    always @(*)begin
      if(previousRd==0)  
        DataHazard <= 0;
      else if(op == 0) begin
                if((previousRd==currentRs) || (previousRd==currentRt)) 
                    DataHazard <= 1;  
                else
                    DataHazard <= 0;  
      end 
	  else	
				DataHazard <= 0;  
	end
// Load Hazard Flowchart logic
    always @(*)begin
      if(previousRt==0)  
        LdHazard <= 0;
      else if(memReadEX==1)
        case({UseShamt,UseImmed})
            2'b00:
                if((previousRt==currentRs) || (previousRt==currentRt)) 
                    LdHazard <= 1;  
                else
                    LdHazard <= 0;  

            2'b10:
                if(previousRt==currentRs)
                    LdHazard <= 1; 
                else
                    LdHazard <= 0;

            2'b01:
                if(previousRt==currentRs)
                    LdHazard <= 1;
                else
                    LdHazard <= 0;

            default:
                LdHazard <= 0;
        endcase
    end

	always @(*) begin	
		case( state )
			
			NoHazard_state: begin	
				if( Jump == 1'b1 ) begin
					IF_write = 1'b0;
					PC_write = 1'b1;
					bubble = 1'b0;
					addrSel = 2'b01;
					next_state = Jump_state;
				end
				
				else if( LdHazard == 1'b1 ) begin
					IF_write = 1'b0;
					PC_write = 1'b0;
					bubble = 1'b1;
					addrSel = 2'b00;
					next_state = NoHazard_state;
				end

				else if( DataHazard == 1'b1 ) begin
					IF_write = 1'b0;
					PC_write = 1'b0;
					bubble = 1'b1;
					addrSel = 2'b00;
					next_state = data_hazard_state;
				end
				
				else if (Branch == 1'b1)begin
					IF_write = 1'b0;
					PC_write = 1'b0;
					bubble = 1'b0;
					addrSel = 2'b00;
					next_state = Branch_0_state;
				end
				
				else begin
					IF_write = 1'b1;
					PC_write = 1'b1;
					bubble = 1'b0;
					addrSel = 2'b00;
					next_state = NoHazard_state;
				end
			end
				
			Jump_state: begin
				IF_write = 1'b1;
				PC_write = 1'b1;
				bubble = 1'b1;
				addrSel = 2'b00;
				next_state = NoHazard_state;
			end
			
			Branch_0_state: begin
				if( ALUZero == 1'b0 ) begin
					IF_write = 1'b1;
					PC_write = 1'b1;
					bubble = 1'b1;
					addrSel = 2'b00;
					next_state = NoHazard_state;
				end
				else if( ALUZero == 1'b1 ) begin
					IF_write = 1'b0;
					PC_write = 1'b1;
					bubble = 1'b1;
					addrSel = 2'b10;
					next_state = Branch_1_state;
				end
				
			end
			
			Branch_1_state: begin
				// Unconditional return to no hazard state
				IF_write = 1'b1;
				PC_write = 1'b1;
				bubble = 1'b1;
				addrSel = 2'b00;
				next_state = NoHazard_state;
			end

			data_hazard_state: begin
				// Unconditional return to no hazard state
				IF_write = 1'b0;
					PC_write = 1'b0;
					bubble = 1'b1;
					addrSel = 2'b00;
				next_state = NoHazard_state;
			end
			
			default: begin
				next_state = NoHazard_state;
				PC_write = 1'bx;
				IF_write = 1'bx;
				bubble  = 1'bx;
				addrSel = 2'bxx;
			end
		endcase
	end
endmodule
