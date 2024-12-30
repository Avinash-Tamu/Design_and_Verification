class yapp_tx_monitor extends uvm_monitor;
    `uvm_component_utils(yapp_tx_monitor)
    yapp_packet collected_packet;
    virtual interface yapp_if vif;
    uvm_analysis_port #(yapp_packet) yapp_out;
    function new(string name, uvm_component parent);
        super.new(name,parent);
        yapp_out = new("yapp_out", this);
    endfunction
    int num_pkt_col;
    //UVM build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if (!yapp_vif_config::get(this,"","vif", vif))
            `uvm_error("NOVIF","vif not set")
	endfunction : build_phase
  // UVM run() phase
  task run_phase(uvm_phase phase);
    // Look for packets after reset
    
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      collected_packet = yapp_packet::type_id::create("collected_packet", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(collected_packet.length, collected_packet.addr, collected_packet.payload, collected_packet.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(collected_packet, "Monitor_YAPP_Packet"));
      join

      collected_packet.parity_type = (collected_packet.parity == collected_packet.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(collected_packet);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", collected_packet.sprint()), UVM_LOW)
      num_pkt_col++;
      collect_packets();
    end
  endtask : run_phase
   // virtual function void connect_phase(uvm_phase phase);
     //  if (!yapp_vif_config::get(this,"","vif", vif))
       //     `uvm_error("NOVIF","vif not set")
    //endfunction
  // UVM report_phase

  task collect_packets();
    yapp_out.write(collected_packet);
  endtask

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase
endclass