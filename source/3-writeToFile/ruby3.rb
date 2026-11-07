#!/usr/bin/env ruby

def argument(index, fallback)
  value = ARGV[index] ? Integer(ARGV[index], 10) : fallback
  raise ArgumentError, 'Invalid count' unless (0..2147483647).cover?(value)
  value
end

def run(iterations)
  template = "test_text\n"
  result = +''
  count = 0
  while count < iterations
    result << template
    count = count + 1
  end
  File.open('./store/ruby.txt', 'wb') do |file|
    file.write(result)
  end
  result.bytesize
end
raise ArgumentError, 'lines [warmup_lines]' if ARGV.length > 2
iterations = argument(0, 80000000)
warmup = argument(1, 10000)
warmup_bytes = run(warmup)
start = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
bytes = run(iterations)
elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond) - start
puts "elapsed_ns=#{elapsed} bytes=#{bytes} warmup_bytes=#{warmup_bytes}"
