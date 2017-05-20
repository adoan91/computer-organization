//	Converting done-Mealy to done-Moore
/*	Asynchronously de-asserts done-Moore when _reset or
	start_asyn asserted
*/
/*	Synchronously asserts done-Moore when done-Mealy
	asserted
*/
always@(posedge clock or negedge _reset or posedge start_asyn)
begin
	if(_reset == 0 || start_asyn == 1)
		done-moore = 1'b0;
	else
		done-moore <= done; //	done = 1 kept for one clock cycle
end
endmodule