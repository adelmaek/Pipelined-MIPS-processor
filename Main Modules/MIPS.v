module MIPS(); 
wire stall;
wire IFIDWrite; 
wire Flush;
wire[31:0] PC; 
wire [31:0]BranchAdress;//from Decoding to Fetching
wire MuxBranchControl;//el mfrod lma ne3ml el branch control to Fetching //we changed it to wire 
wire clk;
wire [31:0]IFIDpcPlusFour;//from Fetching to decoding
wire [31:0]IFIDinstruction;//from Fetching to decoding
wire [31:0]writeData;//from WB mux to Decoding  
wire [4:0]MemWBwritereg;//from MemWB pipeline to Decoding  
wire[4:0]ToWritereg; 
wire WriteRegEnable;//from control unit to Decoding
wire controlUnitWriteRegEnable;
wire AluSrc;//from control unit to Decoding 
wire Reg_Dst;//from control unit to Decoding
wire [3:0] OperationCode;//from control unit to Decoding
wire WriteMemoryEnable; //from control unit to Decoding
wire ReadMemoryEnable;//from control unit to Decoding
wire writebackRegCtrl;//from control unit to Decoding
wire [31:0]IDIExreadData1;//from Decoding to Executing
wire [31:0]IDIExreadData2;//from decoding to executing
wire [5:0]opCode;//from Decoding to ControlUnit
wire [4:0]IDExRs;//from Decoding to Executing 
wire [4:0]IDExRt;//from Decoding to Executing
wire [4:0]IDExRd;//from Decoding to Executing
wire [31:0]IDExImmediateFieldSignextended;//from Decoding to Executing
wire IDExWriteRegEnable;//from Decoding to Executing
wire [1:0] AluOp;
wire [1:0]IDExAluOp;//from Decoding to Executing
wire IDExWriteMemoryEnable;//from Decoding to Executing
wire IDExReadMemoryEnable;//from Decoding to Executing
wire IDExwritebackRegCtrl;//from Decoding to Executing
wire [4:0]shiftamt;
wire [5:0]FunctionCode;
wire [31:0]ExMemAluOutput;//from Mem phase to Forwarding mux
wire [31:0]WriteBackValue;//from Mem phase to Forwarding mux
wire form_IDExReg_dst_to_Reg_dst;//from pipeline to muxCtrl in Executing
wire form_IDExAluSrc_to_AluSrc;//from pipeline to muxCtrl in Executing
wire [1:0]ForwardingMux1Ctrl;//from Forwarding unit to muxCtrl in Executing
wire [1:0]ForwardingMux2Ctrl;//from Forwarding unit to muxCtrl in Executing
wire [31:0]ExMemAluout;//pipeline register
wire [31:0]ExMemReadData2;
wire [4:0]ExMemDestination_Rt_RdOutput;
wire ExMemWriteRegEnable;
wire from_ExMemWriteMemoryEnable_to_writeMemoryEnable;
wire from_ExMemReadMemoryEnable_to_readMemoryEnable;
wire ExMemwritebackRegCtrl;
wire [31:0]MemWbAluOutput;//************kont katbha [4:0]****************
wire [31:0]MemWbMemoryReadData;
wire [4:0]MemWbDestination_Rt_RdOutput;
wire MemWbwriteRegEnable;
wire MemWbwritebackRegCtrl;  
wire Branch; 
wire [4:0] IFIDRs;//for hazards unit
wire [4:0] IFIDRt;//for hazards unit
wire IDEXFlush ;//output from hazard to IDEX
wire [1:0] CompSel1,CompSel2;
wire [1:0]ExMemAluOp;
/*initial
begin
MuxBranchControl=0; 
end
*/



Fetching Fetch (Flush,BranchAdress,MuxBranchControl,clk,PCWrite,IFIDWrite,IFIDpcPlusFour,IFIDinstruction);
//Fetching fetch (Flush,PC,clk,IFIDWrite,IFIDpcPlusFour,IFIDinstruction);
//PC pc(BranchAdress,MuxBranchControl,clk,PCWrite,PC);

Decoding Decode (CompSel1,CompSel2,ExMemAluout,IDEXFlush,stall,IFIDpcPlusFour,IFIDinstruction,clk,writeData,ToWritereg,controlUnitWriteRegEnable,WriteRegEnable,AluSrc,
Reg_Dst,AluOp,WriteMemoryEnable,ReadMemoryEnable,writebackRegCtrl,BranchAdress,IDIExreadData1,IDIExreadData2,opCode,IDExRs,
IDExRt,IDExRd,
IDExImmediateFieldSignextended,IDExWriteRegEnable,form_IDExAluSrc_to_AluSrc,form_IDExReg_dst_to_Reg_dst,IDExAluOp,
IDExWriteMemoryEnable,
IDExReadMemoryEnable,IDExwritebackRegCtrl,IDIExpcplusfour,shiftamt,FunctionCode,IFIDRs,IFIDRt,branchResult);

ControlUnit Control( opCode , Reg_Dst ,AluSrc , Branch , ReadMemoryEnable , WriteMemoryEnable , controlUnitWriteRegEnable , 
writebackRegCtrl , AluOp);


execution Execute (IDIExreadData1,IDIExreadData2,ExMemAluout/*ExMemAluoutput input(for Ex)wire from pipeline */,writeData/*WriteBackValue*/,
IDExRs,IDExRt,IDExRd,IDExImmediateFieldSignextended,
IDExWriteRegEnable,
OperationCode,
IDExAluOp,form_IDExReg_dst_to_Reg_dst,form_IDExAluSrc_to_AluSrc,ForwardingMux1Ctrl,ForwardingMux2Ctrl,IDExWriteMemoryEnable,
IDExReadMemoryEnable,
IDExwritebackRegCtrl,clk,shiftamt,FunctionCode,ExMemAluout,ExMemReadData2,ExMemDestination_Rt_RdOutput,
ExMemwriteRegEnable,from_ExMemWriteMemoryEnable_to_writeMemoryEnable,
from_ExMemReadMemoryEnable_to_readMemoryEnable,ExMemwritebackRegCtrl,ExMemAluOp);


memory Memory (ExMemAluOp,ExMemAluout,ExMemReadData2,ExMemDestination_Rt_RdOutput,
from_ExMemWriteMemoryEnable_to_writeMemoryEnable,from_ExMemReadMemoryEnable_to_readMemoryEnable,
ExMemwriteRegEnable,ExMemwritebackRegCtrl,clk,MemWbAluOutput,
MemWbMemoryReadData,MemWbDestination_Rt_RdOutput,MemWbwriteRegEnable,MemWbwritebackRegCtrl);

WriteBack writeBack (MemWbAluOutput,MemWbMemoryReadData,MemWbDestination_Rt_RdOutput,MemWbwriteRegEnable,MemWbwritebackRegCtrl,
MemWBwritereg,writeData,
ToWritereg,
WriteRegEnable);

forwarding forwardingUnit(ExMemwriteRegEnable,ExMemDestination_Rt_RdOutput,IDExRs,IDExRt, MemWbwriteRegEnable,
MemWbDestination_Rt_RdOutput,
ForwardingMux1Ctrl,ForwardingMux2Ctrl);
 

AluControl ALUControl(FunctionCode , IDExAluOp , OperationCode);


HazardDetection hazard (
IDExReadMemoryEnable,
from_ExMemReadMemoryEnable_to_readMemoryEnable,
ExMemDestination_Rt_RdOutput,
IDExRt,
IFIDRs,
IFIDRt,
IDExRd,
IDExAluOp,
Branch,		//from control unit
branchResult,	//from XOR and Or then not//ID stage 
opCode,
IFIDWrite,
PCWrite,
stall,
Flush,
MuxBranchControl,
IDEXFlush
);
BranchForwarding branchhandling( 
stall,
 Branch,
 MemWbwriteRegEnable, //from 
 ExMemAluOp,	//from EXMEM
 ExMemDestination_Rt_RdOutput,
 ToWritereg, 
 IFIDRs,
 IFIDRt,
 CompSel1,
 CompSel2
);




clock MIPSclock (clk);
endmodule
//hn7tag ne3dl fe ALUop 3shan tb2a input lel ALucontrol w el ALucontrol tb2a tela3 output lel ALU





