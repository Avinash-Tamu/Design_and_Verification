//////////////////////////////////////////////////////////////////
// TOP-MODULE CREATED WITH PERL with the following attributes:

// number of vcs              : 2
// number of ports            : 4
// data-width                 : 64 
//////////////////////////////////////////////////////////////////

module htax_outport_data_mux #(
	parameter NUM_PORTS = 4,
	parameter PORTS_LG = 2,
	parameter VC = 2,
	parameter WIDTH = 64 

)(
	input wire          clk, res_n,
	input [NUM_PORTS-1:0]     inport_sel, //one-hot-sel for mux
	input wire          any_gnt,
	input [(WIDTH*NUM_PORTS)-1:0] data_in,
	input [NUM_PORTS-1:0]     eot_in,
	input wire [(VC*NUM_PORTS)-1:0] sot_in,
	output reg [WIDTH-1:0]    data_out,
	output reg          eot_out,
	output reg [VC-1:0]     sot_out
);

	reg                   any_gnt_reg;
	reg [NUM_PORTS-1:0]   inport_sel_reg;
	reg [VC-1:0]selected_sot;
	wire        selected_eot;

	always @( * )
	begin
		(* full_case *) (* parallel_case *)
		casex (inport_sel)
			4'b1xxx: selected_sot = sot_in[((4*VC)-1):(3*VC)];
			4'bx1xx: selected_sot = sot_in[((3*VC)-1):(2*VC)];
			4'bxx1x: selected_sot = sot_in[((2*VC)-1):(1*VC)];
			4'bxxx1: selected_sot = sot_in[((1*VC)-1):(0*VC)];
		endcase
	end

	assign selected_eot = |(eot_in & inport_sel_reg) & ~(&(eot_in));

	`ifdef ASYNC_RES
	always @(posedge clk or negedge res_n) `else
	always @(posedge clk) `endif
	begin
	if (!res_n) begin
	  inport_sel_reg <= {NUM_PORTS{1'b0}};
	  any_gnt_reg    <= 0;
	 end else begin
	  any_gnt_reg <= any_gnt;
	  
	  //if(any_gnt_reg)
	    inport_sel_reg <= inport_sel;
	 end
	end
	// Muxes for data, eot, sot
	`ifdef ASYNC_RES
	always @(posedge clk or negedge res_n) `else
	always @(posedge clk) `endif
	begin
		if (!res_n)
		begin
			data_out <= {WIDTH {1'b0}};
			sot_out <= {VC {1'b0}};
			eot_out <= 1'b0;
		end
		else
			begin
			(* full_case *) (* parallel_case *)
			casex (inport_sel_reg)
				4'b1xxx: data_out <= data_in[((4*WIDTH)-1):(3*WIDTH)];
				4'bx1xx: data_out <= data_in[((3*WIDTH)-1):(2*WIDTH)];
				4'bxx1x: data_out <= data_in[((2*WIDTH)-1):(1*WIDTH)];
				4'bxxx1: data_out <= data_in[((1*WIDTH)-1):(0*WIDTH)];
			endcase
			if ((|inport_sel && !any_gnt) )
				sot_out <= selected_sot;
			else
				sot_out <=  {VC{1'b0}};
			if (|inport_sel_reg && (!eot_out || (|selected_sot && (|inport_sel && !any_gnt) )))
				eot_out <= selected_eot;
			else
				eot_out <=  1'b0;
		end
	end

endmodule
