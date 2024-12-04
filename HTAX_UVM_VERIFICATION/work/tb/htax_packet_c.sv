class htax_packet_c extends uvm_sequence_item;
	
	parameter PORTS = `PORTS;
	parameter VC 		= `VC;
	parameter WIDTH = `WIDTH;
	
	rand int delay;
	rand int dest_port;
	rand bit [VC-1:0] vc;
	rand int length;
	rand bit [WIDTH-1:0] data [];

	// UVM macros for built-in automation
	`uvm_object_utils_begin(htax_packet_c)
		`uvm_field_int(delay,UVM_ALL_ON)
		`uvm_field_int(dest_port,UVM_ALL_ON)
		`uvm_field_int(vc,UVM_ALL_ON)
		`uvm_field_int(length,UVM_ALL_ON)
		`uvm_field_array_int(data,UVM_ALL_ON)
	`uvm_object_utils_end

	//constructor
	function new (	string name="htax_packet_c");
		super.new(name);
	endfunction

	//Constraint 1 : delay should be between 1 and 20
	constraint delay_cons { delay inside {[1:20]};}

	//Constraint 2 : dest_port should be between 0 and (PORTS-1)
	constraint dest_port_cons {soft dest_port inside {[0:PORTS-1]};}

	//Constraint 3 : VC should be valid VC request
	constraint vc_cons {vc > 0;}

	//Constraint 4 : Data-length can be maximum 80 
	constraint length_cons {soft length inside {[3:63]};
													data.size() == length;}

endclass : htax_packet_c
