module top;


    // import the UVM library
    import uvm_pkg::*;
    // include the UVM macros
    `include "uvm_macros.svh"

    // import the HTAX package
    import htax_pkg::*;

	  //include the environment
    `include "htax_env.sv"
    //include the test library
    `include "test_lib.svh"


	reg clk;
	reg rst_n;

	initial begin
		clk = 1'b0;
		forever 
			#10 clk = ~clk;
	end

	initial begin
		rst_n= 1'b1;
		#5 rst_n= 1'b0;
		#10 rst_n= 1'b1;
	end

	htax_tx_interface inst_htax_tx_intf[3:0] (clk, rst_n);
	htax_rx_interface inst_htax_rx_intf[3:0] (clk, rst_n);

	htax_top inst_htax_top (
			.clk 			( clk),
			.res_n 		(	rst_n),
			.fu0_tx_outport_req ( inst_htax_tx_intf[0].tx_outport_req),
			.fu0_tx_vc_req 			( inst_htax_tx_intf[0].tx_vc_req),
			.fu0_tx_vc_gnt 			( inst_htax_tx_intf[0].tx_vc_gnt),
			.fu0_tx_sot 				( inst_htax_tx_intf[0].tx_sot),
			.fu0_tx_data 				( inst_htax_tx_intf[0].tx_data),
			.fu0_tx_release_gnt ( inst_htax_tx_intf[0].tx_release_gnt),
			.fu0_tx_eot 				( inst_htax_tx_intf[0].tx_eot),
			.fu1_tx_outport_req ( inst_htax_tx_intf[1].tx_outport_req),
			.fu1_tx_vc_req 			( inst_htax_tx_intf[1].tx_vc_req),
			.fu1_tx_vc_gnt 			( inst_htax_tx_intf[1].tx_vc_gnt),
			.fu1_tx_sot 				( inst_htax_tx_intf[1].tx_sot),
			.fu1_tx_data 				( inst_htax_tx_intf[1].tx_data),
			.fu1_tx_release_gnt ( inst_htax_tx_intf[1].tx_release_gnt),
			.fu1_tx_eot 				( inst_htax_tx_intf[1].tx_eot),
			.fu2_tx_outport_req ( inst_htax_tx_intf[2].tx_outport_req),
			.fu2_tx_vc_req 			( inst_htax_tx_intf[2].tx_vc_req),
			.fu2_tx_vc_gnt 			( inst_htax_tx_intf[2].tx_vc_gnt),
			.fu2_tx_sot 				( inst_htax_tx_intf[2].tx_sot),
			.fu2_tx_data 				( inst_htax_tx_intf[2].tx_data),
			.fu2_tx_release_gnt ( inst_htax_tx_intf[2].tx_release_gnt),
			.fu2_tx_eot 				( inst_htax_tx_intf[2].tx_eot),
			.fu3_tx_outport_req ( inst_htax_tx_intf[3].tx_outport_req),
			.fu3_tx_vc_req 			( inst_htax_tx_intf[3].tx_vc_req),
			.fu3_tx_vc_gnt 			( inst_htax_tx_intf[3].tx_vc_gnt),
			.fu3_tx_sot 				( inst_htax_tx_intf[3].tx_sot),
			.fu3_tx_data 				( inst_htax_tx_intf[3].tx_data),
			.fu3_tx_release_gnt ( inst_htax_tx_intf[3].tx_release_gnt),
			.fu3_tx_eot 				( inst_htax_tx_intf[3].tx_eot),
			.fu0_rx_vc_req 			( inst_htax_rx_intf[0].rx_vc_req),
			.fu0_rx_vc_gnt 			( inst_htax_rx_intf[0].rx_vc_gnt),
			.fu0_rx_sot 				( inst_htax_rx_intf[0].rx_sot),
			.fu0_rx_data 				( inst_htax_rx_intf[0].rx_data),
			.fu0_rx_eot 				( inst_htax_rx_intf[0].rx_eot),
			.fu1_rx_vc_req 			( inst_htax_rx_intf[1].rx_vc_req),
			.fu1_rx_vc_gnt 			( inst_htax_rx_intf[1].rx_vc_gnt),
			.fu1_rx_sot 				( inst_htax_rx_intf[1].rx_sot),
			.fu1_rx_data 				( inst_htax_rx_intf[1].rx_data),
			.fu1_rx_eot 				( inst_htax_rx_intf[1].rx_eot),
			.fu2_rx_vc_req 			( inst_htax_rx_intf[2].rx_vc_req),
			.fu2_rx_vc_gnt 			( inst_htax_rx_intf[2].rx_vc_gnt),
			.fu2_rx_sot 				( inst_htax_rx_intf[2].rx_sot),
			.fu2_rx_data 				( inst_htax_rx_intf[2].rx_data),
			.fu2_rx_eot 				( inst_htax_rx_intf[2].rx_eot),
			.fu3_rx_vc_req 			( inst_htax_rx_intf[3].rx_vc_req),
			.fu3_rx_vc_gnt 			( inst_htax_rx_intf[3].rx_vc_gnt),
			.fu3_rx_sot 				( inst_htax_rx_intf[3].rx_sot),
			.fu3_rx_data 				( inst_htax_rx_intf[3].rx_data),
			.fu3_rx_eot 				( inst_htax_rx_intf[3].rx_eot)
		);

	
	initial begin

		uvm_config_db#(virtual interface htax_tx_interface)::set(null,"*tx_port[0]*","tx_vif",inst_htax_tx_intf[0]);
		uvm_config_db#(virtual interface htax_tx_interface)::set(null,"*tx_port[1]*","tx_vif",inst_htax_tx_intf[1]);
		uvm_config_db#(virtual interface htax_tx_interface)::set(null,"*tx_port[2]*","tx_vif",inst_htax_tx_intf[2]);
		uvm_config_db#(virtual interface htax_tx_interface)::set(null,"*tx_port[3]*","tx_vif",inst_htax_tx_intf[3]);
		uvm_config_db#(virtual interface htax_rx_interface)::set(null,"*rx_port[0]*","rx_vif",inst_htax_rx_intf[0]);
		uvm_config_db#(virtual interface htax_rx_interface)::set(null,"*rx_port[1]*","rx_vif",inst_htax_rx_intf[1]);
		uvm_config_db#(virtual interface htax_rx_interface)::set(null,"*rx_port[2]*","rx_vif",inst_htax_rx_intf[2]);
		uvm_config_db#(virtual interface htax_rx_interface)::set(null,"*rx_port[3]*","rx_vif",inst_htax_rx_intf[3]);
		
		`uvm_info("TOP", "Starting simple random test", UVM_NONE)
		run_test();
		`uvm_info("TOP", "Test done", UVM_NONE)

	end
		
endmodule
