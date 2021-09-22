%%cu
#include <stdio.h>
#define BS 8
#define N 10
void print(int *A, int n)
{
  for(int i=0; i<n; i++) printf("%d ",A[i]);
}
__global__ void addition( int *A,int *B,int  *C, int n)
{
int i = blockDim.x * blockIdx.x + threadIdx.x;
if(i < n) C[i]=A[i]+B[i];
}
int main(void)
{
 int threadsPerBlock, blocksPerGrid, n, *A,*B,*C,*dA,*dB,*dC;
   n = N; threadsPerBlock = BS;
   blocksPerGrid = (n + BS - 1) / BS;
   A = (int *)malloc(n * sizeof(int));
   B = (int *)malloc(n * sizeof(int));
   C = (int *)malloc(n * sizeof(int));
   for (int i = 0; i < n; i++) A[i] = i * 10; 
   for (int i = 0; i < n; i++) B[i] = i * 20; 
cudaMalloc((void **)&dA, n * sizeof(int));
cudaMalloc((void **)&dB, n * sizeof(int));
cudaMalloc((void **)&dC, n * sizeof(int));
cudaMemcpy(dA, A, n * sizeof(int),     cudaMemcpyHostToDevice);
cudaMemcpy(dB, B, n * sizeof(int),     cudaMemcpyHostToDevice);
addition<<<blocksPerGrid, threadsPerBlock>>>(dA,dB,dC,n);
cudaMemcpy(C, dC, n * sizeof(int), cudaMemcpyDeviceToHost);  
 print(C,n);
 cudaFree(dA);  free(A);  
 cudaFree(dB);  free(B);
 cudaFree(dC);  free(C);

 return 0;
}

