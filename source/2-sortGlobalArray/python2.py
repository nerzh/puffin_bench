#!/usr/bin/env python

import sys

def shellsSort():
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
i   = int(sys.argv[1])

while (c < i):
  while(c2 < 10):
    arr[c2] = 9 - c2
    c2 = c2 + 1

  shellsSort()
  c  = c + 1
  c2 = 0