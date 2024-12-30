//////////////////////////////////////////////////////////////////
// ARBITER-FSM CREATED WITH PERL with the following attributes:

// module name                : htax_outport_arbiter
// number of requests         : 4
// name of request-signal     : reqs
// name of stop-signal        : stop
// use a stop-signal          : FALSE
// name of grant-signal       : grant
// generate binary grant      : FALSE
// hold binary grant          : TRUE
// size of binary grant       : 2
// name of binary grant signal: bin_gnt
// name of any_grant-signal   : any_gnt
// use any_grant-signal       : TRUE
// name of clock signal       : clk
// name of reset signal       : res_n
// is the reset active low?   : TRUE
// name of mask register      : mask
//////////////////////////////////////////////////////////////////

module htax_outport_arbiter (
		input wire				clk, res_n,
		input wire [7:0]	requests,
		output wire			any_gnt,
		output wire [3:0]	grant,
		input wire [1:0]	outport_vc_ack,
		input wire [3:0]	release_gnt,
		output reg [3:0]	channel_open
	);

	wire [3:0] reqs;
	wire [3:0] grant_w;
	wire en_arbiter, any_arbitration;
	wire stop_arbiter;
	
	assign any_arbitration	= |(release_gnt & channel_open);
	assign en_arbiter		= ~(|channel_open);
	//assign en_arbiter		= ~(|channel_open) | any_arbitration;
	assign stop_arbiter     = |channel_open;
	//assign stop_arbiter     = |channel_open && !(|channel_open && any_arbitration);

	// channel_open reg
	`ifdef ASYNC_RES
	always @(posedge clk or negedge res_n) `else
	always @(posedge clk) `endif
	begin
		if (!res_n)
			channel_open <= 4'b0;
		else
		begin
			if (en_arbiter && ((|reqs) != 1'b0))
				channel_open <= grant_w;
			else if (any_arbitration != 1'b0)
				channel_open <= 4'b0;
 		end
	end

	// Request generation
	wire [1:0] vc_reqs_w [3:0];
	assign vc_reqs_w[0] = requests[1:0];
	assign vc_reqs_w[1] = requests[3:2];
	assign vc_reqs_w[2] = requests[5:4];
	assign vc_reqs_w[3] = requests[7:6];


	assign reqs[0] = |(vc_reqs_w[0] & {outport_vc_ack[1], outport_vc_ack[0]});
	assign reqs[1] = |(vc_reqs_w[1] & {outport_vc_ack[1], outport_vc_ack[0]});
	assign reqs[2] = |(vc_reqs_w[2] & {outport_vc_ack[1], outport_vc_ack[0]});
	assign reqs[3] = |(vc_reqs_w[3] & {outport_vc_ack[1], outport_vc_ack[0]});


	assign any_gnt = |grant;

	// grant output:
	assign grant = (en_arbiter && (|reqs)) ? grant_w : 4'b0;

	//combinatoric arbiter logic
	 htax_combinatoric_arbiter htax_combinatoric_arbiter_I (
		.clk(clk),
		.res_n(res_n),
		.reqs(reqs),
		.any_gnt(),
		.stop(stop_arbiter),
		.gnts(grant_w)
		);

endmodule
