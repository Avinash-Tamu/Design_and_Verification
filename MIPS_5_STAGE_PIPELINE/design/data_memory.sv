`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    data_memory 
//////////////////////////////////////////////////////////////////////////////////
module data_memory  
 (  
      input                         clk,  
      // address input
      input     [31:0]               mem_access_addr,  
      // write port  
      input     [31:0]               mem_write_data,  
      input                         mem_write_en,  
      input mem_read,  
      // read port  
      output     [31:0]               mem_read_data  
 );  
      integer i;  
      reg [31:0] ram [255:0];  
      wire [7 : 0] ram_addr;
      assign ram_addr = mem_access_addr[7:0];
      initial begin  
           for(i=0;i<256;i=i+1)  
                ram[i] <= i;  
      end  
      always @(posedge clk) begin  
           if (mem_write_en)  
                ram[ram_addr] <= mem_write_data;  
      end  
      assign mem_read_data = (mem_read==1'b1) ? ram[ram_addr]: 32'd0;   
 endmodule 