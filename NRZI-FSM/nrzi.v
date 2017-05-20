module nrzi
(
	input clock, reset, 
	input x,
	output z
);
reg	z;
parameter 	A = 0,
			B = 1;
reg state = 0, next_state = 0;
// Section 1: A combined next state generator (NSG) and
// output generator (OG)
// unknown states are ignored
always @(posedge clock)
begin
	casex (state) 
		A:	begin 
				if (x == 1)
					begin
						next_state = A;
					end
				if (x == 0)
					begin
						next_state = B;
						z = ~z;
					end
			end
		B:	begin 
				if (x == 1)
					begin 
						next_state = B;
					end
				if (x == 0)
					begin
					next_state = A;
					z = ~z;
					end
			end
	endcase
end

// Section 2: flip-flops
// Asynchronous reset
always @(posedge clock, posedge reset)
begin
	if (reset == 1) 
		begin
			state <= A;
			z <= x;
			next_state <= state;
		end
	else
		begin
			state <= next_state;
		end
end
endmodule

module test();
reg clock, reset;
reg x;
wire z;
integer i;
nrzi nrzi(clock, reset, x, z);
reg [15:0] a = 16'hF163;
reg [15:0] b = 16'hCF0C;
reg [15:0] c = 16'h8C00;
initial begin
	$monitor("%4d:        z = %b", $time, z);
end
always
begin
	#5 clock = ~clock; //	generates a clock signal with period 10
end
initial begin //	one input per clock cycle
	begin
		clock = 0;
		reset = 1; //	reset the flip-flops
		$display("%4d: reset flip flop", $time);
		$display("%4d: Test Vector X = 16'hF163", $time);
		x = a[0];
		#10 reset = 0; //	end reset
		#10 x = a[1]; $display("%4d: x = %b", $time, x);
		#10 x = a[2]; $display("%4d: x = %b", $time, x);
		#10 x = a[3]; $display("%4d: x = %b", $time, x);
		#10 x = a[4]; $display("%4d: x = %b", $time, x);
		#10 x = a[5]; $display("%4d: x = %b", $time, x);
		#10 x = a[6]; $display("%4d: x = %b", $time, x);
		#10 x = a[7]; $display("%4d: x = %b", $time, x);
		#10 x = a[8]; $display("%4d: x = %b", $time, x);
		#10 x = a[9]; $display("%4d: x = %b", $time, x);
		#10 x = a[10]; $display("%4d: x = %b", $time, x);
		#10 x = a[11]; $display("%4d: x = %b", $time, x);
		#10 x = a[12]; $display("%4d: x = %b", $time, x);
		#10 x = a[13]; $display("%4d: x = %b", $time, x);
		#10 x = a[14]; $display("%4d: x = %b", $time, x);
		#10 x = a[15]; $display("%4d: x = %b", $time, x);
	end
	begin
		#10 clock = 0;
		$display("%4d: reset flip flop ignore lines below until Test Vector", $time);
		reset = 1; //	reset the flip-flops
		x = b[0];
		reset = 0; //	end reset
		#10;
		$display("%4d: Test Vector X = 16'hCF0C", $time);
		#10 x = b[1]; $display("%4d: x = %b", $time, x);
		#10 x = b[2]; $display("%4d: x = %b", $time, x);
		#10 x = b[3]; $display("%4d: x = %b", $time, x);
		#10 x = b[4]; $display("%4d: x = %b", $time, x);
		#10 x = b[5]; $display("%4d: x = %b", $time, x);
		#10 x = b[6]; $display("%4d: x = %b", $time, x);
		#10 x = b[7]; $display("%4d: x = %b", $time, x);
		#10 x = b[8]; $display("%4d: x = %b", $time, x);
		#10 x = b[9]; $display("%4d: x = %b", $time, x);
		#10 x = b[10]; $display("%4d: x = %b", $time, x);
		#10 x = b[11]; $display("%4d: x = %b", $time, x);
		#10 x = b[12]; $display("%4d: x = %b", $time, x);
		#10 x = b[13]; $display("%4d: x = %b", $time, x);
		#10 x = b[14]; $display("%4d: x = %b", $time, x);
		#10 x = b[15]; $display("%4d: x = %b", $time, x);
	end
	begin
		clock = 0;
		$display("%4d: reset flip flop", $time);
		reset = 1; //	reset the flip-flops
		x = c[0];
		reset = 0; //	end reset
		$display("%4d: Test Vector X = 16'h8C00", $time);
		#10 x = c[1]; $display("%4d: x = %b", $time, x);
		#10 x = c[2]; $display("%4d: x = %b", $time, x);
		#10 x = c[3]; $display("%4d: x = %b", $time, x);
		#10 x = c[4]; $display("%4d: x = %b", $time, x);
		#10 x = c[5]; $display("%4d: x = %b", $time, x);
		#10 x = c[6]; $display("%4d: x = %b", $time, x);
		#10 x = c[7]; $display("%4d: x = %b", $time, x);
		#10 x = c[8]; $display("%4d: x = %b", $time, x);
		#10 x = c[9]; $display("%4d: x = %b", $time, x);
		#10 x = c[10]; $display("%4d: x = %b", $time, x);
		#10 x = c[11]; $display("%4d: x = %b", $time, x);
		#10 x = c[12]; $display("%4d: x = %b", $time, x);
		#10 x = c[13]; $display("%4d: x = %b", $time, x);
		#10 x = c[14]; $display("%4d: x = %b", $time, x);
		#10 x = c[15]; $display("%4d: x = %b", $time, x);
	end
	#10 $finish;
end
endmodule