module cordic(
	input clock, reset, enable,
	input [7:0] xin, yin,
	input [7:0] degrees,
	output [7:0] cordxp, cordyp
);

wire [7:0] b0, x0, y0, b0o, x0o, y0o, sx0o, sy0o;
wire [7:0] b1, x1, y1, b1o, x1o, y1o, sx1o, sy1o;
wire [7:0] b2, x2, y2, b2o, x2o, y2o, sx2o, sy2o;
wire [7:0] b3, x3, y3, b3o, x3o, y3o, sx3o, sy3o;
wire [7:0] b4, x4, y4, b4o, x4o, y4o, sx4o, sy4o;
wire [7:0] b5, x5, y5, b5o, x5o, y5o, sx5o, sy5o;
wire [7:0] b6, x6, y6, b6o, x6o, y6o, sx6o, sy6o;
wire [7:0] b7, x7, y7, b7o, x7o, y7o, sx7o, sy7o;

assign b0 = degrees;	//target rotation angle in degrees
assign x0 = xin;		//initial coordinate value X
assign y0 = yin;		//initial coordinate value Y
assign cordxp = x7o;	//final computed coordinate value X7
assign cordyp = y7o;	//final computed coordinate value Y7

//Stage 1: atan(2^0) = 45 degrees
stage s1(
	.b(b0), .x(x0), .y(y0), .atan(8'd45), .sx(x0), .sy(y0), 
	.bp(b1), .xp(x1), .yp(y1)
);
pregregister1(
	.enable(enable),
	.clock(clock),
	.reset(reset),
	.bin(b1), .xin(x1), .yin(y1),
	.sxin({x1[7], x1[7:1]}), .syin({y1[7], y1[7:1]}),
	.bout(b1o), .xout(x1o), .yout(y1o), .sxout(sx1o), .syout(sy1o)
);

//Stage 2: atan(2^-1) = 27 degrees
stage s2(
	.b(b1o), .x(x1o), .y(y1o), .atan(8'd27), .sx(sx1o), .sy(sy1o), 
	.bp(b2), .xp(x2), .yp(y2)
);
pregregister2(
	.enable(enable),
	.clock(clock),
	.reset(reset),
	.bin(b2), .xin(x2), .yin(y2),
	.sxin({{2{x2[7]}}, x2[7:2]}), .syin({{2{y2[7]}}, y2[7:2]}),
	.bout(b2o), .xout(x2o), .yout(y2o), .sxout(sx2o), .syout(sy2o)
);

//Stage 3: atan(2^-2) = 14 degrees
stage s3(
	.b(b2o), .x(x2o), .y(y2o), .atan(8'd14), .sx(sx2o), .sy(sy2o), 
	.bp(b3), .xp(x3), .yp(y3)
);
pregregister3(
	.enable(enable),
	.clock(clock),
	.reset(reset),
	.bin(b3), .xin(x3), .yin(y3),
	.sxin({{3{x3[7]}}, x3[7:3]}), .syin({{3{y3[7]}}, y3[7:3]}),
	.bout(b3o), .xout(x3o), .yout(y3o), .sxout(sx3o), .syout(sy3o)
);

//Stage 4: atan(2^-3) = 7 degrees
stage s4(
	.b(b3o), .x(x3o), .y(y3o), .atan(8'd7), .sx(sx3o), .sy(sy3o), 
	.bp(b4), .xp(x4), .yp(y4)
);
pregregister4(
	.enable(enable),
	.clock(clock),
	.reset(reset),
	.bin(b4), .xin(x4), .yin(y4),
	.sxin({{4{x4[7]}}, x4[7:4]}), .syin({{4{y4[7]}}, y4[7:4]}),
	.bout(b4o), .xout(x4o), .yout(y4o), .sxout(sx4o), .syout(sy4o)
);

//Stage 5: atan(2^-4) = 4 degrees
stage s5(
	.b(b4o), .x(x4o), .y(y4o), .atan(8'd4), .sx(sx4o), .sy(sy4o), 
	.bp(b5), .xp(x5), .yp(y5)
);
pregregister5(
	.enable(enable),
	.clock(clock),
	.reset(reset),
	.bin(b5), .xin(x5), .yin(y5),
	.sxin({{5{x5[7]}}, x5[7:5]}), 
	.syin({{5{y5[7]}}, y5[7:5]}),
	.bout(b5o), .xout(x5o), .yout(y5o), .sxout(sx5o), .syout(sy5o)
);

//Stage 6: atan(2^-5) = 2 degrees
stage s6(
	.b(b5o), .x(x5o), .y(y5o), .atan(8'd2), .sx(sx5o), .sy(sy5o), 
	.bp(b6), .xp(x6), .yp(y6)
);
pregregister6(
	.enable(enable),
	.clock(clock),
	.reset(reset),
	.bin(b6), .xin(x6), .yin(y6),
	.sxin({{6{x6[7]}}, x6[7:6]}), 
	.syin({{6{y6[7]}}, y6[7:6]}),
	.bout(b6o), .xout(x6o), .yout(y6o), .sxout(sx6o), .syout(sy6o)
);

//Stage 7: atan(2^-6) = 1 degrees
stage s7(
	.b(b6o), .x(x6o), .y(y6o), .atan(8'd1), .sx(sx6o), .sy(sy6o), 
	.bp(b7), .xp(x7), .yp(y7)
);
pregregister7(
	.enable(enable),
	.clock(clock),
	.reset(reset),
	.bin(b7), .xin(x7), .yin(y7),
	.sxin({7{x7[7]}}), 
	.syin({7{y7[7]}}),
	.bout(b7o), .xout(x7o), .yout(y7o), .sxout(sx7o), .syout(sy7o)
);

endmodule

module stage(
	input [7:0] b,
	input [7:0] x,
	input [7:0] y,
	input [7:0] atan,
	input [7:0] sx, sy,
	output reg [7:0] bp, xp, yp
);

//b is the 8-bit rotation angle between -90 and +90 degrees
//8-bit x-y coordinate point in a 2D space

wire mode = b[7]; //sign of rotation angle b

always@
begin
	if (mode == 0)
		bp = b - atan; // b' = b - atan if b >= 0
	else
		bp = b + atan; // b' = b + atan if b < 0
end

always@
begin
	if (mode == 0)
		xp = x - sy; //x' = x - y * (2^-i) if b >= 0 for the ith iteration
	else
		xp = x + sy; //x' = x + y * (2^-i) if b < 0
end

always@
begin
	if (mode == 0)
		yp = y + sx; //y' = y + x * (2^-i) if b >= 0
	else
		yp = y - sx; //y' = y - x * (2^-i) if b < 0
end
endmodule

module preg(
	input enable,
	input clock, reset,
	input [7:0] bin, xin, yin,
	input [7:0] sxin, syin,
	output reg [7:0] bout, xout, yout, sxout, syout
);

always@(posedge clock or posedge reset)
begin
	if(reset == 1)
		begin
			bout <= 0;
			xout <= 0;
			yout <= 0;
			sxout <= 0;
			syout <= 0;
		end
	else if(enable == 1)
		begin
			bout <= bin;
			xout <= xin;
			yout <= yin;
			sxout <= sxin;
			syout <= syin;
		end
end
endmodule

module tester();
reg clock, reset, enable;
reg [7:0] degrees, x, y;
wire [7:0] xp, yp;

cordic u1(clock, reset, enable, x, y, degrees, xp, yp);

initial begin
	clock = 1;
	reset = 1;
	enable = 0;
	#5 reset = 0;
end

always begin
	#5 clock = ~clock;
end

initial begin
	enable = 1;
	degrees = 55; //rotate by 55 degrees
	x = 10; y = 10; 	//point a
	#10 x = 10; y = 20;	//point b
	#10 x = 15; y = 30;	//point c
	#10 x = 20; y = 20;	//point d
	#10 x = 20; y = 10;	//point d
	#80
	enable = 0;
	#20 $finish;
end
endmodule