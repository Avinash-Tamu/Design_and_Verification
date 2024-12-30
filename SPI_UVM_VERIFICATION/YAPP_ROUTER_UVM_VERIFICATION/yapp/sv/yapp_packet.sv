/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here
typedef enum bit {BAD_PARITY,GOOD_PARITY} parity_t;
class yapp_packet extends uvm_sequence_item;

// Follow the lab instructions to create the packet.
// Place the packet declarations in the following order:
  rand bit [1:0] addr;
  rand bit [5:0] length;
  rand bit [7:0] payload [];
  bit [7:0] parity;
  rand parity_t parity_type;
  rand int packet_delay;
  // Define protocol data
  function new (string name = "yapp_packet");
    super.new(name);

  endfunction

  `uvm_object_utils_begin(yapp_packet)
  `uvm_field_int(addr,UVM_ALL_ON)
  `uvm_field_int(length,UVM_ALL_ON)
  `uvm_field_array_int(payload,UVM_ALL_ON)
  `uvm_field_int(parity,UVM_ALL_ON)
  `uvm_field_int(packet_delay,UVM_ALL_ON)
  `uvm_field_enum(parity_t,parity_type,UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint pkt_delay {packet_delay >0 ; packet_delay < 10;}
  constraint payload_size {soft length == payload.size();}
  constraint array_length {length > 0; length < 64;}
  constraint default_addr  { addr != 'b11; }
  //constraint parity_dist {
  //    (parity_type == GOOD_PARITY) dist { parity_type == GOOD_PARITY :/ 5 };
   //   (parity_type == BAD_PARITY) dist { parity_type == BAD_PARITY :/ 1 };
   //}
   constraint default_parity { parity_type dist {BAD_PARITY := 1, GOOD_PARITY := 25}; }


  // This method calculates the parity over the header and payload
  function bit [7:0] calc_parity();
    calc_parity = {length, addr};
    //foreach(payload[i])
    for (int i=0; i<length; i++)
      calc_parity = calc_parity ^ payload[i];
  endfunction : calc_parity

  // post_randomize() - calculates parity
  function void post_randomize();
    if (parity_type == GOOD_PARITY)
         parity = calc_parity();
    else do
      parity = $urandom;
    while( parity == calc_parity());
  endfunction : post_randomize
  
endclass: yapp_packet


class short_yapp_packet extends yapp_packet;
    `uvm_object_utils(short_yapp_packet)
    function new (string name = "short_yapp_packet");
      super.new(name);
    endfunction
    constraint array_length {length > 0; length < 15;}
    constraint array_addr {soft addr != 'b11 ;}

endclass


