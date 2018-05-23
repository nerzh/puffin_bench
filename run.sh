# ./engine/engine.pl './source/perl.pl'
# ./engine/engine.pl './source/perl2.pl'
./engine/engine.pl './source/php.php'
./engine/engine.pl './source/php2.php'
./engine/engine.pl './source/node.js'
./engine/engine.pl './source/node2.js'
./engine/engine.pl './source/ruby.rb'
./engine/engine.pl './source/ruby2.rb'
./engine/engine.pl './source/python.py'
./engine/engine.pl './source/python2.py'
swiftc -O ./source/swift.swift -o ./compiled/swift
swiftc -O ./source/swift2.swift -o ./compiled/swift2
./engine/engine.pl './compiled/swift'
./engine/engine.pl './compiled/swift2'

# ./engine/engine.pl ./compiled/a.out
