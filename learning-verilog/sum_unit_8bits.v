module sum_unit_8bits (p, c, s);
input [7:0] p, c;
output [7:0] s;
assign s = p ^ c;
endmodule