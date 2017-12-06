module RegisterFile (readReg1,readReg2,writeReg,writeData,writeEnable,clk,readData1,readData2);
input wire [4:0] readReg1;
input wire [4:0] readReg2;
input wire [4:0] writeReg;
input wire [31:0] writeData; 
input wire writeEnable;
input wire clk;
output reg [31:0] readData1;
output reg [31:0] readData2;
reg signed [31:0] Registers [31:0]; 

 

always@*
begin
readData1 <= Registers [readReg1];
readData2 <= Registers [readReg2];
end


always@(posedge clk)
begin
if(writeEnable)
begin
Registers[writeReg]=writeData;
end

end 
/*
initial
begin
$monitor($time,,,"%d   %d   %d    %b",Registers[0],Registers[1],Registers[2], clk);
end
*/

endmodule 


//************************************************************************************************
//Testing
/*

module TestingRegisters;

reg [3:0] readReg1;
reg [3:0] readReg2;
reg [3:0] writeReg;
reg [31:0] writeData;
reg writeEnable;
wire clk;
wire [31:0] readData1;
wire [31:0] readData2;

initial 
begin 
$monitor ($time,,,"%b  %b",readData1,clk);
#10
readReg1=0;
#20
writeReg <=0;
writeData<=32'hffffffff;
writeEnable<=1;
readReg1<=0;
#55
writeReg <=0;
writeData<=32'h0000ffff;
writeEnable<=1;
readReg1<=0;
end 
clock c1 (clk);
RegisterFile R1 (readReg1,readReg2,writeReg,writeData,writeEnable,clk,readData1,readData2);

endmodule

*/
