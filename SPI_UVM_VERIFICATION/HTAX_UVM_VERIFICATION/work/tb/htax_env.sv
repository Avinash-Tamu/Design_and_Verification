class htax_env extends uvm_env;

	`uvm_component_utils(htax_env)

	htax_tx_agent_c tx_port[0:3];
	htax_rx_agent_c rx_port[0:3];

	htax_scoreboard_c htax_sb;
	
	htax_virtual_sequencer_c vsequencer;
	
	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		tx_port[0] = htax_tx_agent_c::type_id::create("tx_port[0]",this);
		tx_port[1] = htax_tx_agent_c::type_id::create("tx_port[1]",this);
		tx_port[2] = htax_tx_agent_c::type_id::create("tx_port[2]",this);
		tx_port[3] = htax_tx_agent_c::type_id::create("tx_port[3]",this);
		rx_port[0] = htax_rx_agent_c::type_id::create("rx_port[0]",this);
		rx_port[1] = htax_rx_agent_c::type_id::create("rx_port[1]",this);
		rx_port[2] = htax_rx_agent_c::type_id::create("rx_port[2]",this);
		rx_port[3] = htax_rx_agent_c::type_id::create("rx_port[3]",this);
		htax_sb		 = htax_scoreboard_c::type_id::create("htax_sb",this);
		vsequencer = htax_virtual_sequencer_c::type_id::create("vsequencer",this);
	endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
		tx_port[0].tx_monitor.tx_collect_port.connect(htax_sb.tx0_export);
		tx_port[1].tx_monitor.tx_collect_port.connect(htax_sb.tx1_export);
		tx_port[2].tx_monitor.tx_collect_port.connect(htax_sb.tx2_export);
		tx_port[3].tx_monitor.tx_collect_port.connect(htax_sb.tx3_export);
		rx_port[0].rx_monitor.rx_collect_port.connect(htax_sb.rx0_export);
		rx_port[1].rx_monitor.rx_collect_port.connect(htax_sb.rx1_export);
		rx_port[2].rx_monitor.rx_collect_port.connect(htax_sb.rx2_export);
		rx_port[3].rx_monitor.rx_collect_port.connect(htax_sb.rx3_export);

		vsequencer.htax_seqr[0] = tx_port[0].sequencer;
		vsequencer.htax_seqr[1] = tx_port[1].sequencer;
		vsequencer.htax_seqr[2] = tx_port[2].sequencer;
		vsequencer.htax_seqr[3] = tx_port[3].sequencer;
	endfunction : connect_phase

endclass : htax_env
