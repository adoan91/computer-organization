//	...
always@(*) //	NSG and OG
begin
case({q, x}) //	q is declared as 5-bit current state variable
6'h000000: {d, z} = 6'h000000; //	1st row of the table
//	...
default: {d, z} = 6'hx;
endcase
end