bash -lc 'mkdir ./compiled' 2>/dev/null
bash -lc 'mkdir ./store' 2>/dev/null

exec_bench() {
  exec 3>&1 4>&2
  if [ `uname -s` = Linux ]; then
    TT=$( { /usr/bin/time -f '%e sec.' $1 1>&3; } 2>&1 )
  else
    TT=$( { /usr/bin/time $1 1>&3; } 2>&1 )
  fi
  printf "\033[1m"
  printf "$TT"
  printf "\033[0m"
  echo "";
  echo "---";
}


################################################### 1-sortArray
# Perl
# exec_bench './source/1-sortArray/perl.pl'

# PHP
# exec_bench './source/1-sortArray/php.php'

# NodeJS
# exec_bench './source/1-sortArray/node.js'

# Ruby
# exec_bench './source/1-sortArray/ruby.rb'

# Python
# exec_bench './source/1-sortArray/python.py'

# Kotlin
# exec_bench './source/1-sortArray/kotlin.kts'

# Elixir
# exec_bench './source/1-sortArray/elixir.ex'

# Swift
# swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/1-sortArray/swift.swift -o ./compiled/swift
# exec_bench './compiled/swift'

# GO
# go build -o ./compiled/go ./source/1-sortArray/go.go
# exec_bench './compiled/go'

# C
# gcc -O2 -o ./compiled/c.out ./source/1-sortArray/c.c
# exec_bench "./compiled/c.out"

################################################### 2-sortGlobalArray
# Perl
# exec_bench './source/2-sortGlobalArray/perl2.pl'

# PHP
# exec_bench './source/2-sortGlobalArray/php2.php'

# NodeJS
# exec_bench './source/2-sortGlobalArray/node2.js'

# Ruby
# exec_bench './source/2-sortGlobalArray/ruby2.rb'

# Pythone
# exec_bench './source/2-sortGlobalArray/python2.py'

# Swift
swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/2-sortGlobalArray/swift2_function.swift -o ./compiled/swift2_function
swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/2-sortGlobalArray/swift2_class.swift -o ./compiled/swift2_class
swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/2-sortGlobalArray/swift2_final_class.swift -o ./compiled/swift2_final_class
exec_bench './compiled/swift2_function'
exec_bench './compiled/swift2_class'
exec_bench './compiled/swift2_final_class'

################################################### 3-writeToFile
# NodeJS
# exec_bench './source/3-writeToFile/node3.js'

# RUBY
# exec_bench './source/3-writeToFile/ruby3.rb'

# Swift
swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/3-writeToFile/swift3.swift -o ./compiled/swift3
exec_bench './compiled/swift3'

# Swift-POSIX
swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/3-writeToFile/swift3-posix.swift -o ./compiled/swift3-posix
exec_bench './compiled/swift3-posix'

# Rust
# rustc ./source/3-writeToFile/rust3.rs -o ./compiled/rust3
# exec_bench './compiled/rust3'
################################################### 4-Thread
# ... coming soon ...


