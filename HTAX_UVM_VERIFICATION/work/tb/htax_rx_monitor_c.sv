///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_rx_monitor_c extends uvm_monitor;
		
	`uvm_component_utils(htax_rx_monitor_c)
	
	//Analysis port to communicate with Scoreboard
	uvm_analysis_port #(htax_rx_mon_packet_c) rx_collect_port;

	virtual interface htax_rx_interface htax_rx_intf;
	htax_rx_mon_packet_c rx_mon_packet;
	int pkt_len;

  covergroup cover_htax_rx_intf;
		option.per_instance = 1;
		option.name = "cover_htax_rx_intf";

	// Coverpoint for rx_data:
		RX_DATA: coverpoint htax_rx_intf.rx_data {bins b1 = {[0:$]};}
	endgroup 

  covergroup cover_rx_eot;
		option.per_instance = 1;
		option.name = "cover_rx_eot";
	// Coverpoint for rx_eot:
		RX_EOT: coverpoint htax_rx_intf.rx_eot {																							bins eot [] = {1};}
  endgroup	

	function new (string name, uvm_component parent);
		super.new(name, parent);
		rx_collect_port = new ("rx_collect_port", this);
		rx_mon_packet 	= new();
		
		//Handle for the covergroup cover_htax_rx_intf
		this.cover_htax_rx_intf = new();
		this.cover_rx_eot = new();
	endfunction : new

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual htax_rx_interface)::get(this,"","rx_vif",htax_rx_intf))
			`uvm_fatal("RX_VIF",{"Virtual Interface needs to be set for ",get_full_name(),".rx_vif"})
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			pkt_len=0;
			//Wait for rising edge of htax_rx_intf.rx_sot
			@(posedge (|htax_rx_intf.rx_sot))
			
			//On consequtive cycles append htax_rx_intf.rx_data to rx_mon_packet.data[] till htax_rx_intf.rx_eot pulse
			while(!htax_rx_intf.rx_eot==1) begin
				@(posedge htax_rx_intf.clk);
				rx_mon_packet.data = new [++pkt_len] (rx_mon_packet.data);
				rx_mon_packet.data[pkt_len-1] = htax_rx_intf.rx_data;
			end
			
			//cover_rx_req.sample();       //Sample Coverage on rx_mon_packet
			cover_rx_eot.sample();       //Sample Coverage on rx_mon_packet
			cover_htax_rx_intf.sample();       //Sample Coverage on rx_mon_packet
			//Write the rx_mon_packet on anaylysis port
			rx_collect_port.write(rx_mon_packet);
		
		end
	endtask : run_phase
endclass : htax_rx_monitor_c
