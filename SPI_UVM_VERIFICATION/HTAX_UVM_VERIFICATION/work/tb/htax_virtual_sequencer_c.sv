///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_virtual_sequencer_c extends uvm_sequencer;

	`uvm_component_utils(htax_virtual_sequencer_c)

	htax_sequencer_c htax_seqr [0:3];

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : htax_virtual_sequencer_c  
