./engine/engine.pl 'perl ./source/perl.pl'
./engine/engine.pl 'perl ./source/perl2.pl'
./engine/engine.pl 'perl ./source/perl3.pl'
./engine/engine.pl 'php ./source/php.php'
./engine/engine.pl 'php ./source/php2.php'
./engine/engine.pl 'node ./source/node.js'
./engine/engine.pl 'node ./source/node2.js'
./engine/engine.pl 'ruby ./source/ruby.rb'
./engine/engine.pl 'ruby ./source/ruby2.rb'
swiftc -O ./source/swift.swift -o ./compiled/swift
swiftc -O ./source/swift2.swift -o ./compiled/swift2
./engine/engine.pl './compiled/swift'
./engine/engine.pl './compiled/swift2'

# ./engine/engine.pl ./compiled/a.out
