'timescale 1ns/100ps
module full_adder
(
   input a, b, cin,
   output reg s, cout
);  //defines a module's name and its interface signals

always@(a or b or cin)
begin
	case ({a, b, cin})
	3'b000: begin s = 0; cout = 0; end
	3'b001: begin s = 1; cout = 0; end
	3'b010: begin s = 1; cout = 0; end
	3'b011: begin s = 0; cout = 1; end
	3'b100: begin s = 1; cout = 0; end
	3'b101: begin s = 0; cout = 1; end
	3'b110: begin s = 0; cout = 1; end
	3'b111: begin s = 1; cout = 1; end
	default: begin s = 0; cout = 0; end
	endcase

/*
wire out1, out2, out3; //defines local signal names

xor		#3 x1(out1, a, b);
xor		#3 x2(s, out1, cin);
nand	#1 n1(out2, out1, cin);
nand	#1 n2(out3, a, b);
nand	#1 n3(cout, out2, out3);
*/

end

endmodule