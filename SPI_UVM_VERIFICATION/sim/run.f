/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

 -uvmhome $UVMHOME

// include directories
//*** add incdir include directories here

// compile files
//*** add compile files here
//xrun 
//+UVM_TESTNAME=base_test 
//+UVM_TESTNAME=short_packet_test
//+UVM_TESTNAME=set_config_test
//+UVM_VERBOSITY=UVM_HIGH 

//+SVSEED=random


-incdir ../sv // include directory for sv files
//../sv/yapp_pkg.sv // compile YAPP package
../design/spi_master.v
../design/spi_slave.v
../design/spi_top_dut.sv
../uvm/spi_pkg.sv
../tb/spi_top_testbench.sv // compile top level module

