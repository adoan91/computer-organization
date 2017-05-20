module cla_carry_generate_2bits (ps, gs, ci, c2, c5);
input [1:0] ps, gs;
input ci;
output c2, c5;

assign c2 = gs[0] | ps[0] & ci;
assign c5 = gs[1] | ps[1] & gs[0] | ps[1] & ps[0] & ci;
endmodule;