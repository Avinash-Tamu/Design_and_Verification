///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_tx_mon_packet_c extends uvm_sequence_item;

	parameter PORTS = `PORTS;
	parameter VC 		= `VC;
	parameter WIDTH = `WIDTH;

	int 							dest_port;
	bit 	[VC-1:0] 		vc;
	int 							length;
	bit 	[WIDTH-1:0]	data [];

	`uvm_object_utils_begin(htax_tx_mon_packet_c)
		`uvm_field_int			(dest_port,UVM_ALL_ON)
		`uvm_field_int			(vc,UVM_ALL_ON)
		`uvm_field_int			(length,UVM_ALL_ON)
		`uvm_field_array_int(data,UVM_ALL_ON)
	`uvm_object_utils_end

	function new (string name = "htax_tx_mon_packet_c");
		super.new(name);
		this.data = new[1];
	endfunction : new

endclass : htax_tx_mon_packet_c
