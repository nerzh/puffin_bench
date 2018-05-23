
def shellsSort(arr)
	n = arr.count
    gap = n/2
    i  = 0
    j  = 0
    temp = nil
    
    while gap > 0 do
        i = gap
        while i < n do
            temp = arr[i]
            j = i
            while (j >= gap && arr[j - gap] > temp) do
                arr[j] = arr[j - gap]
                j = j - gap
            end
            arr[j] = temp
            i = i + 1
        end
        gap = gap/2
    end	
end

a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

for c in 0...10000000
  a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  shellsSort(a)
end

p "ruby 123\n"