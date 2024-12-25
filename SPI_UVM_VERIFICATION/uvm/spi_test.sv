
//SPI Test

class spi_test extends uvm_test;
  
  spi_environment env;
  spi_sequence spi_seq;
  
 
  
  `uvm_component_utils(spi_test)
  

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env=spi_environment::type_id::create("env", this);
    spi_seq=spi_sequence::type_id::create("seq", this);
   
  endfunction
  
 
  task run_phase(uvm_phase phase);
   
    phase.raise_objection( this, "Starting spi_base_seqin main phase" );
    $display("%t Starting sequence spi_seq run_phase",$time);
    spi_seq.start(env.agt.seq);
    #100ns;
    phase.drop_objection( this , "Finished spi_seq in main phase" );
  endtask
  
endclass
