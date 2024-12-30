class htax_rx_driver_c extends uvm_driver	#(htax_packet_c);

	parameter PORT	=	`PORTS;
	parameter VC		=	`VC;
	parameter WIDTH	= `WIDTH;

	`uvm_component_utils(htax_rx_driver_c)

	virtual interface htax_rx_interface htax_rx_intf;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual htax_rx_interface)::get(this,"","rx_vif",htax_rx_intf))
			`uvm_fatal("NO_RX_VIF",{"Virtual interface needs to be set for ", get_full_name(),".rx_vif"})
	end : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			rst_signal();
		end
	endtask : run_phase

	task rst_signal();
    htax_rx_intf.rx_vc_gnt       = 'b0;
	entask : rst_signal

endclass : htax_rx_driver_c
