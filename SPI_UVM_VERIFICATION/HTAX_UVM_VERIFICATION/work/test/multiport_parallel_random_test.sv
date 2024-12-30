///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class multiport_parallel_random_test extends base_test;

    `uvm_component_utils(multiport_parallel_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", parallel_random_vsequence::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Starting multiport parallel random test", UVM_NONE)
    endtask : run_phase

endclass : multiport_parallel_random_test


/// short packet test
class short_packet_parallel_random_test extends base_test;

    `uvm_component_utils(short_packet_parallel_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", short_packet_vsequence::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Starting multiport parallel random test", UVM_NONE)
    endtask : run_phase

endclass : short_packet_parallel_random_test


//// long packet test 
class long_packet_parallel_random_test extends base_test;

    `uvm_component_utils(long_packet_parallel_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", long_packet_vsequence::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Starting multiport parallel random test", UVM_NONE)
    endtask : run_phase

endclass : long_packet_parallel_random_test


/// same delay test
class same_delay_parallel_random_test extends base_test;

    `uvm_component_utils(same_delay_parallel_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", same_delay_vsequence::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Starting multiport parallel random test", UVM_NONE)
    endtask : run_phase

endclass : same_delay_parallel_random_test

/// same delay test same port
class same_delay_same_length_same_port_parallel_random_test extends base_test;

    `uvm_component_utils(same_delay_same_length_same_port_parallel_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", same_delay_same_length_same_port_vsequence::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Starting multiport parallel random test", UVM_NONE)
    endtask : run_phase

endclass : same_delay_same_length_same_port_parallel_random_test

/// same delay test
class same_delay_same_length_all_port_parallel_random_test extends base_test;

    `uvm_component_utils(same_delay_same_length_all_port_parallel_random_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", same_delay_same_length_all_port_vsequence::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Starting multiport parallel random test", UVM_NONE)
    endtask : run_phase

endclass : same_delay_same_length_all_port_parallel_random_test

///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////

class parallel_random_vsequence extends htax_base_vseq;

    `uvm_object_utils(parallel_random_vsequence)

    function new(string name = "parallel_random_vsequence");
        super.new(name);
    endfunction : new
    htax_packet_c req[0:3];
    task body();
        semaphore sem;
        sem = new(1);
      //repeat (10) begin
        fork
            begin
                //sem.get();
                for (int j=0;j<4;j++) begin
		            for(int i=3;i< 64 ;i++) begin
                        `uvm_do_on_with(req[0], p_sequencer.htax_seqr[0],{length == i; dest_port == j; })
                    end
                end
                //sem.put();
            end
            begin
                //sem.get();
                for (int j=0;j<4;j++) begin
		            for(int i=3;i< 64 ;i++) begin
                        `uvm_do_on_with(req[1], p_sequencer.htax_seqr[1],{length == i; dest_port == j;})
                    end
                end
                //sem.put();
            end
            begin
                //sem.get();
                for (int j=0;j<4;j++) begin
		            for(int i=3;i< 64 ;i++) begin
                        `uvm_do_on_with(req[2], p_sequencer.htax_seqr[2],{length == i; dest_port == j;})
                    end
                end
                //sem.put();
            end
            begin
                //sem.get();
                for (int j=0;j<4;j++) begin
		            for(int i=3;i< 64 ;i++) begin
                        `uvm_do_on_with(req[3], p_sequencer.htax_seqr[3],{length == i; dest_port == j;})
                    end
                end
                //sem.put();
            end
        join
      //end
endtask : body


endclass : parallel_random_vsequence

// short packet sequence 

class short_packet_vsequence extends htax_base_vseq;

    `uvm_object_utils(short_packet_vsequence)

    function new(string name = "short_packet_vsequence");
        super.new(name);
    endfunction : new
    htax_packet_c req[0:3];
    task body();

        fork
            begin
                `uvm_do_on_with(req[0], p_sequencer.htax_seqr[0],{length > 3; length < 20;})
            end
            begin
                `uvm_do_on_with(req[1], p_sequencer.htax_seqr[1],{length > 3; length < 20;})
            end
            begin
                `uvm_do_on_with(req[2], p_sequencer.htax_seqr[2],{length > 3; length < 20;})
            end
            begin
                `uvm_do_on_with(req[3], p_sequencer.htax_seqr[3],{length > 3; length < 20;})
            end
        join
      //end
endtask : body


endclass : short_packet_vsequence


// long packet sequence 
class long_packet_vsequence extends htax_base_vseq;

    `uvm_object_utils(long_packet_vsequence)

    function new(string name = "long_packet_vsequence");
        super.new(name);
    endfunction : new
    htax_packet_c req[0:3];
    task body();

        fork
            begin
                `uvm_do_on_with(req[0], p_sequencer.htax_seqr[0],{length > 25; length < 60;})
            end
            begin
                `uvm_do_on_with(req[1], p_sequencer.htax_seqr[1],{length > 25; length < 60;})
            end
            begin
                `uvm_do_on_with(req[2], p_sequencer.htax_seqr[2],{length > 25; length < 60;})
            end
            begin
                `uvm_do_on_with(req[3], p_sequencer.htax_seqr[3],{length > 25; length < 60;})
            end
        join
      //end
endtask : body


endclass : long_packet_vsequence


// short delay sequence 

class same_delay_vsequence extends htax_base_vseq;

    `uvm_object_utils(same_delay_vsequence)

    function new(string name = "same_delay_vsequence");
        super.new(name);
    endfunction : new
    htax_packet_c req[0:3];
    task body();
      //repeat(10) begin
        fork
            begin
                `uvm_do_on_with(req[0], p_sequencer.htax_seqr[0],{delay == 5;})
            end
            begin
                `uvm_do_on_with(req[1], p_sequencer.htax_seqr[1],{delay == 5;})
            end
            begin
                `uvm_do_on_with(req[2], p_sequencer.htax_seqr[2],{delay == 5;})
            end
            begin
                `uvm_do_on_with(req[3], p_sequencer.htax_seqr[3],{delay == 5;})
            end
        join
      //end
    endtask : body

endclass : same_delay_vsequence

//same delay same length same port
class same_delay_same_length_same_port_vsequence extends htax_base_vseq;

    `uvm_object_utils(same_delay_same_length_same_port_vsequence)

    function new(string name = "same_delay_same_length_same_port_vsequence");
        super.new(name);
    endfunction : new
    htax_packet_c req[0:3];
    task body();
      //repeat(10) begin
        fork
            begin
                `uvm_do_on_with(req[0], p_sequencer.htax_seqr[0],{length == 8;dest_port==0;delay > 3; delay < 5;})
            end
            begin
                `uvm_do_on_with(req[1], p_sequencer.htax_seqr[1],{length == 8;dest_port==0;delay > 3; delay < 5;})
            end
            begin
                `uvm_do_on_with(req[2], p_sequencer.htax_seqr[2],{length == 8;dest_port==0;delay > 3; delay < 5;})
            end
            begin
                `uvm_do_on_with(req[3], p_sequencer.htax_seqr[3],{length == 8;dest_port==0;delay > 3; delay < 5;})
            end
        join
      //end
endtask : body

endclass : same_delay_same_length_same_port_vsequence

//same delay same length all port
class same_delay_same_length_all_port_vsequence extends htax_base_vseq;

    `uvm_object_utils(same_delay_same_length_all_port_vsequence)

    function new(string name = "same_delay_same_length_all_port_vsequence");
        super.new(name);
    endfunction : new
    htax_packet_c req[0:3];
    task body();
      //repeat(10) begin
        fork
            begin
                `uvm_do_on_with(req[0], p_sequencer.htax_seqr[0],{length == 8;dest_port==0;delay > 3; delay < 5;})
            end
            begin
                `uvm_do_on_with(req[1], p_sequencer.htax_seqr[1],{length == 8;dest_port==1;delay > 3; delay < 5;})
            end
            begin
                `uvm_do_on_with(req[2], p_sequencer.htax_seqr[2],{length == 8;dest_port==2;delay > 3; delay < 5;})
            end
            begin
                `uvm_do_on_with(req[3], p_sequencer.htax_seqr[3],{length == 8;dest_port==3;delay > 3; delay < 5;})
            end
        join
      //end
endtask : body

endclass : same_delay_same_length_all_port_vsequence
