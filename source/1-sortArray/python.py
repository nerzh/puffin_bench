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
            j = i
            while (j >= gap and arr[j - gap] > temp):
                arr[j] = arr[j - gap]
                j = j - gap
            arr[j] = temp
            i = i + 1
        gap = gap/2
    

a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
c = 0

while (c < 10000000):
    shellsSort(a)
    a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
    c = c + 1

print("Python\n")