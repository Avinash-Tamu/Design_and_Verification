`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    mips_16 
//////////////////////////////////////////////////////////////////////////////////
module mips_32( input clk,reset,  
					input [31:0] startPC,
                    output [31:0] pc_out, 
                    output [31:0] alu_result,
                    output [31:0] instruction,
                    output [4:0] reg_read_addr_1,
                    output [4:0] reg_read_addr_2,
                    output [4:0] reg_write_dest,
                    output [5:0] opcode,
                    output [31:0] reg_read_data_1,
                    output [31:0] reg_read_data_2,
                    output [31:0] reg_write_data
); 

 reg[31:0] pc_current;  
 wire signed[31:0] pc_next,pc2;  
 wire [31:0] instr;  
 wire[1:0] reg_dst,mem_to_reg,alu_op;  
 wire jump,branch,mem_read,mem_write,alu_src,reg_write     ;   
 wire [31:0] sign_ext_im,read_data2,zero_ext_im,imm_ext;  
 wire JRControl;  
 wire [2:0] ALU_Control;  
 wire [31:0] ALU_out;  
 wire zero_flag;  
 wire signed[31:0] im_shift_1, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr;  
 wire beq_control;  
 wire [30:0] jump_shift_1;  
 wire [31:0]mem_read_data;  
 wire [31:0] no_sign_ext;  
 wire sign_or_zero;  
 wire [4:0] shift;


// Output of Hazard Unit 
wire [1:0] addrSel; // Mux select for PC
wire IF_write; 
wire PC_write;
wire bubble;

// Forwarding Unit 
wire [1:0] AluOpCtrlA_ID;
wire [1:0] AluOpCtrlB_ID;
wire DataMemForwardCtrl_EX_IF_ID;
wire DataMemForwardCtrl_MEM_IF_ID;

wire SignExtend; // Extend the sign of the immedieate value 
wire UseShamt; // To change the source registers in case of shift operations
wire UseImmed;// Indicate a immedieate type of instruction.
assign UseShamt = 1'b0;

 // Register wires - Fetch-Decode stage 
wire [31:0] Register_file_A_IF_ID, Register_file_B_IF_ID;
wire [31:0] BusW_WB;
wire [4:0] RA_IF_ID, RB_IF_ID, RW_WB;
wire[4:0] write_register_select_IF_ID;
wire [31:0] write_register_data_IF_ID;
wire [5:0] Opcode_IF_ID;
wire [4:0] RS_IF_ID;
wire [4:0] RT_IF_ID;
wire [4:0] RD_IF_ID;
wire [5:0] FUNC_IF_ID;
reg [31:0] IM_IF_ID;
wire [25:0] Jump_IF_ID;
wire [15:0] Immedi_IF_ID;
reg  signed [31:0] Normal_PC_IF_ID;
wire RegWr_WB;

// Stage 2 ID -> Execute
reg [1:0] RegDst_ID_EX;
reg [1:0] MemToReg_ID_EX;
reg RegWrite_ID_EX;
reg MemRead_ID_EX;
reg MemWrite_ID_EX;
reg [1:0]ALUOp_ID_EX;
reg [1:0] AluOpCtrlA_ID_EX;
reg [1:0] AluOpCtrlB_ID_EX;
reg DataMemForwardCtrl_EX_ID_EX;
reg DataMemForwardCtrl_MEM_ID_EX;
reg [26:0] IM_20_0_ID_EX;
reg Branch_ID_EX;
reg Jump_ID_EX;
reg ALU_Src;
reg [31:0] Imm_Ext;
reg [31:0] Sign_Extended_ID_EX;
reg [31:0] Registers_A_ID_EX;
reg [31:0] Registers_B_ID_EX;

wire [5:0] Funccode_ID_EX;
wire [4:0] RT_ID_EX;
wire [4:0] RD_ID_EX;
wire [4:0] Shamt_ID_EX;
wire [4:0] RW_ID_EX;
wire [31:0] Data_Memory_Input_ID_EX;
  
reg [31:0] alu_src1;
reg [31:0] alu_src2;

// Stage 4
// Data Memory 

reg [31:0] Data_Memory_Input_EX_MEM;
reg [31:0] ALU_OUT_EX_MEM;
reg [4:0] RW_EX_MEM; 
wire [31:0] Data_Memory_actual_in;

reg [1:0] MemToReg_EX_MEM;
reg RegWrite_EX_MEM;
reg MemRead_EX_MEM;
reg MemWrite_EX_MEM;

reg DataMemForwardCtrl_MEM_EX_MEM;

// Stage 5
// Writeback stage 
reg [1:0] MemToReg_MEM_WB;
reg RegWrite_MEM_WB;
reg [4:0] RW_MEM_WB;
reg [31:0] DataOut_MEM_WB;
reg [31:0] ALU_OUT_MEM_WB;
wire [31:0] Register_W_MEM_WB;


//------------------------------------------------------------------------------
// Stage 1
// Instruction Memory File to ID stage

// PC   
 always @(posedge clk or posedge reset)  
 begin   
      if(reset)   
           pc_current <= startPC;  
      else if (PC_write)  
           pc_current <= pc_next;  
 end 
// PC + 1  
 //assign pc2 = pc_current + 32'd1; 

// instruction memory  
instr_mem instrucion_memory(
          .pc(pc_current),
          .instruction(instr)
);

 always @ (posedge clk or posedge reset) begin
	if(reset) begin
		IM_IF_ID <= 32'b0;
		Normal_PC_IF_ID <= 32'b0;
	end
	else if(IF_write) begin
		IM_IF_ID <= instr;
		Normal_PC_IF_ID <= pc_current + 32'd1;;
	end
end   

//-----------------------------------------------------------------------------------


//------------------------------------------------------------------------------------
// Stage 2
// Register File to Execute stage

 // register file  
 assign shift = IM_IF_ID[10:6]; 

 // control unit  
 control control_unit(
     .reset(reset),
     .opcode(Opcode_IF_ID),
     .reg_dst(reg_dst),
     .mem_to_reg(mem_to_reg),
     .alu_op(alu_op),
     .jump(jump),
     .branch(branch),
     .mem_read(mem_read),  
     .mem_write(mem_write),
     .alu_src(alu_src),
     .reg_write(reg_write),
	 . UseImmed ( UseImmed),
	 .bubble(bubble),
     .sign_or_zero(sign_or_zero)
);  


 register_file reg_file(
          .clk(clk),
          .reset(reset),
          .reg_write_en(RegWrite_MEM_WB),  
          .reg_write_dest(RW_MEM_WB),  
          .reg_write_data(Register_W_MEM_WB),  
          .reg_read_addr_1(RS_IF_ID),  
          .reg_read_data_1(reg_read_data_1),  
          .reg_read_addr_2(RT_IF_ID),  
		  .bubble(bubble),
          .reg_read_data_2(reg_read_data_2)
 ); 

HazardUnit Hazard (
		.IF_write(IF_write), 
		.PC_write(PC_write), 
		.bubble(bubble), 
		.addrSel(addrSel), 
		.Jump(jump), 
		.Branch(branch), 
		.ALUZero(zero_flag), 
		.memReadEX(MemRead_ID_EX), 
		.currentRs(RS_IF_ID), 
		.currentRt(RT_IF_ID), 
		.previousRt(RT_ID_EX), 
		.UseShamt(UseShamt),  // not implemented yet
		.UseImmed(UseImmed), // not implemented yet
		.clk(clk), 
		.op(Opcode_IF_ID),
		.previousRd(RD_ID_EX),
		.reset(reset)
);

// Forwarding Blockl 
ForwardingBlock Forward ( 
		.UseImmed(UseImmed),
		.ID_Rs(RS_IF_ID), // source
		.ID_Rt(RT_IF_ID), // target
		.EX_Rw(RW_ID_EX), // destination
		.MEM_Rw(RW_EX_MEM), // 2 clk delay destination 
		.EX_RegWrite(RegWrite_ID_EX), 
		.MEM_RegWrite(RegWrite_EX_MEM), 
		.AluOpCtrlA(AluOpCtrlA_ID), 
		.AluOpCtrlB(AluOpCtrlB_ID), 
		.DataMemForwardCtrl_EX(DataMemForwardCtrl_EX_IF_ID), 
		.DataMemForwardCtrl_MEM(DataMemForwardCtrl_MEM_IF_ID) 
);


 assign Opcode_IF_ID = IM_IF_ID[31:26];
 assign FUNC_IF_ID = IM_IF_ID [5:0];
 assign RS_IF_ID = IM_IF_ID[25:21];
 assign RT_IF_ID =	IM_IF_ID[20:16];
 assign Jump_IF_ID =	IM_IF_ID[25:0];
 //assign Jump_IF_ID = {IM_IF_ID[25:0],1'b0};
 assign Immedi_IF_ID =	IM_IF_ID[15:0];

 // Sign Extension
assign imm_ext = sign_or_zero ? {{16{IM_IF_ID[15]}},IM_IF_ID[15:0]} : {{16{1'b0}},IM_IF_ID[15:0]}  ;


always @ (posedge clk or posedge reset) begin
	if(reset) begin
		RegDst_ID_EX<=2'b0;
		MemToReg_ID_EX<=2'b0;
		RegWrite_ID_EX<=1'b0;
		MemRead_ID_EX<=1'b0;
		MemWrite_ID_EX<=1'b0;
		ALUOp_ID_EX<=2'b0;
		AluOpCtrlA_ID_EX<=2'b0;
		AluOpCtrlB_ID_EX<=2'b0;
		DataMemForwardCtrl_EX_ID_EX<=1'b0;
		DataMemForwardCtrl_MEM_ID_EX<=1'b0;
          Imm_Ext <= 32'b0;
          Branch_ID_EX <= 1'b0;
          Jump_ID_EX <=1'b0;
		  IM_20_0_ID_EX<=27'b0;
          ALU_Src <= 1'b0;
		Sign_Extended_ID_EX<=32'b0;
		Registers_A_ID_EX<=32'b0;
		Registers_B_ID_EX<=32'b0;
	end
	
   else if(bubble) begin
		RegDst_ID_EX<=2'b0;
		MemToReg_ID_EX<=2'b0;
		RegWrite_ID_EX<=1'b0;
		MemRead_ID_EX<=1'b0;
		MemWrite_ID_EX<=1'b0;
		ALUOp_ID_EX<=4'b0;
		AluOpCtrlA_ID_EX<=2'b0;
		AluOpCtrlB_ID_EX<=2'b0;
		DataMemForwardCtrl_EX_ID_EX<=1'b0;
		DataMemForwardCtrl_MEM_ID_EX<=1'b0;
		IM_20_0_ID_EX<=21'b0;
		Sign_Extended_ID_EX<=32'b0;
		Registers_A_ID_EX<=32'b0;
		Registers_B_ID_EX<=32'b0;
	end

	else begin 
		RegDst_ID_EX<=reg_dst;
		MemToReg_ID_EX<=mem_to_reg;
		RegWrite_ID_EX<=reg_write;
		MemRead_ID_EX<=mem_read;
		MemWrite_ID_EX<=mem_write;
		ALUOp_ID_EX<=alu_op;
		AluOpCtrlA_ID_EX<=AluOpCtrlA_ID;
		AluOpCtrlB_ID_EX<=AluOpCtrlB_ID;
		DataMemForwardCtrl_EX_ID_EX<=DataMemForwardCtrl_EX_IF_ID;
		DataMemForwardCtrl_MEM_ID_EX<=DataMemForwardCtrl_MEM_IF_ID;
          Imm_Ext <= imm_ext;
          ALU_Src <= alu_src;
		IM_20_0_ID_EX<=IM_IF_ID[20:0];
		Sign_Extended_ID_EX<=sign_ext_im;
		Registers_A_ID_EX<=reg_read_data_1;
		Registers_B_ID_EX<=reg_read_data_2;
	end 
end

//-----------------------------------------------------------------------------------
  

//------------------------------------------------------------------------------------
// Stage 3
// Execute to Memory stage

 // ALU control unit  
 ALUControl ALU_Control_unit(
          .ALUOp(ALUOp_ID_EX),
          .Function(IM_20_0_ID_EX[5:0]),
          .ALU_Control(ALU_Control)
); 

 // multiplexer alu_src  

 assign RT_ID_EX = IM_20_0_ID_EX[20:16];
assign RD_ID_EX = IM_20_0_ID_EX[15:11];
assign Shamt_ID_EX = IM_20_0_ID_EX[10:6];
assign Funccode_ID_EX = IM_20_0_ID_EX [5:0];


assign RW_ID_EX = RegDst_ID_EX ? RD_ID_EX : RT_ID_EX;

always @(*)begin 
	case (AluOpCtrlA_ID_EX)
		2'b01: alu_src1 = Register_W_MEM_WB;
		2'b10: alu_src1 = ALU_OUT_EX_MEM;
		2'b11: alu_src1 = Registers_A_ID_EX;
	endcase
end

// Input 2 
always @(*)begin 
	case (AluOpCtrlB_ID_EX)
		2'b00: alu_src2 = Imm_Ext;
		2'b01: alu_src2 = Register_W_MEM_WB;
		2'b10: alu_src2 = ALU_OUT_EX_MEM;
		2'b11: alu_src2 = Registers_B_ID_EX;
	endcase
end 

 assign Data_Memory_Input_ID_EX = DataMemForwardCtrl_EX_ID_EX ?  Register_W_MEM_WB : (ALU_Src==1'b1) ? Imm_Ext : Registers_B_ID_EX;

 // ALU   
 alu alu_unit(
          .src1(alu_src1 ),
          .src2(alu_src2),
          .alu_control(ALU_Control),
          .result(ALU_out),
          .zero(zero_flag)
);  

// Execute -> Memory Stage
always @ (posedge clk or posedge reset) begin
	if (reset)begin 
		Data_Memory_Input_EX_MEM <= 32'b0;
		ALU_OUT_EX_MEM	<=32'b0;
		RW_EX_MEM		<=5'b0;
		MemToReg_EX_MEM	<=2'b0;
		RegWrite_EX_MEM	<=1'b0;
		MemRead_EX_MEM	<=1'b0;
		MemWrite_EX_MEM	<=1'b0;
		DataMemForwardCtrl_MEM_EX_MEM<=1'b0;
	end 

	else begin 
		Data_Memory_Input_EX_MEM<= 	 Data_Memory_Input_ID_EX;
		ALU_OUT_EX_MEM	<=	 ALU_out;
		RW_EX_MEM		<=	 RW_ID_EX;
		MemToReg_EX_MEM	<=	 MemToReg_ID_EX;
		RegWrite_EX_MEM	<=	 RegWrite_ID_EX;
		MemRead_EX_MEM	<=	 MemRead_ID_EX;
		MemWrite_EX_MEM	<=	 MemWrite_ID_EX;
		DataMemForwardCtrl_MEM_EX_MEM <=DataMemForwardCtrl_MEM_ID_EX;
	end 
end 

//------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------
// Stage 4
// Memory stage to write back
// data memory  
 data_memory datamem(
          .clk(clk),
          .mem_access_addr(ALU_OUT_EX_MEM),  
          .mem_write_data(Data_Memory_actual_in),
          .mem_write_en(MemWrite_EX_MEM),
          .mem_read(MemRead_EX_MEM),  
          .mem_read_data(mem_read_data)
); 

// Memory -> Writeback
always @(posedge clk or posedge reset)begin 
	if (reset)begin
		MemToReg_MEM_WB<=2'b0;
		RegWrite_MEM_WB<=1'b0;
		RW_MEM_WB<=5'b0;
		DataOut_MEM_WB<=32'b0;
		ALU_OUT_MEM_WB<=32'b0; 
	end 
	else begin 
		MemToReg_MEM_WB<=MemToReg_EX_MEM;
		RegWrite_MEM_WB<=RegWrite_EX_MEM;
		RW_MEM_WB<=RW_EX_MEM;
		DataOut_MEM_WB<=mem_read_data;
		ALU_OUT_MEM_WB<=ALU_OUT_EX_MEM; 
	end 
end 


assign pc_next = (addrSel==2'b00) ? pc_current+1 :(addrSel == 2'b01) ? {Normal_PC_IF_ID [31:26], Jump_IF_ID} : Normal_PC_IF_ID + Imm_Ext;
assign Data_Memory_actual_in = DataMemForwardCtrl_MEM_EX_MEM ? Register_W_MEM_WB :Data_Memory_Input_EX_MEM;
 // write back  
 assign Register_W_MEM_WB = (MemToReg_MEM_WB == 2'b10) ? pc2:((MemToReg_MEM_WB == 2'b01)? DataOut_MEM_WB: ALU_OUT_MEM_WB); 
 // output  
 assign pc_out = pc_current;  
 assign alu_result = ALU_OUT_MEM_WB;  
 assign instruction = instr;
 assign opcode = Opcode_IF_ID;
 assign reg_read_addr_2 = RT_IF_ID;
 assign reg_read_addr_1 = RS_IF_ID;
 assign reg_write_data = Register_W_MEM_WB;

 endmodule 
