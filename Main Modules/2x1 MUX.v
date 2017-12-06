module Mux(data1,data2,muxCtrl,out);
input wire[31:0] data1;
input wire[31:0] data2;
input muxCtrl;
output reg [31:0]out;

//assign out = muxCtrl?data2:data1;
always@(data1,data2,muxCtrl)
begin
if(muxCtrl==1)
out = data2;
else if(muxCtrl==0)
out = data1;

end 



endmodule





module Mux1bit (data1,data2,muxCtrl,out);


input wire data1;
input wire data2;
input wire muxCtrl;
output wire out;

assign out = muxCtrl?data2:data1;
	


endmodule

 