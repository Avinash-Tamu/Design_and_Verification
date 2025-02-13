// RTL design files:


+shm
+access+r

-top tb_mips32
+verbose  # Add this line for verbosity

../design/ALUControl.sv 
../design/alu.sv 
../design/PipelinedControl.sv 
../design/data_memory.sv 
../design/instr_mem.sv 
../design/register_file.sv 
../design/PipelinedMIPS32.sv 
../design/Hazard.sv
../design/ForwardingBlock.sv
../tb/tb_mips32.sv 



// Tcl command files:
// Specify the path to the tcl file called *.tcl in this directory
-input xrun.tcl
