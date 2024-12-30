class htax_rx_agent_c extends uvm_agent;
	
	protected uvm_active_passive_enum is_active = UVM_PASSIVE;
	
	htax_rx_monitor_c rx_monitor;

	`uvm_component_utils_begin(htax_rx_agent_c)
		`uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
	`uvm_component_utils_end

	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rx_monitor = htax_rx_monitor_c::type_id::create("rx_monitor", this);
	endfunction : build_phase

endclass : htax_rx_agent_c

