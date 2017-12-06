module forwarding(
input EXMEMRegWrite,			//
input [4:0] EXMEMRegisterRd,   		//
input [4:0]IDEXRegisterRs,		//
input [4:0]IDEXRegisterRt,		//
input MEMWBRegWrite,			//
input [4:0]MEMWBRegisterRd,	//
output reg[1:0]ForwardA, 
output reg[1:0]ForwardB 
);  
always @* 
begin

if (EXMEMRegWrite && (EXMEMRegisterRd!=0) && ( EXMEMRegisterRd == IDEXRegisterRs))		//Iwant to write in EXMEM, and I want to use this value in the next instr
ForwardA<=2'b01;								// as an output to the ALU Rd el fatet== Rs delw2ty
else if (MEMWBRegWrite && (MEMWBRegisterRd != 0) 		//i want to write in the thrd instr.	
&& ~(EXMEMRegWrite && (EXMEMRegisterRd != 0) 	&& (EXMEMRegisterRd == IDEXRegisterRs) )//either i dont wanna write in the middle instr,
 //or i want to write in 0
   		//bat2aked en el inst el fl nos maghyrsh Rd
&& (MEMWBRegisterRd == IDEXRegisterRs)) 		///Rs == Rd bta3et el abl el fatet
ForwardA <= 2'b10;
else 
ForwardA=2'b00;
								
if (EXMEMRegWrite && (EXMEMRegisterRd != 0) && ( EXMEMRegisterRd == IDEXRegisterRt)) 		//same case but Rt
ForwardB <=2'b01;

else if (MEMWBRegWrite &&(MEMWBRegisterRd != 0)
&& ~(EXMEMRegWrite && (EXMEMRegisterRd != 0)
&& (EXMEMRegisterRd == IDEXRegisterRt))		//same but Rt
&& (MEMWBRegisterRd ==IDEXRegisterRt)) 
ForwardB <=2'b10;
else 
ForwardB<=2'b00;


end

endmodule



module HazardDetection(

input IDEXMemRead,
input EXMEMMemRead,    		//neww
input [4:0] EXMEMRegisterRt,//new
input [4:0] IDEXRegisterRt,
input [4:0] IFIDRegisterRs,
input [4:0] IFIDRegisterRt,
input [4:0] IDEXRegisterRd,//new
input [1:0] IDEXAluOp , // new 
input Branch,		//from control unit
input BranchResult,	//from XOR and Or then not//ID stage 
input [5:0] opCode,
output reg IFIDWrite,
output reg PCWrite,
output reg stall,
output reg IFIDFlush,
output  wire PCmuxsel,
output reg IDEXFlush		//new

); 


reg PCmuxsell;

assign PCmuxsel=PCmuxsell;
//***********************************************check**********************
initial
begin
IFIDWrite=1;
end
//**************************************************************************




always@*
begin


if (IDEXMemRead &&  (opCode==6'b000000) && 	//if it is a load instruction
((IDEXRegisterRt == IFIDRegisterRs) ||(IDEXRegisterRt == IFIDRegisterRt)))		//checks if I am using the value that I just loaded
begin

stall<=1;//control lines (EX, MEM, and WB)in the ID/EX reg being set to zero only RegWrite and MemWrite
PCWrite<=0;	//control signal sent to PC reg to tell it not to update its values.
IFIDWrite<=0; 	//control signal sent to IFID reg to tell it not to update its values.
IDEXFlush<=0;
end
else if(Branch ==0 || Branch ==1'bx)
begin
IDEXFlush<=0;
stall<=0;
PCWrite<=1;
IFIDWrite<=1;
end

if(Branch && BranchResult )
begin
IFIDFlush<=1;
PCmuxsell<=1;
IDEXFlush<=0;
end
else
begin
 IFIDFlush<=0;
PCmuxsell<=0;
IDEXFlush<=0;
end
end
 

always@*
begin

if(Branch && IDEXAluOp ==2'b10 &&((IFIDRegisterRs==IDEXRegisterRd) || (IFIDRegisterRt==IDEXRegisterRd)))	//case of R inst then Branch inst // do one stall then forward
begin
stall<=1;		//control lines (EX, MEM, and WB)in the ID/EX reg being set to zero only RegWrite and MemWrite
PCWrite<=0;		//control signal sent to PC reg to tell it not to update its values.
IFIDWrite<=0;
IDEXFlush<=0;
end
else
begin
stall<=0;		//control lines (EX, MEM, and WB)in the ID/EX reg being set to zero only RegWrite and MemWrite
PCWrite<=1;		//control signal sent to PC reg to tell it not to update its values.
IFIDWrite<=1;
IDEXFlush<=0;
end

if(Branch && IDEXMemRead &&( (IFIDRegisterRs==IDEXRegisterRt) || (IFIDRegisterRt==IDEXRegisterRt)))
//case of lw inst then Branch inst // do two stalls then forward // first stall
begin
stall<=1;		//control lines (EX, MEM, and WB)in the ID/EX reg being set to zero only RegWrite and MemWrite
PCWrite<=0;		//control signal sent to PC reg to tell it not to update its values.
IFIDWrite<=0;
IDEXFlush<=0;
end

if(Branch && EXMEMMemRead &&( (IFIDRegisterRs==EXMEMRegisterRt) || (IFIDRegisterRt==EXMEMRegisterRt)))
//case of lw inst then Branch inst // that does the second stall
begin
stall<=1;		//control lines (EX, MEM, and WB)in the ID/EX reg being set to zero only RegWrite and MemWrite
PCWrite<=0;		//control signal sent to PC reg to tell it not to update its values.
IFIDWrite<=0;
IDEXFlush<=1;
end
else
IDEXFlush<=0;

end	//end of always at branch



endmodule


////////////////////////////////////////////////////////////////////////////


//branch forwarding 



module BranchForwarding( 
input stall,
input Branch,
input MEMWBMemRead, //from 
input [1:0] AluOp,	//from EXMEM
input [4:0] EXMEMRegisterRd, 	//
input [4:0] MEMWBRegisterRt, 
input [4:0] IFIDRegisterRs,
input [4:0] IFIDRegisterRt,	//
output reg [1:0] CompSel1,
output reg [1:0]  CompSel2
);



always @(*)//negedge stall
begin

if(Branch &&  (AluOp==2'b10) &&(EXMEMRegisterRd==IFIDRegisterRs)  )		//branch instruction just entered the decoding stage 
begin

CompSel1<=2'b01;	
end								////choose the value forwarded from the ALU
else if(Branch && (MEMWBMemRead) && (MEMWBRegisterRt ==IFIDRegisterRs) )		 //branch forawrd bsbab lw
begin

CompSel1<=2'b10;
end
else 
begin

CompSel1<=2'b00;
end

if(Branch && (AluOp==2'b10) && (EXMEMRegisterRd==IFIDRegisterRt)  )
begin

CompSel2<=2'b01;
end
else if(Branch && (MEMWBMemRead) && (MEMWBRegisterRt ==IFIDRegisterRt) )		 //branch 
begin

CompSel2<=2'b10;
end
else 
begin

CompSel2<=2'b00;
end
end



endmodule 

