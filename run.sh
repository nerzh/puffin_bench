bash -lc 'mkdir ./compiled' 2>/dev/null
bash -lc 'mkdir ./store' 2>/dev/null

exec_bench() {
  if [ `uname -s` = Linux ]; then
		exec 3>&1 4>&2
  	TT=$( { /usr/bin/time -f '%e sec.' $1 1>&3; } 2>&1 )
  	printf "\033[1m"
   	printf "$TT"
  	printf "\033[0m"
  	echo "";
  	echo "---";
  else
		exec 3>&1 4>&2
  	TT=$( { /usr/bin/time $1 1>&3; } 2>&1 )
  	printf "\033[1m"
   	printf "$TT"
  	printf "\033[0m"
  	echo "";
  	echo "---";
  fi
}

################################################### 1-sortArray
# exec_bench './source/1-sortArray/perl.pl'
# exec_bench './source/1-sortArray/php.php'
exec_bench './source/1-sortArray/node.js'
# exec_bench './source/1-sortArray/ruby.rb'
# exec_bench './source/1-sortArray/python.py'
# exec_bench './source/1-sortArray/kotlin.kts'
# exec_bench './source/1-sortArray/elixir.ex'
swiftc -O -whole-module-optimization ./source/1-sortArray/swift.swift -o ./compiled/swift
exec_bench './compiled/swift'

go build -o ./compiled/go ./source/1-sortArray/go.go
exec_bench './compiled/go'

gcc -O2 -o ./compiled/c.out ./source/1-sortArray/c.c
exec_bench "./compiled/c.out"

################################################### 2-sortGlobalArray
# exec_bench './source/2-sortGlobalArray/perl2.pl'
# exec_bench './source/2-sortGlobalArray/php2.php'
exec_bench './source/2-sortGlobalArray/node2.js'
# exec_bench './source/2-sortGlobalArray/ruby2.rb'
# exec_bench './source/2-sortGlobalArray/python2.py'

swiftc -O -whole-module-optimization ./source/2-sortGlobalArray/swift2.swift -o ./compiled/swift2
exec_bench './compiled/swift2'

################################################### 3-writeToFile
exec_bench './source/3-writeToFile/node3.js'

swiftc -O -whole-module-optimization ./source/3-writeToFile/swift3.swift -o ./compiled/swift3
exec_bench './compiled/swift3'


################################################### 4-Thread
# exec_bench './source/4-Thread/node4.js'

# swiftc -O -whole-module-optimization ./source/4-Thread/swift4.swift -o ./compiled/swift4
# exec_bench './compiled/swift4'


