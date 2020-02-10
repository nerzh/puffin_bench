bash -lc "mkdir ./compiled" 2>/dev/null
bash -lc "mkdir ./store" 2>/dev/null

exec_bench() {
  exec 3>&2
  TIME="$(/usr/bin/time $1 3>&2 2>&1 1>&3)"
  exec 3>&-
  echo "$TIME"
}

print_exec_bench() {
  exec 3>&1
  if [ `uname -s` = Linux ]; then
    TT=$( { /usr/bin/time -f "%e sec." $1 1>&3; } 2>&1 )
  else
    TT=$( { /usr/bin/time $1 1>&3; } 2>&1 )
  fi
  printf "\033[1m"
  printf "$TT"
  printf "\033[0m"
  echo ""
  echo "- '' - '' - '' - '' - '' - '' - '' - '' - '' - '' - '' - '' - '' - '' - '' -"
  echo ""
}

middle_value() {
  echo "$1 iterations"
  iterations=$1
  command=$2
  sum=0

  for i in $(seq 1 $1)
  do
    out=$(exec_bench "$command")
    regexp="^[^[:digit:]]*([^[:blank:]]+)"
    [[ $out =~ $regexp ]]
    result=${BASH_REMATCH[1]}
    sum=$(awk '{print $1+$2}' <<<"${sum} ${result}")
  done
  echo $(awk '{print $1/$2}' <<<"${sum} ${iterations}")
}

execution_block() {
  dir=$1
  iterations=$2
  title=$3

  echo "- '' - '' - '' - '' -"
  echo ""
  echo "$title"
  middle=$(middle_value $iterations "$dir")
  printf "\033[1m"
  echo "$middle sec."
  printf "\033[0m"
}

commandExist() {
  which $1 > /dev/null && echo '1' && return;
  echo '0';
}

# DEFAULT_ITERATIONS=25000000
DEFAULT_ITERATIONS=1500000
EXECUTE_LOW_PERFORMANCE_ITERATIONS=2
EXECUTE_MIDDLE_PERFORMANCE_ITERATIONS=5
EXECUTE_HIGH_PERFORMANCE_ITERATIONS=40
WRITE_FILE_ITERATIONS=5

################################################### 1-sortArray

perlSortArray() {
  # Perl
  if [ $(commandExist 'perl') == "1" ]; then
    dir="./source/1-sortArray/perl.pl ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="Perl sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    perl -v | grep version
    echo "$result"
  fi
}

phpSortArray() {
  # PHP
  if [ $(commandExist 'php') == "1" ]; then
    dir="./source/1-sortArray/php.php ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="PHP sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    php -v | grep PHP
    echo "$result"
  fi
}

nodejsSortArray() {
  # NodeJS
  if [ $(commandExist 'node') == "1" ]; then
    dir="./source/1-sortArray/node.js ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="NodeJS sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    node -v
    echo "$result"
  fi
}

rubySortArray() {
  # Ruby
  if [ $(commandExist 'ruby') == "1" ]; then
    dir="./source/1-sortArray/ruby.rb ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="Ruby sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    ruby -v
    echo "$result"
  fi
}

pythonSortArray() {
  # Python
  if [ $(commandExist 'python') == "1" ]; then
    dir="./source/1-sortArray/python.py ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="Python sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    python --version
    echo "$result"
  fi
}

elixirSortArray() {
  # Elixir
  if [ $(commandExist 'elixir') == "1" ]; then
    dir="./source/1-sortArray/elixir.ex ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="Elixir sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    echo "$result"
  fi
}

kotlinSortArray() {
  # Kotlin
  if [ $(commandExist 'kotlinc') == "1" ]; then
    kotlinc kotlin.kts -include-runtime -d ./compiled/kotlin.jar
    dir="java -jar ./source/1-sortArray/kotlin.jar ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="Kotlin sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    kotlin -version
    echo "$result"
  fi
}

goSortArray() {
  # GO
  if [ $(commandExist 'go') == "1" ]; then
    go build -o ./compiled/go ./source/1-sortArray/go.go
    dir="./compiled/go ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="GO sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    go version
    echo "$result"
  fi
}

swiftSortArray() {
  # Swift
  if [ $(commandExist 'swiftc') == "1" ]; then
    swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/1-sortArray/swift.swift -o ./compiled/swift
    dir="./compiled/swift ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="Swift sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    swift --version
    echo "$result"
  fi
}

scalaSortArray() {
  # Scala
  if [ $(commandExist 'scalac') == "1" ]; then
    scalac ./source/1-sortArray/scala.scala -optimise -d ./compiled
    dir="java -classpath ./compiled SortArray ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="Scala sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    java -version
    echo "$result"
  fi
}

rustSortArray() {
  # Rust
  if [ $(commandExist 'rustc') == "1" ]; then
    rustc -O ./source/1-sortArray/rust.rs -o ./compiled/rust
    dir="./compiled/rust ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="Rust sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    rustc -V
    echo "$result"
  fi
}

gccSortArray() {
  # C
  if [ $(commandExist 'gcc') == "1" ]; then
    gcc -O2 -o ./compiled/c.out ./source/1-sortArray/c.c
    dir="./compiled/c.out ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="GCC sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    gcc --version
    echo "$result"
  fi
}

clangSortArray() {
  # Clang
  if [ $(commandExist 'clang') == "1" ]; then
    clang -Wall -O2 ./source/1-sortArray/clang.c -o ./compiled/clang.out
    dir="./compiled/clang.out ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="Clang sort array by reference"
    result=$(execution_block "$dir" "$iterations" "$title")
    clang -v
    echo "$result"
  fi
}




################################################### 2-sortGlobalArray

perlSortGlobalArray() {
  # Perl
  if [ $(commandExist 'perl') == "1" ]; then
    dir="./source/2-sortGlobalArray/perl2.pl ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="Perl sort gloabl array"
    result=$(execution_block "$dir" "iterations" "$title")
    perl -v | grep version
    echo "$result"
  fi
}

phpSortGlobalArray() {
  # PHP
  if [ $(commandExist 'php') == "1" ]; then
    dir="./source/2-sortGlobalArray/php2.php ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="PHP sort gloabl array"
    result=$(execution_block "$dir" "iterations" "$title")
    php -v | grep PHP
    echo "$result"
  fi
}

nodejsSortGlobalArray() {
  # NodeJS
  if [ $(commandExist 'node') == "1" ]; then
    dir="./source/2-sortGlobalArray/node2.js ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="NodeJS sort gloabl array"
    result=$(execution_block "$dir" "$iterations" "$title")
    node -v
    echo "$result"
  fi
}

rubySortGlobalArray() {
  # Ruby
  if [ $(commandExist 'ruby') == "1" ]; then
    dir="./source/2-sortGlobalArray/ruby2.rb ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="Ruby sort gloabl array"
    result=$(execution_block "$dir" "$iterations" "$title")
    ruby -v
    echo "$result"
  fi
}

pythonSortGlobalArray() {
  # Python
  if [ $(commandExist 'python') == "1" ]; then
    dir="./source/2-sortGlobalArray/python2.py ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_LOW_PERFORMANCE_ITERATIONS
    title="Python sort gloabl array"
    result=$(execution_block "$dir" "$iterations" "$title")
    python --version
    echo "$result"
  fi
}

goSortGlobalArray() {
  # GO
  if [ $(commandExist 'go') == "1" ]; then
    go build -o ./compiled/go2 ./source/2-sortGlobalArray/go2.go
    dir="./compiled/go2 ${SORT_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="GO sort gloabl array"
    result=$(execution_block "$dir" "$iterations" "$title")
    go version
    echo "$result"
  fi
}

swiftSortGlobalArray() {
  # Swift
  if [ $(commandExist 'swiftc') == "1" ]; then
    # swiftc -Ounchecked -whole-module-optimization ./source/2-sortGlobalArray/swift2_function.swift -o ./compiled/swift2_function
    # swiftc -Ounchecked -whole-module-optimization ./source/2-sortGlobalArray/swift2_class.swift -o ./compiled/swift2_class
    swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/2-sortGlobalArray/swift2_final_class.swift -o ./compiled/swift2_final_class
    # echo "Swift sort gloabl array. Function call"
    # print_exec_bench "./compiled/swift2_function ${SORT_GLOBAL_ARRAY_ITR}"
    # echo "Swift sort gloabl array. Internal class call"
    # print_exec_bench "./compiled/swift2_class ${SORT_GLOBAL_ARRAY_ITR}"

    dir="./compiled/swift2_final_class ${SORT_GLOBAL_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="Swift sort gloabl array. Final class call"
    result=$(execution_block "$dir" "$iterations" "$title")
    swift --version
    echo "$result"
  fi
}

gccSortGlobalArray() {
  # C
  if [ $(commandExist 'gcc') == "1" ]; then
    gcc -O2 -o ./compiled/c2.out ./source/2-sortGlobalArray/c2.c
    dir="./compiled/c2.out ${SORT_GLOBAL_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="GCC sort gloabl array"
    result=$(execution_block "$dir" "$iterations" "$title")
    gcc --version
    echo "$result"
  fi
}

clangSortGlobalArray() {
  # Clang
  if [ $(commandExist 'clang') == "1" ]; then
    clang -Wall -O2 ./source/2-sortGlobalArray/clang2.c -o ./compiled/clang2.out
    dir="./compiled/clang2.out ${SORT_GLOBAL_ARRAY_ITR}"
    iterations=$EXECUTE_HIGH_PERFORMANCE_ITERATIONS
    title="Clang sort gloabl array"
    result=$(execution_block "$dir" "$iterations" "$title")
    clang -v
    echo "$result"
  fi
}




################################################### 3-writeToFile

nodejsWriteToFile() {
  # NodeJS
  if [ $(commandExist 'node') == "1" ]; then
    dir="./source/3-writeToFile/node3.js"
    iterations=$WRITE_FILE_ITERATIONS
    title="NodeJS write to file"
    result=$(execution_block "$dir" "$iterations" "$title")
    node -v
    echo "$result"
  fi
}

rubyWriteToFile() {
  # RUBY
  if [ $(commandExist 'ruby') == "1" ]; then
    dir="./source/3-writeToFile/ruby3.rb"
    iterations=$WRITE_FILE_ITERATIONS
    title="RUBY write to file"
    result=$(execution_block "$dir" "$iterations" "$title")
    ruby -v
    echo "$result"
  fi
}

goWriteToFile() {
  # GO
  if [ $(commandExist 'go') == "1" ]; then
    go build -o ./compiled/go3 ./source/3-writeToFile/go3.go
    dir="./compiled/go3 ${SORT_ARRAY_ITR}"
    iterations=$WRITE_FILE_ITERATIONS
    title="GO write to file"
    result=$(execution_block "$dir" "$iterations" "$title")
    go version
    echo "$result"
  fi
}

swiftWriteToFile() {
  # Swift
  if [ $(commandExist 'swiftc') == "1" ]; then
    swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/3-writeToFile/swift3.swift -o ./compiled/swift3
    dir="./compiled/swift3"
    iterations=$WRITE_FILE_ITERATIONS
    title="Swift write to file"
    result=$(execution_block "$dir" "$iterations" "$title")
    swift -version
    echo "$result"
  fi
}

swiftPOSIXWriteToFile() {
  # Swift-POSIX
  if [ $(commandExist 'swiftc') == "1" ]; then
    swiftc -Ounchecked -whole-module-optimization -Xcc -O2 ./source/3-writeToFile/swift3-posix.swift -o ./compiled/swift3-posix
    dir="./compiled/swift3-posix"
    iterations=$WRITE_FILE_ITERATIONS
    title="Swift-POSIX write to file"
    result=$(execution_block "$dir" "$iterations" "$title")
    swift -version
    echo "$result"
  fi
}

rustWriteToFile() {
  # Rust
  if [ $(commandExist 'rustc') == "1" ]; then
    rustc -O ./source/3-writeToFile/rust3.rs -o ./compiled/rust3
    dir="./compiled/rust3"
    iterations=$WRITE_FILE_ITERATIONS
    title="Rust write to file"
    result=$(execution_block "$dir" "$iterations" "$title")
    rustc -V
    echo "$result"
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




sortArray
sortGlobalArray
writeToFile
