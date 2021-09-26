#include<stdio.h>
#define BS 8

struct Node{
int start;
int length;
};
__global__ void print(int i){
		printf(" %d",i);
}
__global__ void bfs_kernel(Node *Va, int *Ea, bool *Fa, bool *Xa, int *Ca,bool *done,int* n1)
{
int id = threadIdx.x + blockIdx.x*blockDim.x;
	if(id>(*n1))*done=false;

	if(Fa[id] == true && Xa[id]==false)
	{
		printf("%d ",id);
	Fa[id]=false;
	Xa[id]=true;
	__syncthreads();
	int s = Va[id].start;
	int e = s+Va[id].length;
	for(int i=s;i<e;i++){
	int nid = Ea[id];
	if(Xa[nid] == false)
	{	
	Ca[nid]=Ca[id]+1;
	Fa[nid]=true;
	*done=false;
	}
	}
	}
}
int main(){
 int threadsPerBlock, blocksPerGrid;
	threadsPerBlock = 8;
	blocksPerGrid = 1;
int e;
int n;
int* nx = (int *)malloc(sizeof(int));
scanf("%d %d",&n,&e);
*nx = n;
int* nc;
	cudaMalloc((void**)&nc, sizeof(int));
	cudaMemcpy(nc,nx,sizeof(int), cudaMemcpyHostToDevice);
Node node[n];
for(int i=0;i<n;i++){
int x,y;
scanf("%d %d",&x,&y);
node[i].start = x;
node[i].length = y;
}

int edge[e];
for(int i=0;i<e;i++){
int x;
scanf("%d ",&x);
edge[i] = x;
}
bool frontier[n] = {false};
bool visited[n] = {false};
int cost[n] = {0};

int source;
scanf("%d",&source);
frontier[source] = true;

Node* Va;
	cudaMalloc((void**)&Va, sizeof(Node)*n);
	cudaMemcpy(Va, node, sizeof(Node)*n, cudaMemcpyHostToDevice);

int* Ea;
	cudaMalloc((void**)&Ea, sizeof(int)*e);
	cudaMemcpy(Ea, edge, sizeof(Node)*e, cudaMemcpyHostToDevice);

bool* Fa;
	cudaMalloc((void**)&Fa, sizeof(bool)*n);
	cudaMemcpy(Fa, frontier, sizeof(bool)*n, cudaMemcpyHostToDevice);

	bool* Xa;
	cudaMalloc((void**)&Xa, sizeof(bool)*n);
	cudaMemcpy(Xa, visited, sizeof(bool)*n, cudaMemcpyHostToDevice);

	int* Ca;
	cudaMalloc((void**)&Ca, sizeof(int)*n);
	cudaMemcpy(Ca, cost, sizeof(int)*n, cudaMemcpyHostToDevice);

bool done;
bool* dd;
printf("\n\n");
cudaMalloc((void**)&dd,sizeof(bool));
int c=0;

printf("Order: \n\n");
do{
	c++;
	done = true;
	cudaMemcpy(dd,&done,sizeof(bool),cudaMemcpyHostToDevice);
	bfs_kernel<<<blocksPerGrid, threadsPerBlock>>>(Va, Ea, Fa, Xa, Ca,dd,nc);
	cudaMemcpy(&done, dd , sizeof(bool), cudaMemcpyDeviceToHost);

}while(!done);
cudaMemcpy(cost, Ca, sizeof(int)*n, cudaMemcpyDeviceToHost);
printf("Number of times the kernel is called : %d \n", c);
printf("\nCost: ");
	for (int i = 0; i<n; i++)
		printf( "%d    ", cost[i]);
	printf("\n");
}
