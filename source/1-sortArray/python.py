#!/usr/bin/env python3
import sys
import time

def shells_sort(arr):
    gap = len(arr) // 2
    while gap > 0:
        i = gap
        while i < len(arr):
            temp = arr[i]
            j = i
            while j >= gap and arr[j - gap] > temp:
                arr[j] = arr[j - gap]
                j = j - gap
            arr[j] = temp
            i = i + 1
        gap = gap // 2

def run(arr, iterations, seed):
    state = seed
    checksum = 0
    c = 0
    while c < iterations:
        k = 0
        while k < len(arr):
            state = (state * 1664525 + 1013904223) & 2147483647
            arr[k] = (state >> 8) & 65535
            k = k + 1
        shells_sort(arr)
        k = 0
        while k < len(arr):
            checksum = (checksum * 31 + arr[k]) & 2147483647
            k = k + 1
        c = c + 1
    return checksum

def argument(index, fallback):
    value = int(sys.argv[index]) if len(sys.argv) > index else fallback
    if not 0 <= value <= 2147483647:
        raise ValueError("Arguments must be in 0..2147483647")
    return value

if not 2 <= len(sys.argv) <= 4:
    raise ValueError("iterations [seed [warmup]]")
iterations = argument(1, 0)
seed = argument(2, 12345)
warmup = argument(3, 10000)
arr = [0] * 100
warmup_checksum = run(arr, warmup, seed)
start = time.perf_counter_ns()
checksum = run(arr, iterations, seed)
elapsed = time.perf_counter_ns() - start
print(f"elapsed_ns={elapsed} checksum={checksum} warmup_checksum={warmup_checksum}")
