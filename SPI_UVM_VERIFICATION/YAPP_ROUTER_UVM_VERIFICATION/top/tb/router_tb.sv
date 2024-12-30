class router_tb extends uvm_env;
    `uvm_component_utils(router_tb)
    yapp_env yapp;
    router_sb scoreboard;
    router_mcsequencer mcseqr;
    channel_env chan0;
    channel_env chan1;
    channel_env chan2;
    hbus_env hbus;
    clock_and_reset_env clock_and_reset;
    function new (string name , uvm_component parent);
        super.new(name, parent);
    endfunction 
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //yapp = new("yapp",this);
        yapp = yapp_env::type_id::create("yapp", this);
        mcseqr = router_mcsequencer::type_id::create("mcseqr", this);
        chan0 = channel_env::type_id::create("chan0", this);
        chan1 = channel_env::type_id::create("chan1", this);
        chan2 = channel_env::type_id::create("chan2", this);
        hbus = hbus_env::type_id::create("hbus", this);
        clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
        scoreboard = router_sb::type_id::create("scoreboard", this);
        uvm_config_int::set(this, "chan0", "channel_id", 0);
        uvm_config_int::set(this, "chan1", "channel_id", 1);
        uvm_config_int::set(this, "chan2", "channel_id", 2);
        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);
        `uvm_info("BUILD_PHASE", "Executing build phase of the testbench.", UVM_HIGH);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mcseqr.hbus_seqr = hbus.masters[0].sequencer;
        mcseqr.yapp_seqr = yapp.agent.sequencer;
        yapp.agent.monitor.yapp_out.connect(scoreboard.yapp_in);
        chan0.rx_agent.monitor.item_collected_port.connect(scoreboard.chan0_in);
        chan1.rx_agent.monitor.item_collected_port.connect(scoreboard.chan1_in);
        chan2.rx_agent.monitor.item_collected_port.connect(scoreboard.chan2_in);

    endfunction

endclass