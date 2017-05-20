module block_cla_carry_generate_2bits (p, g, ci, c, gs, ps);
input [2:0] p, g;
input ci;
output [1:0] c;
output gs, ps;
assign		c[0] = g[0] | p[0] & ci;
assign		c[1] = g[1] | p[1] & g[0] | p[1] & p[0] & ci;
assign		gs = g[2] | p[2] & g[1] | p[2] & p[1] & g[0];
assign		ps = p[2] & p[1] & p[0];
endmodule