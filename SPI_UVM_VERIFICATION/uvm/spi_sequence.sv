
class spi_sequence extends uvm_sequence #(spi_seq_item);
  


  `uvm_object_utils(spi_sequence)
  spi_seq_item seq;
  

  function new(string name="spi_sequence");
    super.new();
  endfunction
  
  task body();
    seq = spi_seq_item:: type_id::create("seq",this);
    repeat(10) begin 
        start_item(seq);
        assert(seq.randomize());
        `uvm_info("GEN", "Data send to Driver", UVM_NONE);
        finish_item(seq);
    end
  endtask
  
endclass
