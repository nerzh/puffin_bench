#!/usr/bin/env python

def shellsSort(arr):
  n    = len(arr)
  gap  = n/2
  i    = 0
  j    = 0
  temp = None
  
  while (gap > 0):
    i = gap
    while (i < n):
      temp = arr[i]
      j    = i
      while (j >= gap and arr[j - gap] > temp):
        arr[j] = arr[j - gap]
        j      = j - gap
      arr[j] = temp
      i      = i + 1
    gap = gap/2
    

arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
c   = 0
c2  = 0

while (c < 15000000):
  while(c2 < 10) {
    arr[c2] = 9 - c2
    c2 = c2 + 1
  }
  shellsSort(arr)
  c  = c + 1
  c2 = 0

print("Python\n")