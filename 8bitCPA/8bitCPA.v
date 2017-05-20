module 4bitCLAadder
(
	input [3:0] A, B;
	input cin;
	output [3:0] S;
	output cout;
);
	wire [3:0] p, g, c, out1, out2;
	
	/*	PG unit (PGU)	*/
	assign p[0] = A[0] ^ B[0]; //	propagate
	assign g[0] = A[0] & B[0]; //	generate
	assign p[1] = A[1] ^ B[1];
	assign g[1] = A[1] & B[1];
	assign p[2] = A[2] ^ B[2];
	assign g[2] = A[2] & B[2];
	assign p[3] = A[3] ^ B[3];
	assign g[3] = A[3] & B[3];
	
	/*	Carry-generate Unit (CGU)	*/
	assign c[0] = 	g[0] | 
					p[0] & cin;
	/*
	assign c[1] = 	g[1] | 
					p[1] & g[0] | 
					p[1] & p[0] & cin;
	*/
	nor		n1(out1, g[1], g[1]);
	nor		n2(out2, p[1], c[0]);
	nor		n3(c[1], out1, out2);
	assign c[2] = 	g[2] | 
					p[2] & g[1] | 
					p[2] & p[1] & g[0] | 
					p[2] & p[1] & p[0] & cin;
	assign c[3] = 	g[3] | 
					p[3] & g[2] | 
					p[3] & p[2] & g[1] | 
					p[3] & p[2] & p[1] & g[0] | 
					p[3] & p[2] & p[1] & p[0] & cin;
	
	assign cout = c[3];
	
	/*	Sum unit (SU)	*/
	assign S[0] = p[0] ^ cin;
	assign S[1] = p[1] ^ c[0];
	assign S[2] = p[2] ^ c[1];
	assign S[3] = p[3] ^ c[2];
	
endmodule

module test;
	reg [3:0] A, B;
	reg cin;
	
	wire [3:0] S;
	wire cout;
	
	initial begin
	
	A = 0; B = 0; cin = 0;
	
	#100
	
	A = 8'h02; B = 8'h03; cin = 1'b0;
	#10 A = 8'h00; B = 8'hFF; cin = 1'b1;
	#10 A = 8'h55; B = 8'hAA; cin = 1'b0;
	#10 A = 8'h55; B = 8'hAA; cin = 1'b1;
	#10 A = 8'hFF; B = 8'hFF; cin = 1'b1;
	end
	
	initial begin
	$monitor("time = ", $time, "A = %b B = %b cin = %b : sum = %b cout = %b", A, B, cin, S, cout);
	end
endmodule
	
module 8bitCPA
(
	input [7:0] A, B;
	input cin;
	output [7:0] S;
	output cout, cin_signbit, cout_signbit;
);
	wire [7:0] c;
	
	4bitCLAadder cla1(S[3:0], c[3], A[3:0], B[3:0], cin);
	4bitCLAadder cla2(S[7:4], cout, A[7:4], B[7:4], c[3]);
endmodule
	
module test;
	reg [7:0] A, B;
	reg cin;
	
	wire [7:0] S;
	wire cout;
	
	initial begin
	
	A = 0; B = 0; cin = 0;
	
	#100
	
	A = 8'h02; B = 8'h03; cin = 1'b0;
	#10 A = 8'h00; B = 8'hFF; cin = 1'b1;
	#10 A = 8'h55; B = 8'hAA; cin = 1'b0;
	#10 A = 8'h55; B = 8'hAA; cin = 1'b1;
	#10 A = 8'hFF; B = 8'hFF; cin = 1'b1;
	end
	
	initial begin
	$monitor("time = ", $time, "A = %b B = %b cin = %b : sum = %b cout = %b", A, B, cin, S, cout);
	end
endmodule
	
	
	
	
	
	
	
	
	
	
	