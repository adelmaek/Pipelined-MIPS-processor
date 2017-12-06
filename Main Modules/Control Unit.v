module ControlUnit ( OpCode , RegDst ,AluSrc , Branch , MemRead , MemWrite , RegWrite , Memtoreg ,AluOp  );
input [5:0] OpCode ; // comes from instruction last 6 instructions [31:26]
output reg RegDst , AluSrc , Branch , MemRead , MemWrite , RegWrite , Memtoreg ; 
output reg [1:0] AluOp ; 

always @(OpCode) 
begin  
	case (OpCode) 
		6'b000000: //r-format
			begin
			
			RegDst <= 1;
			AluSrc <= 0;
			Branch <= 0;
			MemRead <= 0;
			MemWrite <= 0;
			RegWrite <= 1;
			Memtoreg <= 0;
			AluOp <= 2'b10;
			end
		6'b100011: //lw instruction
			begin
			
			RegDst = 0;
			AluSrc = 1;
			Branch = 0;
			MemRead = 1;
			MemWrite = 0;
			RegWrite = 1;
			Memtoreg = 1;
			AluOp = 2'b00;
			end
		6'b101011: // sw instruction
			begin
			
			//RegDst = 1; dn't care 
			AluSrc = 1;
			Branch = 0;
			MemRead = 0;
			MemWrite = 1;
			RegWrite = 0;
			//Memtoreg = 0; dn't care 
			AluOp = 2'b00;
			end
		6'b000100: //branch instruction
			begin
			
			//RegDst = 1; dn't care 
			AluSrc = 0;
			Branch = 1;
			MemRead = 0;
			MemWrite = 0;
			RegWrite = 0;
			//Memtoreg = 0; dn't care
			AluOp = 2'b01;
			end
//for initialization of PC issues
		6'bxxxxxx:
			begin	
			AluSrc = 1'bx;
			Branch = 1'bx;
			MemRead = 1'bx;
			MemWrite = 1'bx;
			RegWrite = 1'bx;
			//Memtoreg = x; dn't care
			AluOp = 2'bxx;
			end
	endcase
end 
endmodule 

