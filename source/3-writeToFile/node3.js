#!/usr/bin/env node

var fs = require('fs');

function clearFile(path) {
    fs.writeFile(path, '', (err) => {  
        if (err) throw err;
    });
}

var count           = 0;
var path            = './store/node.txt';
var templateString  = "test_text\n";
var resultString    = ""
clearFile(path);


fs.open(path, "a+", function(error, fd) {
  if (error) {
    console.error("open error:  " + error.message);
  } else {
    while (count < 8000000) {
        resultString += templateString
        count += 1
    }
    fs.write(fd, resultString, ()=>{})
  }
});

console.log('Node ' + process.versions.node + ' write to file');
