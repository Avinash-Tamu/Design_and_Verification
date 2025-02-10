`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    register_file 
//////////////////////////////////////////////////////////////////////////////////
 module register_file  
 (  
      input                    clk,  
      input                    reset,  
      // write port  
      input                    reg_write_en,  
      input                    bubble,
      input          [4:0]     reg_write_dest,  
      input          [31:0]     reg_write_data,  
      //read port 1  
      input          [4:0]     reg_read_addr_1,  
      output          [31:0]     reg_read_data_1,  
      //read port 2  
      input          [4:0]     reg_read_addr_2,  
      output          [31:0]     reg_read_data_2  
 );  
      reg     [31:0]     reg_array [31:0];  
		integer i;
      // write port  
      //reg [2:0] i;  
     always @ (posedge clk or posedge reset) begin  
          if(reset) begin  
               for(  i =0;i<32;i++) begin
			     reg_array[i] <= i;  
               end       
          end  
		else begin  
                if(reg_write_en) begin  
                    reg_array[reg_write_dest] <= reg_write_data;  
                end
                /*
                else begin
		          for(  i =0;i<32;i++) begin
			          reg_array[i] <= i;  
                    end 
			end
               */
		end
	end
		               
     assign reg_read_data_1 = ( reg_read_addr_1 == 0 ) ? 32'b0 : (bubble ? 32'b0 : (reg_write_en && reg_read_addr_1 == reg_write_dest) ? reg_write_data : reg_array[reg_read_addr_1]);
     assign reg_read_data_2 = ( reg_read_addr_2 == 0 ) ? 32'b0 : (bubble ? 32'b0 : (reg_write_en && reg_read_addr_2 == reg_write_dest) ? reg_write_data : reg_array[reg_read_addr_2]);
 
 endmodule
