// Code your testbench here

`timescale 1ns / 1ps
//SPI Top TB
 //import uvm_pkg::*;



module top_tb;
  

   import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_pkg::*;


  bit mclk;
  bit reset;

  always #5 mclk = ~mclk;
  

  initial begin
    mclk = 0;
    reset = 0;
    #5 reset =1;
  end
  

   spi_interface intf(mclk,reset);
  

  top_dut dut(intf.mclk, intf.reset,intf.load_master,intf.load_slave,intf.read_master,
  intf.read_slave,intf.start,intf.data_in_master,intf.data_in_slave,intf.data_out_master,intf.data_out_slave);
  
   initial begin 
     uvm_config_db#(virtual interface spi_interface)::set(null,"*","vif",intf);
  end
 initial begin

        #500;
        //$display("Data out master: %d", intf.data_out_master);
        //$display("Data out slave: %d", intf.data_out_slave);
    end
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin 
    run_test("spi_test");
  end
  
endmodule

