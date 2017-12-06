module clock(clk);
output reg clk;
initial 
begin
clk<=1'b0; 
end
always
begin
#100
clk<=~clk; 
end

endmodule
