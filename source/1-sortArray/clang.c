#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void shellsSort(int *arr) {
  int n    = 10;
  int gap  = n / 2;
  int i    = 0;
  int j    = 0;
  int temp = 0;
  
  while(gap > 0) {
    i = gap;
    while(i < n) {
      temp = arr[i];
      j    = i;
      while(j >= gap && arr[j - gap] > temp) {
        arr[j] = arr[j - gap];
        j      = j - gap;
      }
      arr[j] = temp;
      i      = i + 1;
    }
    gap = (int)(gap / 2);
  }
}

int main(int argc, char *argv[]) {
  int *arr = (int *) calloc(10, sizeof(int));
  int c    = 0;
  int c2   = 0;
  int i    = atoi(argv[1]);
  
  while(c < i) {
    while(c2 < 10) {
      arr[c2] = 9 - c2;
      c2 = c2 + 1;
    }
    shellsSort(arr);
    c  = c + 1;
    c2 = 0;
  }

  free(arr);
  printf("Clang Sort array\n");
  printf("Clang Compiler %d.%d\n", __GNUC__, __GNUC_MINOR__);
  return 0;
}
