/*compile as "gcc thread.c -pthread" */ 
#include <pthread.h>
#include <stdio.h>
#include <time.h>

#define SIZE 100000000  //100 M
//#define SIZE 10000
#define NUMBER_OF_TIMES 100

float a[SIZE];

typedef struct {
		int start;
		int end;
		double sum;
		int pid;
	} range;

void *thread_function(void *arg)  //define a function that will be executed from
                                  //within a thread
{
	range *incoming = (range *) arg;
	int i, j;
	double sum;
	int start, end, pid;

	start = incoming->start;
	end = incoming->end;
	pid = incoming->pid;

//	printf ("Array entries (start, end)  = (%d, %d)\n", start,end);

	if(pid != 0) 
	{
		printf("4T: PID %d started: time = %f\n", pid, (double) time(NULL));
	}

	sum = 0;
	for(j = 0; j <NUMBER_OF_TIMES; j++)
		for (i=start; i<end; i++)
			sum=sum + a[i];

//	printf("Pid = %d:  sum = %f\n", pid, sum);
	incoming->sum = sum;	//save the result from the PE

	if(pid != 0)
	{
		printf("4T: PID %d ended: time = %f\n", pid, (double) time(NULL));
	}
	return NULL;
}

int main (void)
{
	pthread_t threadID;
	void *exit_status;
	range one;
	range two;
    range three;
    range four;
	int i; 
	double sum;


	for (i=0; i<SIZE; i++) //initialize array
		a[i] = 1;

	printf("4T: PID 0 started: time = %f\n", (double) time(NULL));

	//create a thread that calls thread_function, and pass the indeces 
    //for the 1st fourth of the array
   	two.start = 0;
	two.end = SIZE/4-1;
	two.pid = 1; //PE is 1
	pthread_create(&threadID, NULL, thread_function, &two); //create a thread and run thread_function
    
    //create a thread that calls thread_function, and pass the indeces 
    //for the 2nd fourth of the array
   	three.start = SIZE/4-1;
	three.end = SIZE/2-1;
	three.pid = 2; //PE is 1
	pthread_create(&threadID, NULL, thread_function, &three); //create a thread and run thread_function

	//create a thread that calls thread_function, and pass the indeces 
    //for the 2nd fourth of the array
   	four.start = SIZE/2-1;
	four.end = 3*SIZE/4-1;
	four.pid = 3; //PE is 1
	pthread_create(&threadID, NULL, thread_function, &four); //create a thread and run thread_function
	
	//main will become the 4th thread and will call thread_function
    //Pass the indeces to the last fourth of the array 
    one.start = 3*SIZE/4-1;	//main computes the sum for the second half of the array elements
	one.end = SIZE;
	one.pid = 0;  
	thread_function(&one); 

	pthread_join(threadID, &exit_status); //wait for the 1st thread to end
	sum = one.sum + two.sum + three.sum + four.sum; //PE 2 combines the partial sums

	printf("4T: PID 0 ended: time = %f\n", (double) time(NULL));

	printf("4T: Final sum = %e\n", sum);

	return 0;
}
