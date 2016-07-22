__device__
int rectanglesSum(int** integralImage, int x, int y, int w, int h)
{
    int A = x > 0 && y > 0 ? integralImage[x - 1][y - 1] : 0;
    int B = x + w > 0 && y > 0 ? integralImage[x + w - 1][y - 1] : 0;
    int C = x > 0 && y + h > 0 ? integralImage[x - 1][y + h - 1] : 0;
    int D = x + w > 0 && y + h > 0 ? integralImage[x + w - 1][y + h - 1] : 0;

    return A + D - B - C;
}

extern "C"
__global__ void haar_type_C(int** integralImage, int* allRectangles, int numRectangles, int* haarFeatures)
{
    // Get an "unique id" of the thread that correspond to one pixel
    const unsigned int tidX = blockIdx.x * blockDim.x + threadIdx.x;

    if (tidX < numRectangles)
    {

        int x = allRectangles[tidX * 4];
        int y = allRectangles[tidX * 4 + 1];
        int w = allRectangles[tidX * 4 + 2];
        int h = allRectangles[tidX * 4 + 3];

        int mid = h / 2;

        int r1 = rectanglesSum(integralImage, x, y, w, mid);

        int r2 = rectanglesSum(integralImage, x, y + mid, w, mid);

        haarFeatures[tidX] = r2 - r1;
    }

    __syncthreads();
}