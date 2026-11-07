// Copyright 2010-2026 Dustin Kirkland
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Print a howdy greeting to stdout. With a CUDA GPU, a kernel writes the
// greeting into device memory and the host prints the copy; without one
// (or without a driver), the host prints the same greeting. Which path ran
// goes to stderr, so stdout is identical either way.

#include <cstdio>
#include <cstring>
#include <cuda_runtime.h>

static const char greeting[] = "    ====> CUDA: Howdy!\n";

__constant__ char device_greeting[sizeof(greeting)] = "    ====> CUDA: Howdy!\n";

// Each thread copies one byte of the greeting into the output buffer.
__global__ void howdy(char *out, int n)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if (i < n)
		out[i] = device_greeting[i];
}

static int from_gpu(void)
{
	char text[sizeof(greeting)] = {0};
	char *buf = NULL;
	int n = (int)sizeof(greeting);
	cudaError_t err = cudaMalloc((void **)&buf, sizeof(greeting));
	if (err == cudaSuccess) {
		howdy<<<1, n>>>(buf, n);
		err = cudaGetLastError();
	}
	if (err == cudaSuccess)
		err = cudaMemcpy(text, buf, sizeof(greeting), cudaMemcpyDeviceToHost);
	cudaFree(buf);
	if (err != cudaSuccess) {
		fprintf(stderr, "howdy-cuda: kernel failed: %s\n", cudaGetErrorString(err));
		return 1;
	}
	if (memcmp(text, greeting, sizeof(greeting)) != 0) {
		fprintf(stderr, "howdy-cuda: kernel returned the wrong text\n");
		return 1;
	}
	fputs(text, stdout);
	return 0;
}

int main(void)
{
	int devices = 0;
	cudaError_t err = cudaGetDeviceCount(&devices);
	if (err == cudaSuccess && devices > 0) {
		fprintf(stderr, "howdy-cuda: GPU path (%d device(s))\n", devices);
		return from_gpu();
	}
	fprintf(stderr, "howdy-cuda: host path (no CUDA device: %s)\n",
		err == cudaSuccess ? "0 devices" : cudaGetErrorString(err));
	fputs(greeting, stdout);
	return 0;
}
