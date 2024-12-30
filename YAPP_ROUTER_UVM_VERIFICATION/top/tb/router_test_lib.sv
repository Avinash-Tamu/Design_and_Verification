class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    router_tb tb;
    function new (string name , uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tb = router_tb::type_id::create("tb", this);
        //uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase","default_sequence", yapp_5_packets::get_type());
        uvm_config_int::set(this, "*", "recording_detail", 1);
        `uvm_info("BUILD_PHASE", "Executing build phase of the test lib.", UVM_HIGH);
    endfunction
    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask
    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction

endclass


class simple_test extends base_test;
    `uvm_component_utils(simple_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        

        // Set YAPP UVC to create short YAPP packets
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

        // Set the default sequence for YAPP UVC to yapp_012_seq
        uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase", "default_sequence", yapp_012_seq::get_type());

        // Set the default sequence for Channel 1, 2, and 3 UVCs to channel_rx_resp_seq
        uvm_config_wrapper::set(this, "tb.chan0.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan1.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan2.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());

        // Set the default sequence for Clock and Reset UVC to clk10_rst5_seq
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());

        
        uvm_config_int::set(this, "*", "recording_detail", 1);

        `uvm_info("BUILD_PHASE", "Executing build phase of the simple_test.", UVM_HIGH);
    endfunction

endclass



class router_simple_mcseq_test extends base_test;
    `uvm_component_utils(router_simple_mcseq_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // a. Set a type override for short YAPP packets only
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

        // b. Set the default sequence for YAPP UVC to yapp_5_packets sequence
        uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase", "default_sequence", yapp_5_packets::get_type());

        // c. Set the default sequence for all output channel sequencers (chan0, chan1, chan2) to channel_rx_resp_seq
        uvm_config_wrapper::set(this, "tb.chan0.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan1.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan2.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());

        // d. Set the default sequence for the Clock and Reset UVC to clk10_rst5_seq
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());

        // e. Set the default sequence for the multichannel sequencer to router_simple_mcseq
        uvm_config_wrapper::set(this, "tb.mcseqr.run_phase", "default_sequence", router_simple_mcseq::get_type());

        uvm_config_int::set(this, "*", "recording_detail", 1);

        `uvm_info("BUILD_PHASE", "Executing build phase of the router_simple_mcseq_test.", UVM_HIGH);
    endfunction

endclass
