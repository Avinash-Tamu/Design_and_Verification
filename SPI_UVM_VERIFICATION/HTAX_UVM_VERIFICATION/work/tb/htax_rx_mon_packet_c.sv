///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_rx_mon_packet_c extends uvm_sequence_item;

	parameter PORTS = `PORTS;
	parameter WIDTH = `WIDTH;

	bit [WIDTH-1:0] data [];

	`uvm_object_utils_begin(htax_rx_mon_packet_c)
		`uvm_field_array_int(data,UVM_ALL_ON)
	`uvm_object_utils_end

	function new (string name = "htax_rx_mon_packet_c");
		super.new(name);
		this.data = new[1];
	endfunction : new

endclass : htax_rx_mon_packet_c
