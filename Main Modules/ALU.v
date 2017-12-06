module alu (op, x, y,z, shiftamt,overflow);
	input [3:0] op; //4 bits coming from alu control 
	input signed [31:0] x,y; // input 1 and input 2 respectively 
	input [4:0] shiftamt; // instruction bits [10:6]
	output reg signed[31:0] z; // alu output 
	output reg overflow;
	
	wire signed[31:0] ynegated;
	assign ynegated = -y;
	initial
	overflow=0;
	always@(*)
	begin	
	
	case (op)

	4'b0010:z <=x+y;
	4'b0110:z <=x-y;
	4'b0000:z <=x&y;
	4'b0001:z <=x|y; 
	4'b1110:z <=y<<shiftamt;
	//4'd5:z <=x>>shiftamt;
	//4'd6:z <=(x>>>shiftamt); //arithmetic
	//4'd7: z=(x>y? x:y);
	//4'd8:z=(x<y? x:y);

	endcase 
	if (  (x[31]==y[31]) && (z[31]==~x[31]) && op==4'b0010 )
	begin
	overflow<=1;
	end
	else if(  (x[31]==ynegated[31])  &&  (z[31]==~x[31]) && op==4'b0110 )
	begin
	overflow<=1;
	end
	else
	begin
	overflow<=0;
	end
	end
/*always @*
begin
if(op==6)
begin
z= x>>>shiftamt;
end
end*/
	

endmodule
