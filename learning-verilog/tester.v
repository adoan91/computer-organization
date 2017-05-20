'include "full_adder.v" //input FA's description from local folder
'timescale 1ns/100ps
module tester();
reg a, b, cin;

reg [3:0] k;
wire s, cout;

full_adder fa1(a, b, cin, s, cout); //instantiates FA

initial begin //start the test
$display("Time a b cin cout s"); //header for output
$monitor("%4d %b %b", $time, cout, s);

a = 0; b = 0; cin = 1; $display("%4d %b %b %b", $time, a, b, cin);
#10
a = 0; b = 1; cin = 1; $display("%4d %b %b %b", $time, a, b, cin);

/*
for (k = 0; k <= 7; k = k + 1) begin
	#1 a = k[2]; b = k[1]; cin = k[0]; $display("%4d %b %b %b", $time, a, b, cin);
end
*/

/*
a = 0; b = 0; cin = 0; $display("%4d %b %b %b", $time, a, b, cin);
//test 1
#1 //simulate
a = 1; b = 1; cin = 0; $display("%4d %b %b %b", $time, a, b, cin);
//test 2
#1 //simulate
a = 1; b = 1; cin = 1; $display("%4d %b %b %b", $time, a, b, cin);
//test 3
#1 //simulate
*/

#10 $finish; //stops simulation
end 
endmodule