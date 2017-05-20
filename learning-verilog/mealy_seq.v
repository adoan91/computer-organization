//	A Mealy sequence recognizer that detects the overlapping
//	sequence "101"
//	Using binary encoded state labels
module mealy_seq
(
	input clock, reset, x,
	output reg z
);

parameter	A = 2'b00,
			B = 2'b01,
			C = 2'b10;
			
reg [1:0] current_state, next_state;

//	Section 1: A combined next state generator (NSG) and output generator (OG)
//	unknown states are ignored
always@(*)
begin
	casex(current_state)
	A:	if (x == 1) begin
			next_state = B;
			z = 0;
		end
		else begin
			next_state = A;
			z = 0;
		end
	B:	if (x == 1) begin
			next_state = B;
			z = 0;
		end
		else begin
			next_state = C;
			z = 0;
		end
	C:	if (x == 1) begin
			next_state = B;
			z = 1;
		end
		else begin
			next_state = A;
			z = 0;
		end
	default:	begin
			next_state = 2'bxx;
			z = 1'bx;
		end
	endcase
end

//	Section 2: flip-flops
always@(posedge clock, posedge reset)
begin
	if (reset == 1)
		current_state <= A;
	else
		current_state <= next_state;
end
endmodule

//	Simulation Test-Bench
'include "mealy_seq.v"
module tester();
reg clock, reset, x;
wire z;
mealy_seq u1(clock, reset, x, z);
initial begin
$monitor("%4d: z = %b", $time, z);
clock = 0;
reset = 1; //	reset the flip-flops
x = 0;
#10 reset = 0; //	end reset
end
always
begin
#5 clock = ~clock; //	generates a clock signal with period 10
end
initial begin //	one input per clock cycle
#10 x = 1; $display("%4d: x = %b", $time, x);
#10 x = 1; $display("%4d: x = %b", $time, x);
#10 x = 1; $display("%4d: x = %b", $time, x);
#10 x = 0; $display("%4d: x = %b", $time, x);
#10 x = 1; $display("%4d: x = %b", $time, x);
#10 x = 0; $display("%4d: x = %b", $time, x);
#10 x = 1; $display("%4d: x = %b", $time, x);
#10 x = 1; $display("%4d: x = %b", $time, x);
#10 x = 0; $display("%4d: x = %b", $time, x);
#10 x = 0; $display("%4d: x = %b", $time, x);
#10 $finish;
end
endmodule