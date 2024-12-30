
package htax_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "htax_packet_c.sv"
	`include "htax_tx_mon_packet_c.sv"
	`include "htax_rx_mon_packet_c.sv"
	`include "htax_tx_monitor_c.sv"
	`include "htax_rx_monitor_c.sv"
	`include "htax_sequencer_c.sv"
	`include "htax_virtual_sequencer_c.sv"
	`include "htax_tx_driver_c.sv"
	`include "htax_tx_agent_c.sv"
	`include "htax_rx_agent_c.sv"
	`include "htax_scoreboard_c.sv"
	`include "htax_seqs.sv"
	`include "htax_vseqs.sv"

endpackage
