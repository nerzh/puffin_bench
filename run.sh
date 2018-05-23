./engine/engine.pl 'perl ./source/perl.pl'
./engine/engine.pl 'php ./source/php.php'
./engine/engine.pl 'node ./source/node.js'
./engine/engine.pl 'ruby ./source/ruby.rb'
swiftc -O ./source/swift.swift -o ./compiled/swift
./engine/engine.pl './compiled/swift'

# ./engine/engine.pl ./compiled/a.out
