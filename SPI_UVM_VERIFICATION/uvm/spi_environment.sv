

//SPI Environment

class spi_environment extends uvm_env;
  
  spi_agent agt;
  spi_scoreboard scb;
 
  virtual spi_interface vif;
  
  `uvm_component_utils(spi_environment)
  

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  

  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    agt=spi_agent::type_id::create("agt", this);
    scb=spi_scoreboard::type_id::create("scb", this);
    
  endfunction
    
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap.connect(scb.mon_imp);
    uvm_report_info("SPI_ENVIRONMENT", "connect_phase, Connected monitor to scoreboard");
  endfunction
    
endclass
