module SignExtend(ImmediateField,ImmediateFieldSignextended);
input wire signed[15:0]ImmediateField; 
output reg signed[31:0] ImmediateFieldSignextended;
always@(ImmediateField)
begin
if(ImmediateField[15]==0) 
begin
#10
ImmediateFieldSignextended = {16'h0000,ImmediateField};
end
else if(ImmediateField[15]==1)
begin
#10
ImmediateFieldSignextended = {16'hffff,ImmediateField};
end
end
 

endmodule

