#include <stdio.h>
#include <stdlib.h>

 int compare (const void * a, const void * b)
{
  return ( *(int*)a - *(int*)b );
}

void shellsSort(int *arr) {
		int n 		= 10;
		int gap		= n / 2;
		int i			= 0;
		int j			= 0;
		int temp	= 0;
		
		while(gap > 0) {
				i = gap;
				while(i < n) {
						temp = arr[i];
						j = i;
						while(j >= gap && arr[j - gap] > temp) {
								arr[j] = arr[j - gap];
								j = j - gap;
						}
						arr[j] = temp;
						i = i + 1;
				}
				gap = (int)(gap / 2);
		}
}

int main() {
  int arr[10];
  int c = 0;

  while(c < 10000000) {
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
		c++;
		shellsSort(arr);
    //qsort(arr, 10, sizeof(int), compare);
  }

  printf("gcc %d.%d\n", __GNUC__, __GNUC_MINOR__);
	
	return 0;
}
