 module Decoding (CompSel1,CompSel2,EXMEMAluOutput,IDEXFlush,stall,IFIDpcplusfour,IFIDinstruction,clk,writeData,MemWBwritereg,
controlUnitWriteRegEnable,WriteRegEnable,AluSrc,Reg_Dst,AluOp,WriteMemoryEnable,ReadMemoryEnable,writebackRegCtrl,BranchAdress,IDIExreadData1,
IDIExreadData2,opCode,IDExRs,IDExRt,IDExRd,IDExImmediateFieldSignextended,IDExWriteRegEnable,IDExAluSrc,IDExReg_dst,IDExAluOp,
IDExWriteMemoryEnable,IDExReadMemoryEnable,IDExwritebackRegCtrl,IDIExpcplusfour,shiftamt,FunctionCode,IFIDRs,IFIDRt,branchResult);

integer file ;//**********For Simulation(writes the output written in Register Files in a File called "output.txt")

input wire IDEXFlush;//to flush IDEx pipeline
input wire stall;//from hazards unit
input wire [31:0]IFIDpcplusfour; //from IFID pipeline
input wire [31:0]IFIDinstruction;  //from IFID pipeline
input wire clk;     
input wire [31:0] writeData;//from write back module
input wire[4:0] MemWBwritereg;//write back destination
input wire controlUnitWriteRegEnable;//from control unit
input wire WriteRegEnable;// from write back module
input wire AluSrc; //from control unit  
input wire Reg_Dst;//from control unit then it propagates through pipeline
input wire [1:0]AluOp;//from ControlUnit to pipeline to ALUCOntrol Unit
input wire WriteMemoryEnable;//from control unit 
input wire ReadMemoryEnable; // from control unit 
input wire writebackRegCtrl; // from control unit  
input wire [31:0] EXMEMAluOutput;//for branch hazards mux
input wire [1:0]  CompSel1;//selector of branch hazards mux
input wire [1:0]  CompSel2;//selector of branch hazards mux

output reg signed[31:0] BranchAdress;//for fetching module
output reg[31:0] IDIExreadData1; //IDEx pipeline(data read from reg file)
output reg[31:0] IDIExreadData2;//IDEx pipeline(data read from reg file)
output wire [5:0] opCode;//to control unit
output reg[4:0]IDExRs;//IDEx pipeline(Rs field)
output reg[4:0]IDExRt;//IDEx pipeline(Rt field)
output reg[4:0]IDExRd;//IDEx pipeline(Rd field)
output reg signed[31:0]IDExImmediateFieldSignextended;//IDEx pipeline(to calculate LW address) 
output reg IDExWriteRegEnable;//IDEx pipeline
output reg IDExAluSrc;//IDEx pipeline(to choose Alu seconed operand)
output reg IDExReg_dst;//IDEx pipeline(to choose write back destination)
output reg[1:0] IDExAluOp;//IDEx pipeline (input to alu control unit)
output reg IDExWriteMemoryEnable;//IDEx pipeline
output reg IDExReadMemoryEnable;//IDEx pipeline
output reg IDExwritebackRegCtrl;//IDEx pipeline
output reg[31:0] IDIExpcplusfour;//for (exception*not supported*)
output reg[4:0] shiftamt;
output reg [5:0] FunctionCode;
output wire [4:0] IFIDRs;
output wire [4:0] IFIDRt;
output reg branchResult;//Result of branch equal



wire signed[31:0] readData1; 
wire signed [31:0] readData2; 
wire [4:0]readReg1;
wire [4:0] readReg2;
reg signed [31:0] registerFile[31:0];
reg signed[31:0] ImmediateFieldSignextendedShifted;
wire signed[31:0] ImmediateFieldSignextended;//da ana ghyrto mkhltosh input
reg signed[31:0] shiftresult; 
wire stallMux1Output; 
wire stallMux2Output;
wire [31:0] compare1;
wire [31:0] compare2;

assign readData1 = registerFile[readReg1];
assign readData2 = registerFile[readReg2];
assign readReg1=IFIDinstruction[25:21];
assign readReg2=IFIDinstruction[20:16];
assign opCode = IFIDinstruction[31:26];
assign IFIDRt = IFIDinstruction[20:16];
assign IFIDRs = IFIDinstruction[25:21];

initial
begin
registerFile[0]=0;
/*
//$monitor($time,,"registerFile[20]=%d",registerFile[20]);
registerFile[0]<=0;
registerFile[1]<=1;
registerFile[2]<=2;
registerFile[3]<=3;
registerFile[4]<=4;
registerFile[5]<=5;
registerFile[6]<=6;
registerFile[7]<=7;
registerFile[8]<=8;
registerFile[9]<=9;
registerFile[10]<=10;
registerFile[11]<=11;
registerFile[12]<=12;
registerFile[13]<=13;
registerFile[14]<=14;
registerFile[15]<=15;
registerFile[16]<=16;
registerFile[17]<=17;
registerFile[18]<=18;
registerFile[19]<=19;
registerFile[20]<=20;
registerFile[21]<=21;
registerFile[22]<=22;
registerFile[23]<=23;
registerFile[24]<=24;
registerFile[25]<=25;
registerFile[26]<=26;
registerFile[27]<=27;
registerFile[28]<=28;
registerFile[29]<=29;
registerFile[30]<=30;
registerFile[31]<=31;
*/
file = $fopen("output.text"); 
end


always@(compare1,compare2)
begin
if( compare1==compare2)
begin
branchResult=1;
end
else
begin
branchResult=0;
end
end

//**********************************************for testing*********************************
always@(registerFile[MemWBwritereg])
begin
if(WriteRegEnable)
begin
#1
$display($time,,"clk=%b  registerFile[%d]=%d",clk,MemWBwritereg,registerFile[MemWBwritereg]);
$fwrite (file,$time,,"clk=%b  registerFile[%d]=%d",clk,MemWBwritereg,registerFile[MemWBwritereg]);
$fwrite(file,"\n");
end
end
//*******************************************************************************************
always@(ImmediateFieldSignextended)
begin

shiftresult=ImmediateFieldSignextended<<2;
#1
ImmediateFieldSignextendedShifted =shiftresult;
#1
BranchAdress<=(IFIDpcplusfour+ImmediateFieldSignextendedShifted);
//IDIExpcplusfour<=IFIDpcplusfour;
end

always@(writeData,MemWBwritereg)//mesh el mfrod m3 el clock ?
begin
if(WriteRegEnable)
begin
registerFile[MemWBwritereg] <= writeData;
end
end

always@(posedge clk)
begin 
shiftamt<=IFIDinstruction[10:6];
FunctionCode<=IFIDinstruction[5:0];
if (IDEXFlush==0)
begin
IDIExreadData2<=readData2;
IDIExreadData1<=readData1; 
IDExRs<=readReg1;
IDExRt<=readReg2;
IDExRd<=IFIDinstruction[15:11];
IDExWriteRegEnable<=stallMux1Output;
IDExAluSrc<=AluSrc;
IDExReg_dst<=Reg_Dst;
IDExAluOp<=AluOp;
IDExWriteMemoryEnable<=stallMux2Output;
IDExReadMemoryEnable<=ReadMemoryEnable;
IDExwritebackRegCtrl<=writebackRegCtrl;
IDExImmediateFieldSignextended<=ImmediateFieldSignextended;
end 
else if (IDEXFlush)
begin
IDIExreadData2<=0;
IDIExreadData1<=0; 
IDExRs<=0;
IDExRt<=0;
IDExRd<=0;
IDExWriteRegEnable<=0;
IDExAluSrc<=0;
IDExReg_dst<=0;
IDExAluOp<=0; 
IDExWriteMemoryEnable<=0;
IDExReadMemoryEnable<=0;
IDExwritebackRegCtrl<=0;
IDExImmediateFieldSignextended<=0;
end
end


SignExtend s1(IFIDinstruction[15:0],ImmediateFieldSignextended);
Mux1bit stallMux1 (controlUnitWriteRegEnable,0,stall,stallMux1Output);
Mux1bit stallMux2 (WriteMemoryEnable,0,stall,stallMux2Output);

mux3x2 branchhazardmux1(readData1,EXMEMAluOutput,writeData,CompSel1,compare1);
mux3x2 branchhazardmux2 (readData2,EXMEMAluOutput,writeData,CompSel2,compare2);

endmodule
