#include <stdio.h>
#include <time.h>

#define N 512
#define THREADS_PER_BLCOK 512

/* vectorAdd version 4 */

__global__ void vectorAdd(int* a, int* b, int* c)
{
		int index = threadIdx.x + blockIdx.x * blockDim.x;
		c[index] = a[index] + b[index];
}



int main(void) {
	int size  = sizeof(int)*N;
	
	int *h_A,*h_B;
	int *h_C;

	h_A = (int *)malloc(size);
	h_B = (int *)malloc(size);
	h_C = (int *)malloc(size); 

	scanf("%d %d",h_A,h_B);

	
	int *d_A = NULL;
	int *d_B = NULL;
	int *d_C = NULL;

	cudaMalloc((void **)&d_A,size);
	cudaMalloc((void **)&d_B,size);
	cudaMalloc((void **)&d_C,size); 
	
	
	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

	clock_t begin = clock();
	vectorAdd<<<N/THREADS_PER_BLCOK,THREADS_PER_BLCOK>>> (d_A,d_B,d_C);
	cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
	clock_t end = clock();

	if (*h_C == *h_A + *h_B)
	{
			printf("add correction! c is %d\n",*h_C);
	}
	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	free(h_A);
	free(h_B);
	free(h_C);

	printf("time: %ld\n",end-begin);
	printf("Done\n");
	return 0;
}
