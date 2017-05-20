//	D Latch HDL Model (Behavioral)
module d_latch
(
	input clock, _reset, _preset, d,
	output reg q,
	output nq
);

assign nq = ~q;

always@(clock or !_reset or !_preset or d) //	Designed like a combinational circuit.
begin
	if(!_reset)
		q <= 0;
	else if(!_preset)
		q <= 1;
	else if(clock)
		q <= d; /*	Except, note the missing else here
					(creates a D-latch)
				*/
end
endmodule
//	"<=" called non-blocking or concurrent assignment