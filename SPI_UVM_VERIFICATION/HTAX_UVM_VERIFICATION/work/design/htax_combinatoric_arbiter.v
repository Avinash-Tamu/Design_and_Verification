
/* ============================================================
*
* Copyright (c) 2011 Computer Architecture Group, University of Heidelberg & EXTOLL GmbH
*
* This file is confidential and may not be distributed.
*
* All rights reserved.
*
* University of Heidelberg
* Computer Architecture Group
* B6 26
* 68131 Mannheim
* Germany
* http://www.ra.ziti.uni-heidelberg.de
*
*
* Author(s):     Benjamin Geib
*
* Create Date:   05/13/09
* Last Modified: 01/13/14
* Design Name:   CAG Building Blocks
* Module Name:   htax_combinatoric_arbiter
* Description:   generates a binary output from an one-hot coded input
*
* Revision:      Revision 1.0
*
* ===========================================================*/
//////////////////////////////////////////////////////////////////
// ARBITER-FSM CREATED WITH PERL with the following attributes:

// module name                : htax_combinatoric_arbiter
// number of requests         : 4
// name of request-signal     : reqs
// name of stop-signal        : stop
// use a stop-signal          : TRUE
// use one-hot coded grant    : TRUE
// name of oh_grant-signal    : gnts
// generate binary grant      : FALSE
// hold binary grant          : TRUE
// size of binary grant       : 1
// name of binary grant signal: bin_gnt
// name of any_grant-signal   : any_gnt
// use an any_grant-signal    : TRUE
// name of clock signal       : clk
// name of reset signal       : res_n
// create a priority arbiter? : TRUE
// name of mask register      : mask
// step priority on input?    : FALSE
// name of mask register      : mask
// arbitrate clockwise?       : TRUE
// use asynchronous outputs?  : TRUE
// generate coverage code?    : FALSE
//////////////////////////////////////////////////////////////////

module htax_combinatoric_arbiter (
		input wire			clk, res_n,
		input wire [3:0]	reqs,
		input wire			stop,
		output wire			any_gnt,
		output wire [3:0]	gnts
	);

	wire [3:0]	int_reqs;
	assign int_reqs = {reqs[0], reqs[1], reqs[2], reqs[3]};

	reg [3:0]	mask;

	wire [3:0]	gnts_w;
	wire		any_gnt_w;

	wire [3:0]	g0;
	wire [3:0]	g1;

	wire [3:0]	p0;
	wire [1:0]	p1;
	wire		p2;

	wire [1:0]	r1;
	wire		r2;

	wire [1:0]	s0;
	wire		s1;

	assign g0[0] = int_reqs[0] | s0[0];
	assign g0[1] = int_reqs[1] & s0[0];
	assign g0[2] = int_reqs[2] | s0[1];
	assign g0[3] = int_reqs[3] & s0[1];

	assign g1[0] = g0[0] | s1;
	assign g1[1] = g0[1] | s1;
	assign g1[2] = g0[2] & s1;
	assign g1[3] = g0[3] & s1;

	// p wire assignments:
	assign p0 = int_reqs & mask;

	assign p1[0] = p0[0] | p0[1];
	assign p1[1] = p0[2] | p0[3];

	assign p2 = |p1;

	// r wire assignments:
	assign r1[0] = int_reqs[0] | int_reqs[1];
	assign r1[1] = int_reqs[2] | int_reqs[3];

	assign r2 = |r1;

	assign s0[0] = (p1[0]) ? p0[1] : int_reqs[1];
	assign s0[1] = (p1[1]) ? p0[3] : int_reqs[3];

	assign s1 = (p2) ? p1[1] : r1[1];

	// gnts_w assignments:
	assign gnts_w[0] = g1[0] & ~g1[1];
	assign gnts_w[1] = g1[1] & ~g1[2];
	assign gnts_w[2] = g1[2] & ~g1[3];
	assign gnts_w[3] = g1[3];

	assign any_gnt_w = r2 | p2;

	// Mask register:
	`ifdef ASYNC_RES
	always @(posedge clk or negedge res_n) `else
	always @(posedge clk) `endif
	begin
		if (!res_n)
			mask <= 4'b0;
		else
		begin
			if (!stop && any_gnt_w)
				mask <= g1 >> 1;
		end
	end

	// gnts output:
	assign gnts = (stop) ? 4'b0 : {gnts_w[0], gnts_w[1], gnts_w[2], gnts_w[3]};

	// generation of any_gnt output:
	assign any_gnt = (stop) ? 1'b0 : any_gnt_w;

endmodule
