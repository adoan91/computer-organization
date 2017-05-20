// 4-1 mux using case
module mux4to1_case 

(
	input [1:0] sel,	// 2-bit control signal
	input A, B, C, D,
	output reg Y			// target of assignment
);
	always @(sel or A or B or C or D)
	begin
		case(sel)
			2'b00	: Y = A;
			2'b01	: Y = B;
			2'b10	: Y = C;
			2'b11	: Y = D;
			
		endcase
	end
endmodule

module tester();
reg [1:0] sel;
reg A, B, C, D;
reg [4:0] k;
wire Y;

mux4to1_case  m1(sel, A, B, C, D, Y);

initial begin //start the tester
$display("Time sel A B C D Y"); //header for the output
$monitor ("%4d             %b",  $time, Y);

for(k = 0; k <= 15; k = k+1) begin

	#1 A = k[3]; B = k[2]; C = k[1]; D = k[0]; sel[0] = k[0]; sel[1] = k[1]; $display("%4d %b  %b %b %b %b", $time, sel, A, B, C, D);
	

end
#10 $finish; //stops simulation
end
endmodule