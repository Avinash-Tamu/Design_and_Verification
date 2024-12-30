/*
================================================================================
Copyright (c) 2011 Computer Architecture Group, University of Heidelberg

All rights reserved.

THIS CODE IS UNDER A LICENSE SPECIFIED IN THE ENCLOSED LICENSE AGREEMENT.
ANY BREACH OF ANY TERM OF THIS LICENSE SHALL RESULT IN THE IMMEDIATE
REVOCATION OF ALL RIGHTS TO REDISTRIBUTE, ACCESS OR USE THIS MATERIAL.
THIS MATERIAL IS PROVIDED BY THE UNIVERSITY OF HEIDELBERG AND ANY COPYRIGHT
HOLDERS AND CONTRIBUTORS "AS IS" IN ITS CURRENT CONDITION AND WITHOUT ANY
REPRESENTATIONS, GUARANTEE, OR WARRANTY OF ANY KIND OR IN ANY WAY RELATED
TO SUPPORT, INDEMNITY, ERROR FREE OR UNINTERRUPTED OPERATION, OR THAT IT
IS FREE FROM DEFECTS OR VIRUSES.
SEE THE ENCLOSED LICENSE FILE FOR MORE INFORMATION.

University of Heidelberg
Computer Architecture Group
B6 26
68131 Mannheim
Germany
http://ra.ziti.uni-heidelberg.de

================================================================================

Author(s):    HTAX NoC Compiler
*/

//////////////////////////////////////////////////////////////////
// TOP-MODULE CREATED WITH PERL with the following attributes:

// module name                : #htax_top
// number of requests         : 4
// request-signal             : reqs
// stop-signal                : stop
// grant-signal               : grant
// generate binary grant      : FALSE
// hold binary grant          : TRUE
// size of binary grant       : 2
// name of binary grant signal: bin_gnt
// any_grant-signal           : any_gnt
// use any_grant-signal       : TRUE
// delay of any_gnt           : 0
// clock                      : clk
// reset                      : res_n
// use active low reset       : TRUE
// state registers name       : state
// next_state registers name  : next
// xilinx device              : TRUE
// number of ports            : 4// data-width                 : 64 
//////////////////////////////////////////////////////////////////

module htax_top #(
	parameter PORTS = 4,
	parameter PORTS_LG = 2,
	parameter LOGVC = 2,
	parameter VC = 2,
	parameter WIDTH = 64 )

(
	//port 0 
	//TX
	input wire  [PORTS-1:0] fu0_tx_outport_req,
	input wire  [VC-1:0]    fu0_tx_vc_req,
	output reg  [VC-1:0]    fu0_tx_vc_gnt,
	input wire  [WIDTH-1:0] fu0_tx_data,
	input wire  [VC-1:0]    fu0_tx_sot,
	input wire              fu0_tx_eot,
	input wire              fu0_tx_release_gnt,

//RX
	output wire [VC-1:0]    fu0_rx_vc_req,
	input wire  [VC-1:0]    fu0_rx_vc_gnt,
	output wire [WIDTH-1:0] fu0_rx_data,
	output wire             fu0_rx_eot,
	output wire [VC-1:0]    fu0_rx_sot,

	//port 1 
	//TX
	input wire  [PORTS-1:0] fu1_tx_outport_req,
	input wire  [VC-1:0]    fu1_tx_vc_req,
	output reg  [VC-1:0]    fu1_tx_vc_gnt,
	input wire  [WIDTH-1:0] fu1_tx_data,
	input wire  [VC-1:0]    fu1_tx_sot,
	input wire              fu1_tx_eot,
	input wire              fu1_tx_release_gnt,

//RX
	output wire [VC-1:0]    fu1_rx_vc_req,
	input wire  [VC-1:0]    fu1_rx_vc_gnt,
	output wire [WIDTH-1:0] fu1_rx_data,
	output wire             fu1_rx_eot,
	output wire [VC-1:0]    fu1_rx_sot,

	//port 2 
	//TX
	input wire  [PORTS-1:0] fu2_tx_outport_req,
	input wire  [VC-1:0]    fu2_tx_vc_req,
	output reg  [VC-1:0]    fu2_tx_vc_gnt,
	input wire  [WIDTH-1:0] fu2_tx_data,
	input wire  [VC-1:0]    fu2_tx_sot,
	input wire              fu2_tx_eot,
	input wire              fu2_tx_release_gnt,

//RX
	output wire [VC-1:0]    fu2_rx_vc_req,
	input wire  [VC-1:0]    fu2_rx_vc_gnt,
	output wire [WIDTH-1:0] fu2_rx_data,
	output wire             fu2_rx_eot,
	output wire [VC-1:0]    fu2_rx_sot,

	//port 3 
	//TX
	input wire  [PORTS-1:0] fu3_tx_outport_req,
	input wire  [VC-1:0]    fu3_tx_vc_req,
	output reg  [VC-1:0]    fu3_tx_vc_gnt,
	input wire  [WIDTH-1:0] fu3_tx_data,
	input wire  [VC-1:0]    fu3_tx_sot,
	input wire              fu3_tx_eot,
	input wire              fu3_tx_release_gnt,

//RX
	output wire [VC-1:0]    fu3_rx_vc_req,
	input wire  [VC-1:0]    fu3_rx_vc_gnt,
	output wire [WIDTH-1:0] fu3_rx_data,
	output wire             fu3_rx_eot,
	output wire [VC-1:0]    fu3_rx_sot,

	//vital signals
	input wire clk, res_n
);

//any grants
wire fu0_any_gnt;
wire fu1_any_gnt;
wire fu2_any_gnt;
wire fu3_any_gnt;

//inport_acks
wire [PORTS-1:0] fu0_inport_ack;
wire [PORTS-1:0] fu1_inport_ack;
wire [PORTS-1:0] fu2_inport_ack;
wire [PORTS-1:0] fu3_inport_ack;

//inport_requests
wire [VC*PORTS-1:0] fu0_inport_requests;
wire [VC*PORTS-1:0] fu1_inport_requests;
wire [VC*PORTS-1:0] fu2_inport_requests;
wire [VC*PORTS-1:0] fu3_inport_requests;

//flop the last requested port
reg [PORTS-1:0] fu0_requested_port;
reg [PORTS-1:0] fu1_requested_port;
reg [PORTS-1:0] fu2_requested_port;
reg [PORTS-1:0] fu3_requested_port;
`ifdef ASYNC_RES
always @(posedge clk or negedge res_n) `else
always @(posedge clk) `endif
begin
	if(!res_n)
	begin
		fu0_requested_port <= 4'b0;
		fu1_requested_port <= 4'b0;
		fu2_requested_port <= 4'b0;
		fu3_requested_port <= 4'b0;
	end
	else
	begin
		if (|(fu0_tx_vc_req & fu0_tx_vc_gnt) && (|fu0_tx_outport_req)) fu0_requested_port <= fu0_tx_outport_req;
		if (|(fu1_tx_vc_req & fu1_tx_vc_gnt) && (|fu1_tx_outport_req)) fu1_requested_port <= fu1_tx_outport_req;
		if (|(fu2_tx_vc_req & fu2_tx_vc_gnt) && (|fu2_tx_outport_req)) fu2_requested_port <= fu2_tx_outport_req;
		if (|(fu3_tx_vc_req & fu3_tx_vc_gnt) && (|fu3_tx_outport_req)) fu3_requested_port <= fu3_tx_outport_req;
	end
end
`ifdef ASYNC_RES
always @(posedge clk or negedge res_n) `else
always @(posedge clk) `endif
begin
	if(!res_n)
	begin
		fu0_tx_vc_gnt <= 2'b0;
		fu1_tx_vc_gnt <= 2'b0;
		fu2_tx_vc_gnt <= 2'b0;
		fu3_tx_vc_gnt <= 2'b0;
	end
	else
	begin
		fu0_tx_vc_gnt <= ( {fu3_inport_ack[0], fu3_inport_ack[0]} & fu3_rx_vc_gnt ) |
										 ( {fu2_inport_ack[0], fu2_inport_ack[0]} & fu2_rx_vc_gnt ) |
										 ( {fu1_inport_ack[0], fu1_inport_ack[0]} & fu1_rx_vc_gnt ) |
										 ( {fu0_inport_ack[0], fu0_inport_ack[0]} & fu0_rx_vc_gnt );
		fu1_tx_vc_gnt <= ( {fu3_inport_ack[1], fu3_inport_ack[1]} & fu3_rx_vc_gnt ) |
										 ( {fu2_inport_ack[1], fu2_inport_ack[1]} & fu2_rx_vc_gnt ) |
										 ( {fu1_inport_ack[1], fu1_inport_ack[1]} & fu1_rx_vc_gnt ) |
										 ( {fu0_inport_ack[1], fu0_inport_ack[1]} & fu0_rx_vc_gnt );
		fu2_tx_vc_gnt <= ( {fu3_inport_ack[2], fu3_inport_ack[2]} & fu3_rx_vc_gnt ) |
										 ( {fu2_inport_ack[2], fu2_inport_ack[2]} & fu2_rx_vc_gnt ) |
										 ( {fu1_inport_ack[2], fu1_inport_ack[2]} & fu1_rx_vc_gnt ) |
										 ( {fu0_inport_ack[2], fu0_inport_ack[2]} & fu0_rx_vc_gnt );
		fu3_tx_vc_gnt <= ( {fu3_inport_ack[3], fu3_inport_ack[3]} & fu3_rx_vc_gnt ) |
										 ( {fu2_inport_ack[3], fu2_inport_ack[3]} & fu2_rx_vc_gnt ) |
										 ( {fu1_inport_ack[3], fu1_inport_ack[3]} & fu1_rx_vc_gnt ) |
										 ( {fu0_inport_ack[3], fu0_inport_ack[3]} & fu0_rx_vc_gnt );
	end
end

//Mask inport vc requests so only the correct outport will be requested
assign fu0_inport_requests = {{fu3_tx_outport_req[0], fu3_tx_outport_req[0]} & fu3_tx_vc_req,
															{fu2_tx_outport_req[0], fu2_tx_outport_req[0]} & fu2_tx_vc_req,
															{fu1_tx_outport_req[0], fu1_tx_outport_req[0]} & fu1_tx_vc_req,
															{fu0_tx_outport_req[0], fu0_tx_outport_req[0]} & fu0_tx_vc_req};

assign fu1_inport_requests = {{fu3_tx_outport_req[1], fu3_tx_outport_req[1]} & fu3_tx_vc_req,
															{fu2_tx_outport_req[1], fu2_tx_outport_req[1]} & fu2_tx_vc_req,
															{fu1_tx_outport_req[1], fu1_tx_outport_req[1]} & fu1_tx_vc_req,
															{fu0_tx_outport_req[1], fu0_tx_outport_req[1]} & fu0_tx_vc_req};

assign fu2_inport_requests = {{fu3_tx_outport_req[2], fu3_tx_outport_req[2]} & fu3_tx_vc_req,
															{fu2_tx_outport_req[2], fu2_tx_outport_req[2]} & fu2_tx_vc_req,
															{fu1_tx_outport_req[2], fu1_tx_outport_req[2]} & fu1_tx_vc_req,
															{fu0_tx_outport_req[2], fu0_tx_outport_req[2]} & fu0_tx_vc_req};

assign fu3_inport_requests = {{fu3_tx_outport_req[3], fu3_tx_outport_req[3]} & fu3_tx_vc_req,
															{fu2_tx_outport_req[3], fu2_tx_outport_req[3]} & fu2_tx_vc_req,
															{fu1_tx_outport_req[3], fu1_tx_outport_req[3]} & fu1_tx_vc_req,
															{fu0_tx_outport_req[3], fu0_tx_outport_req[3]} & fu0_tx_vc_req};

//OR togehter the vc requests for a specific outport
assign fu0_rx_vc_req = {({fu3_tx_outport_req[0], fu3_tx_outport_req[0]} & fu3_tx_vc_req)|
												({fu2_tx_outport_req[0], fu2_tx_outport_req[0]} & fu2_tx_vc_req)|
												({fu1_tx_outport_req[0], fu1_tx_outport_req[0]} & fu1_tx_vc_req)|
												({fu0_tx_outport_req[0], fu0_tx_outport_req[0]} & fu0_tx_vc_req)};

assign fu1_rx_vc_req = {({fu3_tx_outport_req[1], fu3_tx_outport_req[1]} & fu3_tx_vc_req)|
												({fu2_tx_outport_req[1], fu2_tx_outport_req[1]} & fu2_tx_vc_req)|
												({fu1_tx_outport_req[1], fu1_tx_outport_req[1]} & fu1_tx_vc_req)|
												({fu0_tx_outport_req[1], fu0_tx_outport_req[1]} & fu0_tx_vc_req)};

assign fu2_rx_vc_req = {({fu3_tx_outport_req[2], fu3_tx_outport_req[2]} & fu3_tx_vc_req)|
												({fu2_tx_outport_req[2], fu2_tx_outport_req[2]} & fu2_tx_vc_req)|
												({fu1_tx_outport_req[2], fu1_tx_outport_req[2]} & fu1_tx_vc_req)|
												({fu0_tx_outport_req[2], fu0_tx_outport_req[2]} & fu0_tx_vc_req)};

assign fu3_rx_vc_req = {({fu3_tx_outport_req[3], fu3_tx_outport_req[3]} & fu3_tx_vc_req)|
												({fu2_tx_outport_req[3], fu2_tx_outport_req[3]} & fu2_tx_vc_req)|
												({fu1_tx_outport_req[3], fu1_tx_outport_req[3]} & fu1_tx_vc_req)|
												({fu0_tx_outport_req[3], fu0_tx_outport_req[3]} & fu0_tx_vc_req)};

	//Mask out release grant signal for small packets to avoid false arbitrations
	//If sot is asserted in the same cycle the release_gnt signal is masked out.
	//Instead the release_gnt signal is flopped in the release_gnt_delayed FF
	//Result is that the release_gnt signal is delayed by one cycle for minimum sized packets.
	wire 	fu0_tx_release_gnt_mask, 	fu1_tx_release_gnt_mask, 	fu2_tx_release_gnt_mask, 	fu3_tx_release_gnt_mask;
	reg 	fu0_sot_and_release_seen, 	fu1_sot_and_release_seen, 	fu2_sot_and_release_seen, 	fu3_sot_and_release_seen;
	wire 	fu0_tx_release_gnt_delayed, 	fu1_tx_release_gnt_delayed, 	fu2_tx_release_gnt_delayed, 	fu3_tx_release_gnt_delayed;
	assign fu0_tx_release_gnt_mask = !(|fu0_tx_sot) && fu0_tx_release_gnt;
	assign fu1_tx_release_gnt_mask = !(|fu1_tx_sot) && fu1_tx_release_gnt;
	assign fu2_tx_release_gnt_mask = !(|fu2_tx_sot) && fu2_tx_release_gnt;
	assign fu3_tx_release_gnt_mask = !(|fu3_tx_sot) && fu3_tx_release_gnt;

	always @(posedge clk)
	begin
	if(|fu0_tx_sot && fu0_tx_release_gnt)
		fu0_sot_and_release_seen <= 1'b1;
	else
		fu0_sot_and_release_seen <= 1'b0;
	end

	always @(posedge clk)
	begin
	if(|fu1_tx_sot && fu1_tx_release_gnt)
		fu1_sot_and_release_seen <= 1'b1;
	else
		fu1_sot_and_release_seen <= 1'b0;
	end

	always @(posedge clk)
	begin
	if(|fu2_tx_sot && fu2_tx_release_gnt)
		fu2_sot_and_release_seen <= 1'b1;
	else
		fu2_sot_and_release_seen <= 1'b0;
	end

	always @(posedge clk)
	begin
	if(|fu3_tx_sot && fu3_tx_release_gnt)
		fu3_sot_and_release_seen <= 1'b1;
	else
		fu3_sot_and_release_seen <= 1'b0;
	end

assign fu0_tx_release_gnt_delayed = fu0_sot_and_release_seen && !fu0_tx_release_gnt;
assign fu1_tx_release_gnt_delayed = fu1_sot_and_release_seen && !fu1_tx_release_gnt;
assign fu2_tx_release_gnt_delayed = fu2_sot_and_release_seen && !fu2_tx_release_gnt;
assign fu3_tx_release_gnt_delayed = fu3_sot_and_release_seen && !fu3_tx_release_gnt;

wire [PORTS-1:0] fu0_channel_open;
wire [PORTS-1:0] fu1_channel_open;
wire [PORTS-1:0] fu2_channel_open;
wire [PORTS-1:0] fu3_channel_open;
//Port arbiters
htax_outport_arbiter htax_outport_arbiter_FU0
(
	.clk(clk),
	.res_n(res_n),
	.requests(fu0_inport_requests),
	.any_gnt(fu0_any_gnt),
	.grant(fu0_inport_ack),
	.outport_vc_ack(fu0_rx_vc_gnt),
	.channel_open(fu0_channel_open),
	.release_gnt({(fu3_tx_release_gnt_mask | fu3_tx_release_gnt_delayed) & fu3_requested_port[0], (fu2_tx_release_gnt_mask | fu2_tx_release_gnt_delayed) & fu2_requested_port[0], (fu1_tx_release_gnt_mask | fu1_tx_release_gnt_delayed) & fu1_requested_port[0], (fu0_tx_release_gnt_mask | fu0_tx_release_gnt_delayed) & fu0_requested_port[0]})
);

htax_outport_arbiter htax_outport_arbiter_FU1
(
	.clk(clk),
	.res_n(res_n),
	.requests(fu1_inport_requests),
	.any_gnt(fu1_any_gnt),
	.grant(fu1_inport_ack),
	.outport_vc_ack(fu1_rx_vc_gnt),
	.channel_open(fu1_channel_open),
	.release_gnt({(fu3_tx_release_gnt_mask | fu3_tx_release_gnt_delayed) & fu3_requested_port[1], (fu2_tx_release_gnt_mask | fu2_tx_release_gnt_delayed) & fu2_requested_port[1], (fu1_tx_release_gnt_mask | fu1_tx_release_gnt_delayed) & fu1_requested_port[1], (fu0_tx_release_gnt_mask | fu0_tx_release_gnt_delayed) & fu0_requested_port[1]})
);

htax_outport_arbiter htax_outport_arbiter_FU2
(
	.clk(clk),
	.res_n(res_n),
	.requests(fu2_inport_requests),
	.any_gnt(fu2_any_gnt),
	.grant(fu2_inport_ack),
	.outport_vc_ack(fu2_rx_vc_gnt),
	.channel_open(fu2_channel_open),
	.release_gnt({(fu3_tx_release_gnt_mask | fu3_tx_release_gnt_delayed) & fu3_requested_port[2], (fu2_tx_release_gnt_mask | fu2_tx_release_gnt_delayed) & fu2_requested_port[2], (fu1_tx_release_gnt_mask | fu1_tx_release_gnt_delayed) & fu1_requested_port[2], (fu0_tx_release_gnt_mask | fu0_tx_release_gnt_delayed) & fu0_requested_port[2]})
);

htax_outport_arbiter htax_outport_arbiter_FU3
(
	.clk(clk),
	.res_n(res_n),
	.requests(fu3_inport_requests),
	.any_gnt(fu3_any_gnt),
	.grant(fu3_inport_ack),
	.outport_vc_ack(fu3_rx_vc_gnt),
	.channel_open(fu3_channel_open),
	.release_gnt({(fu3_tx_release_gnt_mask | fu3_tx_release_gnt_delayed) & fu3_requested_port[3], (fu2_tx_release_gnt_mask | fu2_tx_release_gnt_delayed) & fu2_requested_port[3], (fu1_tx_release_gnt_mask | fu1_tx_release_gnt_delayed) & fu1_requested_port[3], (fu0_tx_release_gnt_mask | fu0_tx_release_gnt_delayed) & fu0_requested_port[3]})
);

//Outport data muxes
htax_outport_data_mux #(
	.VC(VC),
	.WIDTH(WIDTH),
	.NUM_PORTS(PORTS),
	.PORTS_LG(PORTS_LG)
)htax_outport_data_mux_FU0 (
	.clk(clk),
	.res_n(res_n),
	.inport_sel(fu0_inport_ack | fu0_channel_open),
	.any_gnt(fu0_any_gnt),
	.data_in({fu3_tx_data, fu2_tx_data, fu1_tx_data, fu0_tx_data}),
	.eot_in({fu3_tx_eot, fu2_tx_eot, fu1_tx_eot, fu0_tx_eot}),
	.sot_in({fu3_tx_sot, fu2_tx_sot, fu1_tx_sot, fu0_tx_sot}),
	.data_out(fu0_rx_data),
	.eot_out(fu0_rx_eot),
	.sot_out(fu0_rx_sot)
);

htax_outport_data_mux #(
	.VC(VC),
	.WIDTH(WIDTH),
	.NUM_PORTS(PORTS),
	.PORTS_LG(PORTS_LG)
)htax_outport_data_mux_FU1 (
	.clk(clk),
	.res_n(res_n),
	.inport_sel(fu1_inport_ack | fu1_channel_open),
	.any_gnt(fu1_any_gnt),
	.data_in({fu3_tx_data, fu2_tx_data, fu1_tx_data, fu0_tx_data}),
	.eot_in({fu3_tx_eot, fu2_tx_eot, fu1_tx_eot, fu0_tx_eot}),
	.sot_in({fu3_tx_sot, fu2_tx_sot, fu1_tx_sot, fu0_tx_sot}),
	.data_out(fu1_rx_data),
	.eot_out(fu1_rx_eot),
	.sot_out(fu1_rx_sot)
);

htax_outport_data_mux #(
	.VC(VC),
	.WIDTH(WIDTH),
	.NUM_PORTS(PORTS),
	.PORTS_LG(PORTS_LG)
)htax_outport_data_mux_FU2 (
	.clk(clk),
	.res_n(res_n),
	.inport_sel(fu2_inport_ack | fu2_channel_open),
	.any_gnt(fu2_any_gnt),
	.data_in({fu3_tx_data, fu2_tx_data, fu1_tx_data, fu0_tx_data}),
	.eot_in({fu3_tx_eot, fu2_tx_eot, fu1_tx_eot, fu0_tx_eot}),
	.sot_in({fu3_tx_sot, fu2_tx_sot, fu1_tx_sot, fu0_tx_sot}),
	.data_out(fu2_rx_data),
	.eot_out(fu2_rx_eot),
	.sot_out(fu2_rx_sot)
);

htax_outport_data_mux #(
	.VC(VC),
	.WIDTH(WIDTH),
	.NUM_PORTS(PORTS),
	.PORTS_LG(PORTS_LG)
)htax_outport_data_mux_FU3 (
	.clk(clk),
	.res_n(res_n),
	.inport_sel(fu3_inport_ack | fu3_channel_open),
	.any_gnt(fu3_any_gnt),
	.data_in({fu3_tx_data, fu2_tx_data, fu1_tx_data, fu0_tx_data}),
	.eot_in({fu3_tx_eot, fu2_tx_eot, fu1_tx_eot, fu0_tx_eot}),
	.sot_in({fu3_tx_sot, fu2_tx_sot, fu1_tx_sot, fu0_tx_sot}),
	.data_out(fu3_rx_data),
	.eot_out(fu3_rx_eot),
	.sot_out(fu3_rx_sot)
);

endmodule
