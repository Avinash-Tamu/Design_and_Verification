



//SPI Agent


class spi_agent extends uvm_agent;
  
 
  spi_driver driv;
  spi_monitor mon;
  
 
  uvm_sequencer #(spi_seq_item) seq;
  
  `uvm_component_utils_begin(spi_agent)
  `uvm_field_object(seq, UVM_ALL_ON)
  `uvm_field_object(driv, UVM_ALL_ON)
  `uvm_field_object(mon, UVM_ALL_ON)
  `uvm_component_utils_end
  
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    seq = uvm_sequencer #(spi_seq_item)::type_id::create("SEQ",this);
    driv=spi_driver::type_id::create("driv",this);
    mon=spi_monitor::type_id::create("mon",this);
  
    
  endfunction
  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driv.seq_item_port.connect(seq.seq_item_export);
    uvm_report_info("SPI_AGENT", "connect_phase, Connected driver to sequencer");
  endfunction
  
endclass
