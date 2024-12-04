#!/bin/bash
export MDV_XLM_HOME="/opt/coe/cadence/XCELIUM"
export UVMHOME="/opt/coe/cadence/XCELIUM/tools/methodology/UVM/CDNS-1.1d/sv"
source /opt/coe/cadence/XCELIUM/setup.XCELIUM.linux.bash
source /opt/coe/cadence/VMANAGER/setup.VMANAGER.linux.bash
alias vmanager="/opt/coe/cadence/VMANAGER/bin/vmanager -server 192.168.2.4:8081 &"
alias imc="/opt/coe/cadence/VMANAGER/bin/imc"
echo Success
