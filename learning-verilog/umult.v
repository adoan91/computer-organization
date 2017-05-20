module interface_unit(
	input clock, _reset, start_asyn, done,
	output reg start, done_moore
);
//	synchronization flip-flop
always@(posedge clock or negedge _reset or posedge done)
begin
	if(_reset == 0 || done == 1)
		start <= 1'b0;
	else
		start <= start_asyn;
end
//	Convert a Mealy output to a Moore output
always@(posedge clock or negedge _reset or posedge start_asyn)
begin
	if(_reset == 0 || start_asyn == 1)
		done_moore = 1'b0;
	else
		if(done == 1)
			done_moore <= done;
end
endmodule
//	Unsigned Multiplier
//A Mealy controller FSM
module umult(
	input clock, _reset, start,
	input [7:0] a_value, b_value,
	output [15:0] result,
	output reg done
);
reg [8:0] p;
reg [7:0] a, b;
reg [3:0] cntr; //mod-16 counter
reg co;
reg [7:0] sum;
reg [1:0] current_state, next_state;
assign result = {p[7:0], b};
//	The states
parameter	Idle = 	2'b00,
			Check = 2'b01,
			Add = 	2'b10;
/*	Output Generator (OG)
The OG module defines the data path and also implicitly defines
the data path control signals using a behavior description*/
always@(posedge clock or negedge _reset)
begin
	if(!_reset)
		begin
			p <= 0;
			cntr <= 0;
		end
	else
		case(current_state)
			Idle: 	if(start == 1)
						begin // initialize
							a <= a_value;
							b <= b_value;
							p <= 0;
							cntr <= 0;
						end
			Check:	begin
						if(cntr < 8)
							if(b[0] == 1)
								p <= {co, sum}; //or p <= p[7:0] + a; //without delay
						else
							begin
								{p, b} <= {p, b} >> 1;
								cntr <= cntr + 1;
							end
					end
			Add:	begin
						{p, b} <= {p, b} >> 1;
						cntr <= cntr + 1;
					end
		endcase
end
//	Next State Generator (NSG)
always@(current_state or cntr or start or b[0])
begin
	case(current_state)
		Idle:	begin
					done = 0;
					if(start == 1)
						next_state = Check;
					else
						next_state = Idle;
				end
		Check:	if(cntr < 8)
					begin
						done = 0;
						if(b[0] == 0)
							next_state = Check;
						else
							next_state = Add;
					end
				else
					begin
						done = 1;
						next_state = Idle;
					end
		Add:	begin
					done = 0;
					next_state = Idle;
				end
	endcase
end
//	The flip-flops
always@(posedge clock or negedge _reset) //state transitions
begin
	if (!_reset)
		current_state <= Idle;
	else
		current_state <= next_state;
end

//adder with delay
always@(p or a)
begin
	//assume 10ns delay for the adder
	#10 {co, sum} = p[7:0] + a;
end
endmodule

module tester();
reg clock, _reset, start_asyn;
reg [7:0] a_value, b_value;
wire [15:0] result;
wire done, done_moore, start;

interface_unit u1(clock, _reset, start_asyn, done, start, done_moore);
umult u2(clock, _reset, start, a_value, b_value, result, done);

initial begin
	clock = 1;
	#10 forever #10 clock = ~clock; //20ns clock period
end

initial begin
	_reset = 0;
	start_asyn = 0;
	#15 _reset = 1;
	#10 start_asyn = 1; a_value = 8'h03; b_value = 8'h7F;
	#40 start_asyn = 0;
	
	#400 start_asyn = 1; a_value = 8'h7F; b_value = 8'h03;
	#40 start_asyn = 0;
	
	#1000 $finish;
end

initial
	$monitor($stime,, _reset,, start_asyn,, clock,,, result,, done_moore);

endmodule