
class spi_sequence extends uvm_sequence #(spi_seq_item);
  


  `uvm_object_utils(spi_sequence)
  

  function new(string name="spi_sequence");
    super.new();
  endfunction
  
  virtual task body();
    `uvm_info("GEN", "Data send to Driver", UVM_NONE);
    `uvm_info(get_type_name(), "Data send to Driver", UVM_LOW)
     repeat(5)
      `uvm_do(req)     
  endtask
  
endclass
