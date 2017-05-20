module dff

(
	input clock, _reset, _preset, d, e,
	output reg q,
	output nq
);

assign nq = ~q; //	nq indicates not q
always@(posedge clock, negedge _reset, negedge _preset)
begin
	if(!_reset)
		q <= 0;
	else if(!_preset)
		q <= 1;
	else if(e)
		q <= d;
end
endmodule

'include "dff.v"
module tester();
reg clock, _reset, _preset, d, e;
wire q, nq;
dff dff1(clock, _reset, _preset, d, e, q, nq);
initial begin
$monitor("%4d clock = %b _reset = %b _preset = %b e = %b d = %b q = %b nq = %b\n", 
										$time, clock, _reset, _preset, e, d, q, nq);
clock = 0; _reset = 1; _preset = 1; e = 0;
#1 _reset = 0;
#1 _reset = 1;
#1 e = 1; d = 1;
#1 clock = 1;
#1 d = 0;
#10 $finish;
end

endmodule