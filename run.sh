bash -lc "mkdir ./compiled" 2>/dev/null
bash -lc "mkdir ./store" 2>/dev/null

exec_bench() {
  exec 3>&1 4>&2
  if [ `uname -s` = Linux ]; then
    TT=$( { /usr/bin/time -f "%e sec." $1 1>&3; } 2>&1 )
  else
    TT=$( { /usr/bin/time $1 1>&3; } 2>&1 )
  fi
  printf "\033[1m"
  printf "$TT"
  printf "\033[0m"
  echo "";
  echo "---";
}

commandExist() {
  which $1 > /dev/null && echo '1' && return;
  echo '0';
}

# DEFAULT_ITERATIONS=25000000
DEFAULT_ITERATIONS=1500000

################################################### 1-sortArray

perlSortArray() {
  # Perl
  if [ $(commandExist 'perl') == "1" ]; then
    echo "Perl sort array by reference"
    echo $(perl -v)
    exec_bench "./source/1-sortArray/perl.pl ${SORT_ARRAY_ITR}"
  fi
}

phpSortArray() {
  # PHP
  if [ $(commandExist 'php') == "1" ]; then
    echo "PHP sort array by reference"
    exec_bench "./source/1-sortArray/php.php ${SORT_ARRAY_ITR}"
  fi
}

nodejsSortArray() {
  # NodeJS
  if [ $(commandExist 'node') == "1" ]; then
    echo "NodeJS sort array by reference"
    exec_bench "./source/1-sortArray/node.js ${SORT_ARRAY_ITR}"
  fi
}

rubySortArray() {
  # Ruby
  if [ $(commandExist 'ruby') == "1" ]; then
    echo "Ruby sort array by reference"
    exec_bench "./source/1-sortArray/ruby.rb ${SORT_ARRAY_ITR}"
  fi
}

pythonSortArray() {
  # Python
  if [ $(commandExist 'python') == "1" ]; then
    echo "Python sort array by reference"
    exec_bench "./source/1-sortArray/python.py ${SORT_ARRAY_ITR}"
  fi
}

kotlinSortArray() {
  # Kotlin
  if [ $(commandExist 'kotlinc') == "1" ]; then
    echo "Kotlin sort array by reference"
    kotlinc kotlin.kts -include-runtime -d ./compiled/kotlin.jar
    exec_bench "java -jar ./source/1-sortArray/kotlin.jar ${SORT_ARRAY_ITR}"
  fi
}

elixirSortArray() {
  # Elixir
  if [ $(commandExist 'elixir') == "1" ]; then
    echo "Elixir sort array by reference"
    exec_bench "./source/1-sortArray/elixir.ex ${SORT_ARRAY_ITR}"
  fi
}

goSortArray() {
  # GO
  if [ $(commandExist 'go') == "1" ]; then
    echo "GO sort array by reference"
    go build -o ./compiled/go ./source/1-sortArray/go.go
    exec_bench "./compiled/go ${SORT_ARRAY_ITR}"
  fi
}

swiftSortArray() {
  # Swift
  if [ $(commandExist 'swiftc') == "1" ]; then
    echo "Swift sort array by reference"
    swiftc -Ounchecked -whole-module-optimization ./source/1-sortArray/swift.swift -o ./compiled/swift
    exec_bench "./compiled/swift ${SORT_ARRAY_ITR}"
  fi
}

scalaSortArray() {
  # Scala
  if [ $(commandExist 'scalac') == "1" ]; then
    echo "Scala sort array by reference"
    scalac ./source/1-sortArray/scala.scala -optimise -d ./compiled
    exec_bench "java -classpath ./compiled SortArray ${SORT_ARRAY_ITR}"
  fi
}

rustSortArray() {
  # Rust
  if [ $(commandExist 'rustc') == "1" ]; then
    echo "Rust sort array by reference"
    rustc -O ./source/1-sortArray/rust.rs -o ./compiled/rust
    exec_bench "./compiled/rust ${SORT_ARRAY_ITR}"
  fi
}

gccSortArray() {
  # C
  if [ $(commandExist 'gcc') == "1" ]; then
    echo "GCC sort array by reference"
    gcc -O2 -o ./compiled/c.out ./source/1-sortArray/c.c
    exec_bench "./compiled/c.out ${SORT_ARRAY_ITR}"
  fi
}

clangSortArray() {
  # Clang
  if [ $(commandExist 'clang') == "1" ]; then
    echo "Clang sort array by reference"
    clang -Wall -O2 ./source/1-sortArray/clang.c -o ./compiled/clang.out
    exec_bench "./compiled/clang.out ${SORT_ARRAY_ITR}"
  fi
}




################################################### 2-sortGlobalArray

perlSortGlobalArray() {
  # Perl
  if [ $(commandExist 'perl') == "1" ]; then
    echo "Perl sort gloabl array"
    exec_bench "./source/2-sortGlobalArray/perl2.pl ${SORT_ARRAY_ITR}"
  fi
}

phpSortGlobalArray() {
  # PHP
  if [ $(commandExist 'php') == "1" ]; then
    echo "PHP sort gloabl array"
    exec_bench "./source/2-sortGlobalArray/php2.php ${SORT_ARRAY_ITR}"
  fi
}

nodejsSortGlobalArray() {
  # NodeJS
  if [ $(commandExist 'node') == "1" ]; then
    echo "NodeJS sort gloabl array"
    exec_bench "./source/2-sortGlobalArray/node2.js ${SORT_ARRAY_ITR}"
  fi
}

rubySortGlobalArray() {
  # Ruby
  if [ $(commandExist 'ruby') == "1" ]; then
    echo "Ruby sort gloabl array"
    exec_bench "./source/2-sortGlobalArray/ruby2.rb ${SORT_ARRAY_ITR}"
  fi
}

pythonSortGlobalArray() {
  # Python
  if [ $(commandExist 'python') == "1" ]; then
    echo "Python sort gloabl array"
    exec_bench "./source/2-sortGlobalArray/python2.py ${SORT_ARRAY_ITR}"
  fi
}

goSortGlobalArray() {
  # GO
  if [ $(commandExist 'go') == "1" ]; then
    echo "GO sort gloabl array"
    go build -o ./compiled/go2 ./source/2-sortGlobalArray/go2.go
    exec_bench "./compiled/go2 ${SORT_ARRAY_ITR}"
  fi
}

swiftSortGlobalArray() {
  # Swift
  if [ $(commandExist 'swiftc') == "1" ]; then
    swiftc -Ounchecked -whole-module-optimization ./source/2-sortGlobalArray/swift2_function.swift -o ./compiled/swift2_function
    swiftc -Ounchecked -whole-module-optimization ./source/2-sortGlobalArray/swift2_class.swift -o ./compiled/swift2_class
    swiftc -Ounchecked -whole-module-optimization ./source/2-sortGlobalArray/swift2_final_class.swift -o ./compiled/swift2_final_class
    echo "Swift sort gloabl array. Function call"
    exec_bench "./compiled/swift2_function ${SORT_GLOBAL_ARRAY_ITR}"
    echo "Swift sort gloabl array. Internal class call"
    exec_bench "./compiled/swift2_class ${SORT_GLOBAL_ARRAY_ITR}"
    echo "Swift sort gloabl array. Final class call"
    exec_bench "./compiled/swift2_final_class ${SORT_GLOBAL_ARRAY_ITR}"
  fi
}

gccSortGlobalArray() {
  # C
  if [ $(commandExist 'gcc') == "1" ]; then
    echo "GCC sort gloabl array"
    gcc -O2 -o ./compiled/c2.out ./source/2-sortGlobalArray/c2.c
    exec_bench "./compiled/c2.out ${SORT_GLOBAL_ARRAY_ITR}"
  fi
}

clangSortGlobalArray() {
  # Clang
  if [ $(commandExist 'clang') == "1" ]; then
    echo "Clang sort gloabl array"
    clang -Wall -O2 ./source/2-sortGlobalArray/clang2.c -o ./compiled/clang2.out
    exec_bench "./compiled/clang2.out ${SORT_GLOBAL_ARRAY_ITR}"
  fi
}




################################################### 3-writeToFile

nodejsWriteToFile() {
  # NodeJS
  if [ $(commandExist 'node') == "1" ]; then
    echo "NodeJS write to file"
    exec_bench "./source/3-writeToFile/node3.js"
  fi
}

rubyWriteToFile() {
  # RUBY
  if [ $(commandExist 'ruby') == "1" ]; then
    echo "RUBY write to file"
    exec_bench "./source/3-writeToFile/ruby3.rb"
  fi
}

goWriteToFile() {
  # GO
  if [ $(commandExist 'go') == "1" ]; then
    echo "GO write to file"
    go build -o ./compiled/go3 ./source/3-writeToFile/go3.go
    exec_bench "./compiled/go3 ${SORT_ARRAY_ITR}"
  fi
}

swiftWriteToFile() {
  # Swift
  if [ $(commandExist 'swiftc') == "1" ]; then
    echo "Swift write to file"
    swiftc -Ounchecked -whole-module-optimization ./source/3-writeToFile/swift3.swift -o ./compiled/swift3
    sleep 0.5
    exec_bench "./compiled/swift3"
  fi
}

swiftPOSIXWriteToFile() {
  # Swift-POSIX
  if [ $(commandExist 'swiftc') == "1" ]; then
    echo "Swift-POSIX write to file"
    swiftc -Ounchecked -whole-module-optimization ./source/3-writeToFile/swift3-posix.swift -o ./compiled/swift3-posix
    sleep 0.5
    exec_bench "./compiled/swift3-posix"
  fi
}

rustWriteToFile() {
  # Rust
  if [ $(commandExist 'rustc') == "1" ]; then
    echo "Rust write to file"
    rustc -O ./source/3-writeToFile/rust3.rs -o ./compiled/rust3
    sleep 0.5
    exec_bench "./compiled/rust3"
  fi
}




################################################### 4-Thread
# ... coming soon ...




sortArray() {
  printf "\nTEST 1. Sort array\n";
  SORT_ARRAY_ITR=${DEFAULT_ITERATIONS}

  perlSortArray
  phpSortArray
  nodejsSortArray
  rubySortArray
  pythonSortArray
  kotlinSortArray
  elixirSortArray
  swiftSortArray
  goSortArray
  scalaSortArray
  rustSortArray
  gccSortArray
  clangSortArray
}

sortGlobalArray() {
  printf "\nTEST 2. Sort global array\n";
  SORT_GLOBAL_ARRAY_ITR=${DEFAULT_ITERATIONS}

  perlSortGlobalArray
  phpSortGlobalArray
  nodejsSortGlobalArray
  rubySortGlobalArray
  pythonSortGlobalArray
  goSortGlobalArray
  swiftSortGlobalArray
  gccSortGlobalArray
  clangSortGlobalArray
}

writeToFile() {
  printf "\nTEST 3. Write to file\n";

  nodejsWriteToFile
  rubyWriteToFile
  goWriteToFile
  swiftWriteToFile
  swiftPOSIXWriteToFile
  rustWriteToFile
}




# sortArray
# sortGlobalArray
writeToFile

