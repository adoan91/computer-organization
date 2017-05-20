object_transform(x[], y[], B, n, x'[], y'[])
	if B > |360| then
		B = B mod 360;
	endif
	if B > |180| then
		if B > 0 then
			B = B - 360;
		else
			B = B + 360;
	endif
	d = 1;
	if B > |90| then
		d = -1;
		if B > 0 then
			B = B - 180;
		else
			B = B + 180;
	endif
	//Rotate n vectors
	for i = 0 to n - 1
		x0 = d * x[i];
		y0 = d * y[i];
		(x7, x7) = vector_transform(x0, y0, B); //-90 degrees <= B <= 90 degrees
		x'[i] = 0.6048 * x7;	//apply the scaling factor A7
								//= 0.6048
		y'[i] = 0.6048 * y7;
	endfor
end

vector_transform(x0, x0, B0)	//use the Iterative Rotation Algorithm
	x = x0;
	y = y0;
	B = B0;
	if (B >= 0)
		d = 1;
	else
		d = -1;
	for (i = 0; i < 7; i++)
		x = x - d * (y >>> i);
		y = d * (x >>> i) + y;
		B = B - d * LUT[i]; //Look-up table <tn>Table 6.12, column 3
	endfor
	return(x, y);
end