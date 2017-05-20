//	D flip-flop HDL Model (Behavioral)
module dff
(
	input clock, _reset, _preset, d, e,
	output reg q,
	output nq
);

assign nq = ~q;

always@(posedge clock, _reset, _preset) /*	Note the missing synchronous inputs
											d and e here
										*/
begin
	if(!_reset)
		q <= 0;
	else if(!_preset)
		q <= 1;
	else if(e)
		q <= d; /*	Note also the missing else here
					(creates a D flip-flop)
				*/
end

endmodule