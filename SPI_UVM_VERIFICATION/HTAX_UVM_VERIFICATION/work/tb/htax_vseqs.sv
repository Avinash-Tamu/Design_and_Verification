///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_base_vseq extends uvm_sequence #(htax_packet_c);
	
	`uvm_object_utils(htax_base_vseq)
	`uvm_declare_p_sequencer(htax_virtual_sequencer_c)

	function new (string name = "htax_base_vseq");
		super.new(name);
	endfunction : new

	task pre_body();
		if(starting_phase!= null) begin
			starting_phase.raise_objection(this, get_type_name());
			`uvm_info(get_type_name,"raise objection", UVM_NONE)
		end
	endtask : pre_body

	task post_body();
		if(starting_phase != null) begin
			starting_phase.drop_objection(this, get_type_name());
			`uvm_info(get_type_name,"dropping objection", UVM_NONE)
		end
	endtask : post_body

endclass : htax_base_vseq


//This vsequence is included in the "test/multiport_sequential_random_test.sv"

//class simple_random_vsequence extends htax_base_vseq;
//
//	`uvm_object_utils(simple_random_vsequence)
//	
//	rand int port;
//
//	function new (string name = "simple_random_vsequence");
//		super.new(name);
//	endfunction : new
//
//	task body();
//		repeat(10) begin
//			port = $urandom_range(0,3);
//			`uvm_do_on(req, p_sequencer.htax_seqr[port])
//		end
//	endtask : body
//
//endclass : simple_random_vsequence
//
