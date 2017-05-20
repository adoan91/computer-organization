module smult(
	input clock, _reset, start,
	input [7:0] a_value, b_value,
	output [15:0] result,
	output done
);
wire flag, x;
wire [13:0] control;

controller u2(clock, _reset, start, flag, x, control, done);
data path u3(clock, _reset, a_value, b_value, control, flag, x, result);

endmodule

module controller (
	input clock, _reset, start, flag, x,
	output reg [6:0] control,
	output reg done
);

reg [2:0] mpc; //control memory
(* ramstyle = "M512" *) reg [13:0] cm [0:7];

//reg [0:7] [13:0] cm;
reg [2:0] ccode; //branch type
reg [2:0] jump_address; //branch address
reg load;

//Initialize the CM
initial begin
	cm[0] = 14'h1000; //wait for start = 1
	cm[1] = 14'h07B0; //initialize
	cm[2] = 14'h1806; //if flag == 1 then goto 6
	cm[3] = 14'h2005; //if x == 0 then goto 5
	cm[4] = 14'h0080; //p <- sum_diff
	cm[5] = 14'h0B42; //p//b <= p//b >>> 1, cntr++, goto 2
	cm[6] = 14'h0808; //done = 1, goto 0
end

//MUX
always@(*)
begin
	case(ccode)
		0: 	load = 0; //next instruction
		1: 	load = 1; //unconditional jump
		2: 	if (start == 0) //conditional jump if start =0
				load = 1;
			else
				load = 0;
		3: 	if (flag == 1) //conditional jump if done
				load = 1;
			else 
				load = 0;
		4: 	if (x == 0) // conditional jump if b[1][0] = 00 or 11
				load = 1;
			else
				load = 0;
		default: 	load = 1;
	endcase
end

//MPC
always@(posedge clock or negedge _reset)
begin
	if (_reset == 0)
		mpc <= 3'b000;
	else
		if (load == 0)
			mpc <= mpc + 1;
		else
			mpc <= jump_address;
end

//CM
always@(*)
begin
	ccode = cm[mpc][13:11];
	control = cm[mpc][10:4];
	done = cm[mpc][3];
	jump_address = cm[mpc][2:0];
end
endmodule

module data path (
	input clock, _reset,
	input [7:0] a_value, b_value,
	input [6:0] control,
	output reg flag,
	output x,
	output [15:0] result
);

reg [8:0] a, b;
reg [8:0] p;
reg [3:0] cntr; //mod-16 counter
reg [8:0] sum_diff;

wire af = control[0];
wire [1:0] 	CF = control [6:5],
			PF = control [4:3],
			BF = control [2:1];
assign result = {p[7:0], b[8:1]};
assign x = b[1] ^ b[0];

always@(posedge clock or negedge _reset) //registers and cntr
begin
	if (_reset == 0)
		begin
			a <= 0;
			b <= 0;
			p <= 0;
			cntr <= 0;
		end
	else
		begin
			if (af == 1)
				a <= {a_value[7], a_value}; //a[8] is set to the sign bit (a[7])
			case(BF)
				2'b01: 	b <= {b_value, 1'b0};
				2'b10: 	b <= {p[0], b[8:1]}; //shift right with left input
				2'b11: 	b <= 9'h000; //clear
				default: 	b <= b;
			endcase
			case(PF)
				2'b01: 	p <= sum_diff; //load
				2'b10: 	p <= {p[8], p[8:1]}; //arithmetic right shift
				2'b11: 	p <= 9'h000; //clear
				default: 	p <= p;
			endcase
			case(CF)
				2'b01: 	cntr <= cntr + 1; //increment
				2'b10: 	cntr <= cntr; //not used, retain
				2'b11: 	cntr <= 3'b000; //clear
				default: 	cntr <= cntr;
			endcase
		end
end

always@(*)
begin
	if (b[1] == 1'b0)
		sum_diff = p + a;
	else
		sum_diff = p - a;
end

always@(*) //condition flag
begin
	if (cntr < 8)
		flag = 1'b0;
	else
		flag = 1'b1;
end
endmodule

module interface_unit (
	input clock, _reset, start_asyn, done,
	output reg start, done_moore
);
//synchronization flip-flop
always@(posedge clock or negedge _reset or posedge done)
begin
	if (_reset == 0 || done == 1)
		start <= 1'b0;
	else
		start <= start_asyn;
end

//Moore output
always@(posedge clock or negedge _reset or posedge start_asyn)
begin
	if (_reset == 0 || start_asyn == 1)
		done_moore = 1'b0;
	else
		if (done == 1)
			done_moore <= done;
end
endmodule

module tester();
reg clock, _reset, start_asyn;
reg [7:0] a_value, b_value;
wire [15:0] result;
wire done, done_moore, start, flag, x;
wire [6:0] control;

interface_unit u1(clock, _reset, start_asyn, done, start, done_moore);
smult u2(clock, _reset, start, a_value, b_value, result, done);

initial begin
	clock = 1;
	_reset = 0;
end

always #10 clock = ~clock; //20ns clock period

initial begin
	start_asyn = 0;
	#15 _reset = 1;
	#10 start_asyn =1; a_value = 8'hF8; b_value = 8'hFB;
	#40 start_asyn = 0;

	#1000 $finish;
end

initial begin
	$monitor($stime, _reset, start_asyn, clock, result, done_moore);
end
endmodule