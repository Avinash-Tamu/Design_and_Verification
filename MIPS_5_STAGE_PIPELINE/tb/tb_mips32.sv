


`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////////
// Project Name:  mips
////////////////////////////////////////////////////////////////////////////////

module tb_mips32;  
      // Inputs  
      reg clk;  
      reg reset;  
      // Outputs  
      wire [31:0] pc_out;  
      wire [31:0] alu_result;//,reg3,reg4;  
      wire [31:0] instruction;
      wire [31:0] reg_write_data;
      wire [31:0] reg_read_data_1;
      wire [31:0] reg_read_data_2;
      wire [4:0] RS_reg_read_addr;
     wire [4:0] RT_reg_read_addr;
     wire [4:0] RD_reg_write_dest;
     wire [5:0] opcode;
      int value ;  
      mips_32 uut (  
           .clk(clk),   
           .reset(reset),   
           .pc_out(pc_out),   
           .startPC(32'b0),
           .alu_result(alu_result),  
           .instruction(instruction),
           .reg_read_addr_1(RS_reg_read_addr),
           .reg_read_addr_2(RT_reg_read_addr),
          .reg_write_dest(RD_reg_write_dest),
          .opcode(opcode),
          .reg_write_data(reg_write_data),
          .reg_read_data_2(reg_read_data_2),
          .reg_read_data_1(reg_read_data_1)
          //.funct(funct)
           
      );  
      initial begin  
           clk = 0;  
           forever #30 clk = ~clk;
      end  
   always @(posedge clk) begin
    //    $display("Time = %0t | PC OUT = %h | ALU Result = %h | Instruction = %h | OPCODE = %d | RS_Reg = %d | RT_Reg = %d | RD_Reg = %d | RS_Reg_Data = %0d | RT_Reg_Data = %0d | RD_Reg_Write_Data = %h" ,$time, pc_out, alu_result,instruction,opcode,RS_reg_read_addr,RT_reg_read_addr,RD_reg_write_dest,reg_read_data_1,reg_read_data_2,reg_write_data);`
          checktest(reg_write_data,3 ,"Output of Program");
     end



     task checktest;
		input [31:0] actualOut, expectedOut;
		input [32*8:0] testType;
	
		if(actualOut == expectedOut) begin 
               $display ("%s passed", testType); 
          end
		else 
               $display ("%s failed: 0x%x should be 0x%x", testType, actualOut, expectedOut);
	endtask

      initial begin  
           
           reset = 1;     
           #30;
          reset = 0;  
          $display("RESET DONE\n");
          #2000;
          $display("\nSIMULATION DONE");
         
          $finish;
           
      end  
 endmodule  