
module AluControl(FunctionCode , AluOp , OperationCode);
input[5:0] FunctionCode ; // comes from instruction first 6 instructions [5:0]
input [1:0] AluOp ; // coming from control unit 
output reg [3:0] OperationCode ; // input to alu 

always @ (*) 
begin 
	if ( AluOp == 2'b00) // we don't care abt the function code 
		OperationCode = 4'b0010; // this means lw or store //ben7tag ne3ml add fel alu 
	//else if (AluOp == 2'b01)
		//OperationCode = 4'b0110; // means branch equal  // ben3ml substract 
	else if ( AluOp == 2'b10 && FunctionCode == 6'b100000)
	 	OperationCode = 4'b0010; // add 
	else if ( AluOp == 2'b10 && FunctionCode == 6'b100010)
		OperationCode = 4'b0110; //substract
	else if ( AluOp == 2'b10 && FunctionCode == 6'b100100)
		OperationCode = 4'b0000; //and operation
	else if ( AluOp == 2'b10 && FunctionCode == 6'b100101)
		OperationCode = 4'b0001; //or operation 
	else if ( AluOp == 2'b10 && FunctionCode == 6'b101010)
		OperationCode = 4'b0111; //set on less than 
	else if ( AluOp == 2'b10 && FunctionCode == 6'b000000)
		OperationCode = 4'b1110; //shift left logical 
	else if ( AluOp == 2'b10 && FunctionCode == 6'b100111)
		OperationCode = 4'b1100; //nor operation 
end
endmodule 
