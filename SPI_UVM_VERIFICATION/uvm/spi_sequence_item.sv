class spi_seq_item extends uvm_sequence_item;
  
  rand bit [7:0]data_in_master;
  rand bit [7:0]data_in_slave;
  bit load_master;
  bit load_slave;
  bit read_master;
  bit read_slave;
  bit [7:0]data_out_master;
  bit [7:0]data_out_slave;

  `uvm_object_utils_begin(spi_seq_item)
  `uvm_field_int(data_in_master,UVM_ALL_ON)
  `uvm_field_int(data_in_slave,UVM_ALL_ON)
  `uvm_field_int(data_out_master,UVM_ALL_ON)
  `uvm_field_int(data_out_slave,UVM_ALL_ON)
  `uvm_field_int(load_master,UVM_ALL_ON)
  `uvm_field_int(load_slave,UVM_ALL_ON)
  `uvm_field_int(read_master,UVM_ALL_ON)
  `uvm_field_int(read_slave,UVM_ALL_ON)
  `uvm_object_utils_end


  
  function new(string name="spi_seq_item");
    super.new();
  endfunction
  
  function string convert2string();
    return $psprintf("data_in_master=%0h data_in_slave=%0h",data_in_master, data_in_slave);
  endfunction
  
endclass
