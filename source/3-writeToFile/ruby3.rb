#!/usr/bin/env ruby

def clearFile(path)
  File.open(path, File::WRONLY) do |file|
    file.truncate(0)
  end
end

count           = 0
path            = './store/ruby.txt'
templateString  = "test_text\n"
resultString    = ""
clearFile(path)

while (count < 8000000)
  resultString << templateString
  count += 1
end

File.open(path, File::WRONLY) do |file|
  file.write(resultString)
end

p 'RUBY write to file'
p `ruby -v`