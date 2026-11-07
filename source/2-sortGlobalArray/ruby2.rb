#!/usr/bin/env ruby

class Sorter
  def initialize
    @arr = Array.new(100, 0)
  end
def shells_sort
  gap = @arr.length / 2
  while gap > 0
    i = gap
    while i < @arr.length
      temp = @arr[i]
      j = i
      while j >= gap && @arr[j - gap] > temp
        @arr[j] = @arr[j - gap]
        j = j - gap
      end
      @arr[j] = temp
      i = i + 1
    end
    gap = gap / 2
  end
end
def run(iterations, seed)
  state = seed
  checksum = 0
  c = 0
  while c < iterations
    k = 0
    while k < @arr.length
      state = (state * 1664525 + 1013904223) & 2147483647
      @arr[k] = (state >> 8) & 65535
      k = k + 1
    end
    shells_sort
    k = 0
    while k < @arr.length
      checksum = (checksum * 31 + @arr[k]) & 2147483647
      k = k + 1
    end
    c = c + 1
  end
  checksum
end
end
def argument(index, fallback)
  value = ARGV[index] ? Integer(ARGV[index], 10) : fallback
  raise ArgumentError, 'Arguments must be in 0..2147483647' unless (0..2147483647).cover?(value)
  value
end
raise ArgumentError, 'iterations [seed [warmup]]' unless (1..3).cover?(ARGV.length)
iterations = argument(0, 0)
seed = argument(1, 12345)
warmup = argument(2, 10000)
sorter = Sorter.new
warmup_checksum = sorter.run(warmup, seed)
start = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
checksum = sorter.run(iterations, seed)
elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start
puts "elapsed_ns=#{elapsed} checksum=#{checksum} warmup_checksum=#{warmup_checksum}"
