#!/usr/bin/env python3
import sys
import time

class Sorter:
    def __init__(self):
        self.arr = [0] * 100

    def shells_sort(self):
        gap = len(self.arr) // 2
        while gap > 0:
            i = gap
            while i < len(self.arr):
                temp = self.arr[i]
                j = i
                while j >= gap and self.arr[j - gap] > temp:
                    self.arr[j] = self.arr[j - gap]
                    j = j - gap
                self.arr[j] = temp
                i = i + 1
            gap = gap // 2

    def run(self, iterations, seed):
        state = seed
        checksum = 0
        c = 0
        while c < iterations:
            k = 0
            while k < len(self.arr):
                state = (state * 1664525 + 1013904223) & 2147483647
                self.arr[k] = (state >> 8) & 65535
                k = k + 1
            self.shells_sort()
            k = 0
            while k < len(self.arr):
                checksum = (checksum * 31 + self.arr[k]) & 2147483647
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
sorter = Sorter()
warmup_checksum = sorter.run(warmup, seed)
start = time.perf_counter_ns()
checksum = sorter.run(iterations, seed)
elapsed = time.perf_counter_ns() - start
print(f"elapsed_ns={elapsed} checksum={checksum} warmup_checksum={warmup_checksum}")
