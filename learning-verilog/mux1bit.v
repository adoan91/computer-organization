module mux1bit
(
	input s,
	input x, y,
	output r
);
assign r = ~s & x | s & y;

endmodule