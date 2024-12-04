class htax_tx_agent_c extends uvm_agent;

	protected uvm_active_passive_enum is_active = UVM_ACTIVE;

	htax_tx_driver_c tx_driver;
	htax_tx_monitor_c tx_monitor;
	htax_sequencer_c sequencer;

	`uvm_component_utils_begin(htax_tx_agent_c)
		`uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
	`uvm_component_utils_end


	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		tx_monitor = htax_tx_monitor_c::type_id::create("tx_monitor",this);
		if (is_active==UVM_ACTIVE) begin
			tx_driver = htax_tx_driver_c::type_id::create("tx_driver",this);
			sequencer = htax_sequencer_c::type_id::create("sequencer",this);
		end
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		if (is_active==UVM_ACTIVE)
			tx_driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction : connect_phase

endclass : htax_tx_agent_c
