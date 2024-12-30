/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  // YAPP Interface to the DUT
  yapp_if in0(clock, reset);
  channel_if ch0(clock,reset);
  channel_if ch1(clock,reset);
  channel_if ch2(clock,reset);
  hbus_if hif(clock,reset);
  // Instantiate Clock and Reset interface
  clkgen clkgen (.clock(clock), .run_clock(run_clock), .clock_period(clock_period));

  clock_and_reset_if  clock_and_reset_if (.clock(clock), .reset(reset), .run_clock(run_clock), .clock_period(clock_period));
  initial begin
    //$monitor("At time %t, reset = %b,clock = %b", $time, reset,clock);
    $monitor("At time %t, reset = %b", $time, reset);
  end

  // YAPP Router module instantiation
  yapp_router dut (
    .reset(reset),
    .clock(clock),
    .error(),

    // YAPP interface
    .in_data(in0.in_data),
    .in_data_vld(in0.in_data_vld),
    .in_suspend(in0.in_suspend),

    // Output Channels
    // Channel 0
    .data_0(ch0.data),
    .data_vld_0(ch0.data_vld),
    //.suspend_0(1'b0),
    .suspend_0(ch0.suspend),

    // Channel 1
    .data_1(ch1.data),
    .data_vld_1(ch1.data_vld),
    //.suspend_1(1'b0),
    .suspend_1(ch1.suspend),
    // Channel 2
    .data_2(ch2.data),
    .data_vld_2(ch2.data_vld),
    //.suspend_2(1'b0),
    .suspend_2(ch2.suspend),

    // HBUS Interface
    .haddr(hif.haddr),
    .hdata(hif.hdata_w),
    .hen(hif.hen),
    .hwr_rd(hif.hwr_rd)
  );

  

  
endmodule
