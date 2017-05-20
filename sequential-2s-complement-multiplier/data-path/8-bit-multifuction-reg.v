module data_path (
	input clock, _reset,
	input [6:0] a_value, b_value,
	output [15:0] result
);

reg [7:0] a, b;
reg [7:0] p;
reg [2:0] cntr; //mod-8 counter
reg [7:0] sum_diff;
reg e;
reg m;
reg done;

assign result = {p[7:0], b[7:1]};
//assign x = b[1] ^ b[0];

always@(posedge clock, posedge _reset)
begin
if(_reset)
	begin
		a <= {a_value[6], a_value}; //a[7] is set to the sign bit (a[6])
		b <= {b_value, 1'b0};
		p <= 0;
		e <= 0;
		cntr <= 3'b000;
		$display("Beginning:");
		#10 $display("a = %h, b = %h, p = %h, cntr = %h, done = %b", a, b, p, cntr, done);
	end
end

always@(posedge clock) //registers
begin
	if(b[1] == 0 && b[0] == 0)
		begin
			//b <= b;
			b <= {p[0], b[7:1]}; //shift right with left input
			p <= {p[7], p[7:1]}; //arithmetic right shift
			e = 0;
			if(e)
				begin
					cntr <= cntr + 1;
					if (cntr == 8)
						done <= 1; // finished
				end
			else
				cntr <= cntr;
			#10 $display("ARS");
			#50 $display("a = %h, b = %h, p = %h, cntr = %h, done = %b", a, b, p, cntr, done);
		end
	else if(b[1] == 0 && b[0] == 1)
		begin
			m = 0; // add
			if (m == 0)
				begin
					sum_diff <= p + a;
					#10 $display("P + A");
				end
			//sum_diff = p + a;
			p = sum_diff;
			b <= {p[0], b[7:1]}; //shift right with left input
			p <= {p[7], p[7:1]}; //arithmetic right shift
			e = 1;
			if(e)
				begin
					cntr <= cntr + 1;
					if (cntr == 8)
						done <= 1; // finished
				end
			else
				cntr <= cntr;
			#10 $display("a = %h, b = %h, p = %h, cntr = %h, done = %b", a, b, p, cntr, done);
		end
	else if(b[1] == 1 && b[0] == 0)
		begin
			m = 1; //subtract
			if (m == 1)
				begin
					sum_diff <= p - a;
					#10 $display("P - A");
				end
			//sum_diff = p - a;
			p = sum_diff;
			b <= {p[0], b[7:1]}; //shift right with left input
			p <= {p[7], p[7:1]}; //arithmetic right shift
			e = 1;
			if(e)
				begin
					cntr <= cntr + 1;
					if (cntr == 8)
						done <= 1; // finished
				end
			else
				cntr <= cntr;
			#50 $display("a = %h, b = %h, p = %h, cntr = %h, done = %b", a, b, p, cntr, done);
		end
	else if(b[1] == 1 && b[0] == 1)
		begin
			b <= {p[0], b[7:1]}; //shift right with left input
			p <= {p[7], p[7:1]}; //arithmetic right shift
			e = 0;
			if(e)
				begin
					cntr <= cntr + 1;
					if (cntr == 8)
						done <= 1; // finished
				end
			else
				cntr <= cntr;
			#10 $display("ARS");
			#50 $display("a = %h, b = %h, p = %h, cntr = %h, done = %b", a, b, p, cntr, done);
		end
end
endmodule

module tester();
reg clock, _reset;
reg [6:0] a_value, b_value;
wire [15:0] result;

data_path d1(clock, _reset, a_value, b_value, result);

initial begin
	$monitor("%4d: clock = %b",$time, clock);
end

initial begin
	a_value = 8'hF8; b_value = 8'hFB;
	$display("A register = -8 = %b, B register = -5 = %b",a_value, b_value);
	clock = 0; _reset = 1;
	#100 _reset = 0;
	#100 clock = 1;
	#100 clock = 0;
	#100 clock = 1;
	#100 clock = 0;
	#100 clock = 1;
	#100 clock = 0;
	#100 clock = 1;

	#100 clock = 0;
	_reset = 1; //clock = 1;
	$display("asynchronously reset");
	//#100 $display("%b", result);

	#1000 $finish;
end
endmodule