exec_bench() {
  if [ `uname -s` = Linux ]; then
  	bash -lc "/usr/bin/time -f '%E real, %U user, %S sys, %K memory, %P CPU' bash -lc '$1'"
  else
  	bash -lc "/usr/bin/time -l bash -lc '$1'"
  fi
}

# exec_bench './source/perl.pl'
# exec_bench './source/perl2.pl'
# exec_bench './source/php.php'
# exec_bench './source/php2.php'
exec_bench './source/node.js'
# exec_bench './source/node2.js'
# exec_bench './source/ruby.rb'
# exec_bench './source/ruby2.rb'
# exec_bench './source/python.py'
# exec_bench './source/python2.py'
# exec_bench './source/kotlin.kts'
# exec_bench './source/elixir.ex'
# swiftc -O ./source/swift.swift -o ./compiled/swift
# swiftc -O ./source/swift2.swift -o ./compiled/swift2
# exec_bench './compiled/swift'
# exec_bench './compiled/swift2'
# go build -o ./compiled/go ./source/go.go
# exec_bench './compiled/go'

gcc -O3 -o ./compiled/c.exe ./source/c.c
exec_bench ./compiled/c.exe
