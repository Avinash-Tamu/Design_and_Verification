class router_sb extends uvm_scoreboard;
    `uvm_component_utils(router_sb)
    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_chan0)
    `uvm_analysis_imp_decl(_chan1)
    `uvm_analysis_imp_decl(_chan2)

    uvm_analysis_imp_yapp #(yapp_packet,router_sb) yapp_in;
    uvm_analysis_imp_chan0 #(channel_packet,router_sb) chan0_in;
    uvm_analysis_imp_chan1 #(channel_packet,router_sb) chan1_in;
    uvm_analysis_imp_chan2 #(channel_packet,router_sb) chan2_in;



    function new (string name , uvm_component parent);
        super.new(name,parent);
        yapp_in = new("yapp_in",this);
        chan0_in = new("chan0_in",this);
        chan1_in = new("chan1_in",this);
        chan2_in = new("chan2_in",this);
    endfunction

    yapp_packet yapp_queue    [$];   
    channel_packet channel1_queue[$];   
    channel_packet channel2_queue[$];  
    channel_packet channel3_queue[$];   

    int ch0_matched_count = 0;
    int ch1_matched_count = 0;
    int ch2_matched_count = 0;
    int ch0_wrong_count = 0;
    int ch1_wrong_count = 0;
    int ch2_wrong_count = 0;
    int received_count = 0;
    function void write_yapp(input yapp_packet pkt);
        yapp_packet cloned_pkt;
        cloned_pkt = yapp_pkg::yapp_packet'(pkt.clone()); 
        yapp_queue[pkt.addr] = cloned_pkt; 
        received_count++;
    endfunction

    function void write_chan0(input channel_packet pkt);
        channel_packet cloned_pkt;
        cloned_pkt =channel_pkg::channel_packet'(pkt.clone());  
        
        
        if (yapp_queue[pkt.addr] != null) begin
            if (!comp_equal(yapp_queue[pkt.addr], cloned_pkt)) begin
                ch0_wrong_count++;  
            end else begin
                ch0_matched_count++;  
            end
            yapp_queue[pkt.addr] = null; 
        end
    endfunction

    function void write_chan1(input channel_packet pkt);
        channel_packet cloned_pkt;
        cloned_pkt = channel_pkg::channel_packet'(pkt.clone());  
        
    
        if (yapp_queue[pkt.addr] != null) begin
            if (!comp_equal(yapp_queue[pkt.addr], cloned_pkt)) begin
                ch1_wrong_count++;  
            end else begin
                ch1_matched_count++; 
            end
            yapp_queue[pkt.addr] = null;  
        end
    endfunction

   
    function void write_chan2(input channel_packet pkt);
        channel_packet cloned_pkt;
        cloned_pkt = channel_pkg::channel_packet'(pkt.clone());  
        
        
        if (yapp_queue[pkt.addr] != null) begin
            if (!comp_equal(yapp_queue[pkt.addr], cloned_pkt)) begin
                ch2_wrong_count++;  
            end else begin
                ch2_matched_count++; 
            end
            yapp_queue[pkt.addr] = null; 
        end
    endfunction
    
    function bit comp_equal (input yapp_packet yp, input channel_packet cp);
        //yp.print();
        //$display("ch0dddddd");
        //cp.print();
      if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
      end
      if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
      end
      foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
          `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
          return(0);
        end
      if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
      end
      return(1);
    endfunction


    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD", $sformatf("YAPP Packets Received: %0d", received_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Channel_0 Matched Packets: %0d", ch0_matched_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Channel_0 Wrong Packets: %0d", ch0_wrong_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Channel_1 Matched Packets: %0d", ch1_matched_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Channel_1 Wrong Packets: %0d", ch1_wrong_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Channel_2 Matched Packets: %0d", ch2_matched_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Channel_2 Wrong Packets: %0d", ch2_wrong_count), UVM_LOW)
        `uvm_info("SCOREBOARD", $sformatf("Total Matched Packet Counts: %0d", ch0_matched_count+ch1_matched_count+ch2_matched_count), UVM_LOW)
       // `uvm_info("SCOREBOARD", $sformatf("Packets Left in Queue YAPP: %0d", $size(yapp_queue)), UVM_LOW)
       // `uvm_info("SCOREBOARD", $sformatf("Packets Left in Queue Channel1: %0d", $size(channel1_queue)), UVM_LOW)
       // `uvm_info("SCOREBOARD", $sformatf("Packets Left in Queue Channel2: %0d", $size(channel2_queue)), UVM_LOW)
       // `uvm_info("SCOREBOARD", $sformatf("Packets Left in Queue Channel3: %0d", $size(channel3_queue)), UVM_LOW)
    endfunction

endclass