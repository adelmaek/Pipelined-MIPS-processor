module execution(IDIExreadData1,IDIExreadData2,ExMemAluOutput,WriteBackValue,IDExRs,IDExRt,IDExRd,IDExImmediateFieldSignextended,IDEXWriteRegEnable,
OperationCode,IDExAluOp,Reg_dst,AluSrc,ForwardingMux1Ctrl,ForwardingMux2Ctrl,IDExWriteMemoryEnable,IDExReadMemoryEnable,IDExwritebackRegCtrl,clk,
shiftamt,FunctionCode,ExMemAluout,ExMemReadData2,ExMemDestination_Rt_RdOutput,ExMemWriteRegEnable,ExMemWriteMemoryEnable,
ExMemReadMemoryEnable,ExMemwritebackRegCtrl,ExMemAluOp); 
 
input wire signed[31:0]IDIExreadData1;//from IDEx pipeline (read Data1)
input wire signed[31:0]IDIExreadData2;//from IDEx pipeline (read Data2)
input wire signed[31:0]ExMemAluOutput;//from memory phase for forwarding
input wire signed[31:0]WriteBackValue;//from memory phase for forwarding
input wire [4:0] IDExRs;//from IDEx pipeline
input wire [4:0] IDExRt;//from IDEx pipeline
input wire [4:0] IDExRd;//from IDEx pipeline
input wire signed[31:0] IDExImmediateFieldSignextended;//from IDEx pipeline
input wire IDEXWriteRegEnable;
input wire [3:0] OperationCode;//from ALU control Unit
input wire [1:0] IDExAluOp;//from IDEx pipeline
input wire Reg_dst;//from IDEx pipeline
input wire AluSrc;//from IDEx pipeline
input wire [1:0]ForwardingMux1Ctrl;//from forwarding Unit
input wire [1:0] ForwardingMux2Ctrl;//from forwarding Unit
input wire IDExWriteMemoryEnable;//from IDEx pipeline
input wire IDExReadMemoryEnable; //from IDEx pipeline
input wire IDExwritebackRegCtrl;//from IDEx pipeline
input wire clk;
input wire [4:0]shiftamt;
input wire [5:0]FunctionCode;

output reg [1:0] ExMemAluOp;
output reg signed[31:0]ExMemAluout;//output of alu to pipeline
output reg signed[31:0]ExMemReadData2;//Rt for memory operations(lw,Sw)
output reg[4:0]ExMemDestination_Rt_RdOutput;//Ex MEm pipeline (write back destination)
output reg ExMemWriteRegEnable;//Ex MEm pipeline
output reg ExMemWriteMemoryEnable;//Ex MEm pipeline
output reg ExMemReadMemoryEnable;//Ex MEm pipeline
output reg ExMemwritebackRegCtrl;//Ex MEm pipeline


wire [4:0] Destination_Rt_RdOutput; 
wire signed[31:0] forwardingMux1Output;
wire signed[31:0] forwardingMux2Output;
wire signed[31:0] AluSeconedInputMuxOutput;
wire signed[31:0] AluResult;
wire overflow;


always@(posedge clk)
begin
ExMemAluout<=AluResult;
ExMemReadData2<=forwardingMux2Output;
ExMemDestination_Rt_RdOutput<=Destination_Rt_RdOutput;
ExMemWriteRegEnable<=IDEXWriteRegEnable;
ExMemReadMemoryEnable<=IDExReadMemoryEnable;
ExMemwritebackRegCtrl<=IDExwritebackRegCtrl;
ExMemWriteMemoryEnable<=IDExWriteMemoryEnable;
ExMemAluOp<=IDExAluOp;

end 
alu myalu (OperationCode, forwardingMux1Output, AluSeconedInputMuxOutput,AluResult, shiftamt,overflow);
mux3x2 forwardingMux1 (IDIExreadData1,ExMemAluOutput,WriteBackValue,ForwardingMux1Ctrl,forwardingMux1Output);
mux3x2 forwardingMux2 (IDIExreadData2,ExMemAluOutput,WriteBackValue,ForwardingMux2Ctrl,forwardingMux2Output);
Mux Destination_Rt_Rd (IDExRt,IDExRd,Reg_dst,Destination_Rt_RdOutput);
Mux AluSeconedInputMux(forwardingMux2Output,IDExImmediateFieldSignextended,AluSrc,AluSeconedInputMuxOutput);

endmodule


