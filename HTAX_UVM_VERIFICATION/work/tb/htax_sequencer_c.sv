class htax_sequencer_c extends uvm_sequencer #(htax_packet_c);
	
	`uvm_component_utils(htax_sequencer_c)

	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass : htax_sequencer_c
