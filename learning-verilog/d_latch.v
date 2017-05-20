module d_latch

(
	input clock, _reset, _preset, d,
	output reg q,
	output nq
);

assign nq = ~q;
always@(clock or !_reset or !_preset or d)
begin
	if (!_reset)
		q <= 0;
	else if(!_preset)
		q <= 1;
	else if(clock)
		q <= d;
end
endmodule

'include "d_latch.v"
module tester();
re clock, _reset, _preset, d;
wire q, nq;
d_latch dlatch1(clock, _reset, _preset, d, q, nq);
initial begin
$monitor("%4d clock = %b _reset = %b, _preset = %b d = %b q = %b nq = %b\n", 
			$time, clock, _reset, _preset, d, q, nq);
end
initial begin
clock = 0; _reset = 1; _preset = 1;
#1 _reset = 0;
#1 _reset = 1;
#1 d = 1;
#1 clock = 1;
#1 d = 0;
#10 $finish;
end
endmodule