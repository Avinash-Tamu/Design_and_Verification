class router_simple_mcseq extends uvm_sequence ;

   `uvm_object_utils(router_simple_mcseq)
   `uvm_declare_p_sequencer(router_mcsequencer) 

    hbus_small_packet_seq h_small;
    hbus_set_default_regs_seq h_large;
    yapp_012_seq y_012;
   // Constructor
   function new(string name = "router_simple_mcseq");
      super.new(name);
   endfunction

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

    virtual task body();
        
        `uvm_do_on(h_small, p_sequencer.hbus_seqr)
        for (int i = 0; i < 3; i++) begin
            `uvm_do_on_with(y_012, p_sequencer.yapp_seqr, {y_012.req.addr == i;})
        end
        `uvm_do_on(h_large,p_sequencer.hbus_seqr)
        for (int i = 0; i < 5; i++) begin
            `uvm_do_on(y_012, p_sequencer.yapp_seqr)
        end
    endtask
endclass