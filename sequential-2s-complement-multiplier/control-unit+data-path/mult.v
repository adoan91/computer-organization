module datapath_controlunit ( 
	input clk, reset, start,
	input signed [6:0] a_value, b_value,
	output signed [13:0] result
);

reg signed [7:0] a, b;
reg signed [7:0] p;
reg [3:0] cntr;
reg signed [7:0] sum_diff;
reg [2:0] controlflag;
reg e, m, done;
reg [2:0] next;

assign result = {p[6:0], b[7:1]};

//counter
always@(posedge clk, posedge reset)
begin
	if(reset)
		begin
		cntr <= 0;
		end
	else
		begin
		if(e)
			begin
			cntr <= cntr + 1;
			end
		end
end

always@(posedge clk, posedge reset)
begin
	if(reset)
		begin
		done <= 0;
		m = 0;
		e = 0;
		controlflag <= 0;
		end
	else
		begin
		controlflag <= next;
		end
end

//NSG and OG combined
always@(controlflag, posedge start)
begin
	case(controlflag)
		0: 	begin 
				if(start == 0)
					begin 
					if(done == 1)
						begin
						$display("result = %b", result);
						end
					next <= 0; //go to 0
					end
				if(start == 1)
					begin
						begin
						next = 1;
						end
					end
			end
		1:	begin 
				p = 0;
				a = {a_value[6], a_value};
				b = {b_value, 1'b0};
				
				next = 2;
			end
		2:	begin 
				if(cntr < 7)
					begin
					e <= 0;
					next = 3;
					end
				else
					begin
					e <= 0;
					next = 6; //go to 6
					end
			end
		3:	begin 
				if(b[1] ^ b[0] == 0)
					begin
					next <= 5; //go to 5
					end
				else
					begin
					next <= 4;
					end
			end
		4:	begin 
				if(b[0] == 1)
					begin
					m <= 0;
					next <= 5;
					end
				else
					begin
					m <= 1;
					next <= 5;
					end
			end
		5:	begin 
				b <= {p[0], b[7:1]};
				p <= {p[7], p[7:1]};
				e <= 1; 
				next <= 2; //go to 2
			end
		6:	begin
				done <= 1;
				next <= 0; //go to 0
			end
		default:	begin
					end
	endcase
end

// adder/subtractor 
always@(m)
begin 
	if(m == 1)
		begin
		sum_diff = p - a;
		p = sum_diff;
		sum_diff = 0;
		end
	else if(m == 0)
		begin
		sum_diff = p + a;
		p = sum_diff;
		sum_diff = 0;
		end
end
endmodule

module tester();
reg clk, reset, start;
reg signed [6:0] a_value, b_value;
wire signed [13:0] result;

datapath_controlunit d1(clk, reset, start, a_value, b_value, result);

always
begin
	#5 clk = ~clk; //	generates a clk signal with period 10
end

initial begin
	a_value = 8'hF8; b_value = 8'hFB;
	$display("A register = -8 = %b, B register = -5 = %b", a_value, b_value);
	clk = 0; start = 1; reset = 1;
	#20 reset = 0; #20 start = 0;
	
	#400;
	a_value = 8'hFB; b_value = 8'hF8;
	$display("A register = -5 = %b, B register = -8 = %b", a_value, b_value);
	clk = 0; start = 1; reset = 1;
	#20 reset = 0; #20 start = 0;
	
	#400;
	a_value = 8'h5; b_value = 8'hFE;
	$display("A register = 5 = %b, B register = -2 = %b", a_value, b_value);
	clk = 0; start = 1; reset = 1;
	#20 reset = 0; #20 start = 0;
	
	#400;
	a_value = 8'hFF; b_value = 8'hFF;
	$display("A register = -1 = %b, B register = -1 = %b", a_value, b_value);
	clk = 0; start = 1; reset = 1;
	#20 reset = 0; #20 start = 0;
	
	#400;
	a_value = 8'h1; b_value = 8'h1;
	$display("A register = 1 = %b, B register = 1 = %b", a_value, b_value);
	clk = 0; start = 1; reset = 1;
	#20 reset = 0; #20 start = 0;
	
	#400;
	a_value = 8'h5; b_value = 8'hF5;
	$display("A register = 5 = %b, B register = -11 = %b", a_value, b_value);
	clk = 0; start = 1; reset = 1;
	#20 reset = 0; #20 start = 0;
	
	#1000 $finish;
end
endmodule