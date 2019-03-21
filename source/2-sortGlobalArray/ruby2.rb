#!/usr/bin/env ruby

def shellsSort()
  n    = $arr.count
  gap  = n/2
  i    = 0
  j    = 0
  temp = nil
  
  while gap > 0 do
    i = gap
    while i < n do
      temp = $arr[i]
      j    = i
      while (j >= gap && $arr[j - gap] > temp) do
        $arr[j] = $arr[j - gap]
        j       = j - gap
      end
      $arr[j] = temp
      i       = i + 1
    end
    gap = gap/2
  end	
end

$arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
c   = 0
c2  = 0

while (c < 15000000) do
  while (c2 < 10) do
    $arr[c2] = 9 - c2
    c2 = c2 + 1
  end
  shellsSort()
  c  = c + 1
  c2 = 0
end

p "Ruby global array #{`ruby -v`}"