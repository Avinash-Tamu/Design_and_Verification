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
-timescale 1ns/1ns
// compile files
//*** add compile files here
//xrun 
+UVM_TESTNAME=router_simple_mcseq_test 
//+UVM_TESTNAME=base_test 

+UVM_VERBOSITY=UVM_HIGH 

+SVSEED=random


# Include directories for SystemVerilog files
-incdir ../../yapp/sv \
-incdir ../../channel/sv \
-incdir ../../clock_and_reset/sv \
-incdir ../../hbus/sv

# Compile YAPP package and other related files
../../yapp/sv/yapp_pkg.sv \
../../yapp/sv/yapp_if.sv \
../../channel/sv/channel_pkg.sv \
../../channel/sv/channel_if.sv \
../../clock_and_reset/sv/clock_and_reset_pkg.sv \
../../clock_and_reset/sv/clock_and_reset_if.sv \
../../hbus/sv/hbus_pkg.sv \
../../hbus/sv/hbus_if.sv 


# Top-level and router files
../../router_rtl/yapp_router.sv \
clkgen.sv \
hw_top.sv \
tb_top.sv


