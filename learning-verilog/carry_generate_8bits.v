'include "block_cla_carry_generate_3bits.v"
'include "cla_carry_generate_2bits.v"
module carry_generate_8bits (p, g, ci, c);
input [7:0] p, g;
input ci;
output [7:0] c;
wire [2:0] ps, gs;
block_cla_carry_generate_2bits bccg1(p[2:0], g[2:0], ci, c[1:0], gs[0], ps[0]);
block_cla_carry_generate_2bits bccg2(p[5:3], g[5:3], c[2], c[4:3], gs[1], ps[1]);
block_cla_carry_generate_2bits bccg3({1'b0, p[7:6]}, {1'b0, g[7:6]}, c[5], c[7:6], gs[2], ps[2]);
cla_carry_generate_2bits ccg1(ps[1:0], gs[1:0], ci, c[2], c[5]);
endmodule