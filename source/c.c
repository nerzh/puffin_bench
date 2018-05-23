#include <stdio.h>
#include <stdlib.h>

 int compare (const void * a, const void * b)
{
  return ( *(int*)a - *(int*)b );
}

int main() {
  int arr[10];
  int c;

  for(c = 0; c < 10000000; c++) {
    arr[0] = 9;
    arr[1] = 8;
    arr[2] = 7;
    arr[3] = 6;
    arr[4] = 5;
    arr[5] = 4;
    arr[6] = 3;
    arr[7] = 2;
    arr[8] = 1;
    arr[9] = 0;
    qsort(arr, 10, sizeof(int), compare);

  }

  printf("c 123\n");
}
