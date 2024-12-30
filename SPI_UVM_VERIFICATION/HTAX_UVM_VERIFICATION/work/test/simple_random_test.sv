///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class simple_random_test extends base_test;

	`uvm_component_utils(simple_random_test)

	//Constructor
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	//UVM build phase
	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.tx_port[1].sequencer.run_phase","default_sequence",simple_random_seq::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	//UVM run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting Simple Random Sequence Test", UVM_NONE)
	endtask : run_phase

endclass : simple_random_test
