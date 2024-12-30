/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
`timescale 1ns / 1ps
module tb_top;
// import the UVM library
// include the UVM macros
import uvm_pkg::*;
`include "uvm_macros.svh"
import yapp_pkg::*;
import channel_pkg::*;
import clock_and_reset_pkg::*;
import hbus_pkg::*;
`include "router_mcsequencer.sv"
`include "router_mcseqs_lib.sv"
`include "../sv/router_scoreboard.sv"
`include "router_tb.sv"
`include "router_test_lib.sv"


  // YAPP Interface to the DUT
  
  virtual interface yapp_if vif;
  
  initial begin
    yapp_vif_config::set(null, "*.tb.yapp.*","vif",hw_top.in0);
    hbus_vif_config::set(null,"*.tb.hbus.*","vif", hw_top.hif);
    channel_vif_config::set(null,"*.tb.chan0.*","vif", hw_top.ch0);
    channel_vif_config::set(null,"*.tb.chan1.*","vif", hw_top.ch1);
    channel_vif_config::set(null,"*.tb.chan2.*","vif", hw_top.ch2);
    clock_and_reset_vif_config::set(null,"*.tb.clock_and_reset.*","vif", hw_top.clock_and_reset_if);
  end
//yapp_packet p1;
initial begin
    //repeat (5) begin
      //p1 = new("p1");
      run_test("base_test");
end
// generate 5 random packets and use the print method
// to display the results

// experiment with the copy, clone and compare UVM method
endmodule : tb_top
