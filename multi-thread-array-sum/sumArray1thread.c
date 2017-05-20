#include <stdio.h>
#include <time.h>

#define SIZE 100000000  //100 M
#define NUMBER_OF_TIMES 100

float a[SIZE];



int main (void)
{
	int i, j;
	double sum;

	for (i=0; i<SIZE; i++) //initialize array
		a[i] = 1;

	printf("1T: PID 0 started: time = %f\n", (double) time(NULL));

	sum = 0;
	for(j = 0; j <NUMBER_OF_TIMES; j++)
		for (i=0; i<SIZE; i++)
			sum=sum + a[i];

	printf("1T: PID 0 ended: time = %f\n", (double) time(NULL));

	printf("1T: Final sum = %e\n", sum);

	return 0;
}
