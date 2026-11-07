import Bitwise

defmodule SortArray do
  import Bitwise
  def shift(arr, j, gap, temp) do
    if j >= gap and elem(arr, j - gap) > temp do
      shift(put_elem(arr, j, elem(arr, j - gap)), j - gap, gap, temp)
    else
      put_elem(arr, j, temp)
    end
  end
  def pass(arr, i, gap) do
    if i < tuple_size(arr) do
      pass(shift(arr, i, gap, elem(arr, i)), i + 1, gap)
    else
      arr
    end
  end
  def shells_sort(arr, gap) do
    if gap > 0 do
      shells_sort(pass(arr, gap, gap), div(gap, 2))
    else
      arr
    end
  end
  def fill(arr, state, k) do
    if k < tuple_size(arr) do
      state = (state * 1664525 + 1013904223) &&& 2147483647
      fill(put_elem(arr, k, (state >>> 8) &&& 65535), state, k + 1)
    else
      {arr, state}
    end
  end
  def hash(arr, checksum, k) do
    if k < tuple_size(arr) do
      hash(arr, (checksum * 31 + elem(arr, k)) &&& 2147483647, k + 1)
    else
      checksum
    end
  end
  def run(arr, iterations, state, checksum \\ 0) do
    if iterations > 0 do
      {arr, state} = fill(arr, state, 0)
      arr = shells_sort(arr, div(tuple_size(arr), 2))
      run(arr, iterations - 1, state, hash(arr, checksum, 0))
    else
      checksum
    end
  end
  def argument(args, index, fallback) do
    value = case Enum.at(args, index) do
      nil -> fallback
      text -> String.to_integer(text)
    end
    if value < 0 or value > 2147483647, do: raise("Invalid argument")
    value
  end
end
args = System.argv()
if length(args) < 1 or length(args) > 3, do: raise("iterations [seed [warmup]]")
iterations = SortArray.argument(args, 0, 0)
seed = SortArray.argument(args, 1, 12345)
warmup = SortArray.argument(args, 2, 10000)
arr = :erlang.make_tuple(100, 0)
warmup_checksum = SortArray.run(arr, warmup, seed)
start = System.monotonic_time(:nanosecond)
checksum = SortArray.run(arr, iterations, seed)
elapsed = System.monotonic_time(:nanosecond) - start
IO.puts("elapsed_ns=#{elapsed} checksum=#{checksum} warmup_checksum=#{warmup_checksum}")
