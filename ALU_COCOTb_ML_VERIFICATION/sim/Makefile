# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# defaults
#SIM ?= xcelium
SIM ?= icarus

TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../design/ALU.sv
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = ALU

# MODULE is the basename of the Python test file
MODULE = test_my_design

export PYTHONPATH := $(shell pwd)/../pyTB:$(PYTHONPATH)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim