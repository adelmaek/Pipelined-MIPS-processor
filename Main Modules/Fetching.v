module Fetching (Flush,BranchAdress,MuxBranchControl,clk,PCWrite,IFIDWrite,IFIDpcPlusFour,IFIDinstruction);


input wire Flush; //from hazards unit  
input wire [31:0] BranchAdress; //from decoding module
input wire MuxBranchControl; //from hazards unit
input wire clk;   
input wire PCWrite; //for stalls 
input wire IFIDWrite;//for stalls 

 
output reg [31:0] IFIDpcPlusFour; //Pipeline register IFID
output reg [31:0] IFIDinstruction; //Pipeline register IFID
 
wire[31:0] pcPlusFour;
reg [31:0]PC;     
reg [31:0] InstructionMemory[1023:0];//instruction memory
wire[31:0] muxPc; //output wire of PC mux(to write PCplusFour or Branch address)
wire[31:0] instruction;//output of instruction memory
reg [31:0]PCoverFour;
//reg [31:0] nextpc ;
reg[31:0] PCPLUSFOUR; 

assign pcPlusFour=PCPLUSFOUR;
assign instruction=InstructionMemory[PCoverFour];


//**********************************Initialization Block For Simulation*********************************************************************
initial 
begin
//write file name to intialize instruction memory
$readmemh("6th.list",InstructionMemory);

PC=0; 
#102
IFIDinstruction=32'hxxxxxxxx;
IFIDpcPlusFour=32'hxxxxxxxx;
end
//******************************************************************************************************************************************
 
always@(posedge clk)
begin
if(Flush && PCWrite)
begin
IFIDpcPlusFour<=0;
IFIDinstruction<=0;
end
else if(IFIDWrite)
begin
#1
IFIDpcPlusFour<=pcPlusFour;
IFIDinstruction<=instruction;
end
if(PCWrite)
begin
PC=muxPc; 
end
end 

always@(PC)
begin
PCPLUSFOUR=PC+4;
PCoverFour=PC>>2;
end

Mux mux1 (pcPlusFour,BranchAdress,MuxBranchControl,muxPc);

endmodule



