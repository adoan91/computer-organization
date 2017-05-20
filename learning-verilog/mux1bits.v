module mux1bits
(
	input s,
	input x, y,
	output reg r
);

always@(s or x or y)
begin
	if (s == 1'b0)
		r = x;
	else
		r = y;
end

endmodule