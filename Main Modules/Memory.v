module memory (ExMemAluOp,ExMemAluOutput,ExMemReadData2,ExMemDestination_Rt_RdOutput,
writeMemoryEnable,readMemoryEnable,ExMemwriteRegEnable,ExMemwritebackRegCtrl,clk,MemWbAluOutput,
MemWbMemoryReadData,MemWbDestination_Rt_RdOutput,MemWbwriteRegEnable,MemWbwritebackRegCtrl);

integer file ;

input wire signed[31:0]ExMemAluOutput;//input from ExMem pipeline
input wire signed[31:0]ExMemReadData2;//output of seconed forwarfing mux for -->input data to memory
input wire[4:0]ExMemDestination_Rt_RdOutput; //input from ExMem pipeline (destination to write back in it) 
input wire writeMemoryEnable;//input from ExMem pipeline
input wire readMemoryEnable; //input from ExMem pipeline
input wire ExMemwriteRegEnable;//input from ExMem pipeline & will propagate to MemWb pipeline
input wire ExMemwritebackRegCtrl;//input from ExMem pipeline & will propagate to MemWb pipeline 
input wire clk;
input wire [1:0]ExMemAluOp;//input from ExMem pipeline for hazars

output reg signed[31:0] MemWbAluOutput; //output to MemWb pipeline  (output of R instruction)
output reg signed[31:0] MemWbMemoryReadData;//output to MemWb pipeline(output of LW)
output reg [4:0] MemWbDestination_Rt_RdOutput;//pipelined Wb destination
output reg MemWbwriteRegEnable;
output reg MemWbwritebackRegCtrl;


reg signed[31:0] DataMemory [1023:0];//Data memory (initialized by index of each word)
wire [31:0] MemoryReadData;//output port of data memory
reg [31:0] shiftedValue;//for calculating LW address


assign MemoryReadData = DataMemory[shiftedValue];


//**************************************************Initializing Data memory by index of each word***************************************
initial
begin
DataMemory[0]=0;
DataMemory[1]=1;
DataMemory[2]=2;
DataMemory[3]=3;
DataMemory[4]=4;
DataMemory[5]=5;
DataMemory[6]=6;
DataMemory[7]=7;
DataMemory[8]=8;
DataMemory[9]=9;
DataMemory[10]=10;
DataMemory[11]=11;
DataMemory[12]=12;
DataMemory[13]=13;
DataMemory[14]=14;
file = $fopen("output.text"); 
end
//*************************************************************************************************************************************
//*****************************************************for testing (output of SW instructions)*****************************************
always@(DataMemory[shiftedValue])
begin
if(writeMemoryEnable)
begin
#2
$display($time,,"clk=%b  DataMemory[%d]=%d",clk,shiftedValue,DataMemory[shiftedValue]);
$fwrite (file,$time,,"clk=%b  DataMemory[%d]=%d",clk,shiftedValue,DataMemory[shiftedValue]);
$fwrite(file,"\n");
end
end
//***************************************************************************************************************************************


always@(ExMemAluOutput)
begin
#1
shiftedValue<=ExMemAluOutput>>2;
end

always@*
begin
/*
if(readMemoryEnable)
begin
MemWbMemoryReadData<=MemoryReadData;
end
*/
if(writeMemoryEnable)
begin
#1
DataMemory[shiftedValue]<=ExMemReadData2;
end
end

always@(posedge clk)
begin

if(readMemoryEnable)
begin
MemWbMemoryReadData<=MemoryReadData;
end

MemWbAluOutput<=ExMemAluOutput;
MemWbDestination_Rt_RdOutput<=ExMemDestination_Rt_RdOutput;
MemWbwriteRegEnable<=ExMemwriteRegEnable;
MemWbwritebackRegCtrl<=ExMemwritebackRegCtrl;
end

endmodule
