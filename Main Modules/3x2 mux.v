module mux3x2(in0,in1,in2,muxCtrl,out);
input wire [31:0]in0;
input wire [31:0]in1; 
input wire [31:0]in2;
input wire[1:0] muxCtrl;

output reg[31:0] out;

always@(in0,in1,in2,muxCtrl)
begin
case(muxCtrl)
0:out<=in0;
1:out<=in1;
2:out<=in2;
endcase
end
endmodule
