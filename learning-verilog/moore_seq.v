//	A Moore sequence recognizer that detects the overlapping
//	sequence "101".
//	Using binary encoded state labels
module moore_seq
(
	input clock, reset, x,
	output reg z
);

//	assign binary encoded codes to the states A through D
parameter	A = 2'b00,
			B = 2'b01,
			C = 2'b10,
			D = 2'b11;

reg [1:0] current_state, next_state;

//	Section 1: Next state generator (NSG)
always@(*)
begin
	casex	(current_state) //	ignore unknown and high
							//	impedance (Z)' inputs
	A:	if (x == 1)
			next_state = B;
		else
			next_state = A;
	B:	if (x == 1)
			next_state = B;
		else
			next_state = C;
	C:	if (x == 1)
			next_state = D;
		else
			next_state = A;
	D:	if (x == 1)
			next_state = B;
		else
			next_state = C;
	endcase
end

//	Section 2: Output generator (OG)
always@(*)
begin
	if (current_state == D)
		z = 1;
	else
		z = 0;
end

//	Section 3: The flip-flops
always@(posedge clock, posedge reset)
begin
	if (reset == 1)
		current_state <= A;
	else
		current_state <= next_state;
end
endmodule

//	Simulation Test-Bench
'include "moore_seq.v"
module tester();
reg clock, reset, x;
wire z;
moore_seq u1(clock, reset, x, z);
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