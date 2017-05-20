'include "pg_unit_8bits.v"
'include "carry_generate_8bits.v"
'include "sum_unit_8bits.v"
module adder_8bits
(
	input [7:0] a, b,
	input ci,
	output [7:0] s,
	output c6, c7
);
wire [7:0] c, p, g;
assign c6 = c[6];
assign c7 = c[7];
pg_unit_8bits pgu1(a, b, p, g);
carry_generate_8bits cgu1(p, g, ci, c);
sum_unit_8bits su1(p, {c[6:0], ci}, s);
endmodule