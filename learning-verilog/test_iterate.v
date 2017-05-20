# define ITERATIONS 15

Procedure ()
{
	float D, N, Q;
	float R;
	input D, N; //	e.g., D = 1.99 and N = 2.4
	for	j = 1 to ITERATIONS do
		R = 2 - D;
		D = D * R;
		N = N * R;
		print j, D, N, R
	end for
}