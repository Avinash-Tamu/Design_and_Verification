// Code your testbench here

`timescale 1ns / 1ps
//SPI Top TB
 //import uvm_pkg::*;



module top_tb;
  

   import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_pkg::*;
`include "spi_sequence_item.sv"
`include "spi_sequence.sv"
`include "spi_driver.sv"
`include "spi_interface.sv"
`include "spi_monitor.sv"
`include "spi_agent.sv"
`include "spi_scorecard.sv"
`include "spi_environment.sv"
`include "spi_test.sv"
`include "spi_master.v"
`include "spi_slave.v"
  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit mclk;
  bit reset;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 mclk = ~mclk;
  
  //---------------------------------------
  //reset Generation
  //---------------------------------------
  initial begin
    reset = 0;
    #5 reset =1;
  end
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  spi_interface intf(mclk,reset);
  
  //---------------------------------------
  //DUT instance
  //---------------------------------------
  top_dut dut(intf.mclk, intf.reset,intf.load_master,intf.load_slave,intf.read_master,
  intf.read_slave,intf.start,intf.data_in_master,intf.data_in_slave,
  
              intf.data_out_master,intf.data_out_slave);
  
   initial begin 
     uvm_config_db#(virtual spi_interface)::set(null,"*","vif",intf);
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin 
    run_test("spi_test");
  end
  
endmodule

