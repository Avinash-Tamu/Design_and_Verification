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

+UVM_TESTNAME=spi_test
+UVM_VERBOSITY=UVM_HIGH 

+SVSEED=random


-incdir ../uvm \
-incdir ../design \
-incdir ../tb 

../uvm/spi_pkg.sv \
../uvm/spi_interface.sv \
../design/spi_master.v \
../design/spi_slave.v \
../design/spi_top_dut.sv \
../tb/spi_top_testbench.sv 

