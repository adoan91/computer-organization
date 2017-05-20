//	Synchronizing FF
//	Resets when _reset or done asserted
//	Otherwise, loads asynchronous input start_asyn.
always@(posedge clock or negedge _reset or posedge done)
begin
	if(_reset == 0 || done == 1)
		start <= 1'b0;
	else
		start <= start_asyn;
end