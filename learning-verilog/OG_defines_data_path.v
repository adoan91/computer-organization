/*	OG defines
	data path
*/
module umult(
//	....
);

assign result = {p[7:0], b};
//	-------------------- The states --------------------

parameter	Start =		2'b00,
			Check =		2'b01,
			Shift_Inc =	2'b10;
			
//	-------------------- Output Generator (OG)
always@(posedge clock or _reset)
begin
	if(!_reset)
	begin
		p <= 0;
		cntr <= 0;
	end
	else
		case(current_state)
			Start:	if(start == 1)
						begin //	initialize
							a <= a_value;
							b <= b_value;
							p <= 0;
							cntr <= 0;
						end
			Check:	begin
						if(cntr < 8)
							if(b[0] == 1)
								p <= p[7:0] + a;
							else
								begin
									{p, b} <= {p, b} >> 1;
									cntr <= cntr + 1;
								end
					end
			Shift_Inc:	begin
							{p, b} <= {p, b} >> 1;
							cntr <= cntr + 1;
						end
		endcase
end