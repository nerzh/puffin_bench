#!/usr/bin/env elixir

defmodule M do
	def while3(j, gap, arr, temp) do
		if j >= gap and element(arr, j - gap) > temp do
			arr = change_tuple(arr, j, element(arr, j - gap))
			j = j - gap
			while3(j, gap, arr, temp)
		else
			{j, arr}
		end
	end

	def while2(gap, arr, n, i) do
		if i < n do
			temp = element(arr, i)
			j = i
			temp_tuple = while3(j, gap, arr, temp)
			arr = change_tuple(elem(temp_tuple, 1), elem(temp_tuple, 0), temp)
			i = i + 1
			while2(gap, arr, n, i)
		else
			arr
		end
	end

	def while1(gap, arr, n) do
		if gap > 0 do
			i = gap
			arr = while2(gap, arr, n, i)
			gap = Kernel.trunc(gap/2)
			while1(gap, arr, n)
		else
			arr
		end
	end

	def element(temp_tuple, position) do
		elem(temp_tuple, position)
		# Enum.at(temp_tuple, position)
	end


	def change_tuple(tuple, position, value) do
		Tuple.insert_at(Tuple.delete_at(tuple, position), position, value)
		# List.replace_at(tuple, position, value)
	end

	def shellsSort(arr) do
		n   = tuple_size(arr)
		# n   = length(arr)
		gap = Kernel.trunc(n/2)
		while1(gap, arr, n)
	end

	def h() do
		IO.puts "halt"
		System.halt(0)
	end

	def pr_t(t, n) do
		if n < tuple_size(t) do
		# if n < length(t) do
			IO.puts "#{element(t, n)}"
			pr_t(t, n + 1)
		end
	end

	def pr(s) do
		IO.puts "#{s}"
	end

	def main(n) do
		if n > 0 do
			arr = {9,8,7,6,5,4,3,2,1,0}
			# arr = [9,8,7,6,5,4,3,2,1,0]
			shellsSort(arr)
			# pr_t(z, 0)
			main(n - 1)
		end
	end
end

M.main(15000000)
M.pr("ELIXIR")



