module WriteBack(MemWbAluOutput,MemWbMemoryReadData,MemWbDestination_Rt_RdOutput,MemWbWriteRegEnable,
MemWbwritebackRegCtrl,MemWBwritereg,writeData
,ToWritereg, WriteRegEnable);

input wire signed[31:0] MemWbAluOutput; //input from MemWb Pipeline (output of ALU (R-instructions))
input wire signed[31:0] MemWbMemoryReadData;//input from MemWb Pipeline (data read from memory)
input wire [4:0] MemWbDestination_Rt_RdOutput;//input from MemWb Pipeline(write back destination)
input wire MemWbWriteRegEnable;//input from MemWb Pipeline (write reg enable --> input to decoding module)
input wire MemWbwritebackRegCtrl; //selector of write back mux
input wire[4:0] MemWBwritereg;

output wire signed[31:0] writeData;//From write back mux to Decoding (to write data into reg file)
output wire[4:0] ToWritereg; // to Decoding module  (write back destination)
output wire WriteRegEnable; // to decoding module

assign RegFileWriteReg = MemWbDestination_Rt_RdOutput;
assign WriteRegEnable = MemWbWriteRegEnable;
assign ToWritereg =MemWbDestination_Rt_RdOutput;


Mux writeBackMux (MemWbAluOutput,MemWbMemoryReadData,MemWbwritebackRegCtrl,writeData);

endmodule
