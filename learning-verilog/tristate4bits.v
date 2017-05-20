module tristate4bits
(
	input _e,	//declared active-low
	input [3:0] x,
	output reg [3:0] r
);
always@(*)
begin
	if (_e == 1'b0)
		r = x;
	else
		r = 4'bz;	//or r = 4'bzzzz;
end
endmodule