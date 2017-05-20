module pg_unit_8bits (a, b, p, g);
input [7:0] a, b;
output [7:0] p, g;
assign p = a ^ b;
assign g = a & b;
endmodule