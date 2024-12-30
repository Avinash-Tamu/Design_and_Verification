///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_base_seq extends uvm_sequence #(htax_packet_c);

	`uvm_object_utils(htax_base_seq)

	function new ( string name = "htax_base_seq");
		super.new(name);
	endfunction : new

	task pre_body();
		if (starting_phase != null) begin
			starting_phase.raise_objection(this,get_type_name());
			`uvm_info(get_type_name(),"raise_objection",UVM_NONE)
		end
	endtask: pre_body
	
	task post_body();
		if (starting_phase != null) begin
			starting_phase.drop_objection(this,get_type_name());
			`uvm_info(get_type_name(),"drop_objection",UVM_NONE)
		end
	endtask: post_body

endclass : htax_base_seq


class simple_random_seq extends htax_base_seq;

	`uvm_object_utils(simple_random_seq)

	function new ( string name = "simple_random_seq");
    super.new(name);
  endfunction : new


	virtual task body();
		`uvm_info(get_type_name(),"Executing simple random sequence with 5 transactions", UVM_NONE)
		repeat(15) begin
			`uvm_do(req)
		end
	endtask

	

endclass : simple_random_seq

