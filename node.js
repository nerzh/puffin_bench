// var c;
// var b = 0;
// var d = "aaa.html";

// const fs = require('fs');

// var contents = fs.readFileSync('./file.txt', 'utf8');
// //console.log(contents);
// // var arr = contents.match(/valerich123/g);

// // for(c = 0; c < arr.length; c++) {
// //   b++;
// // }

// // //b = arr.length;

// console.log('node ' + b);

function shellsSort(arr) {
    let n    = arr.length
    let gap  = Math.floor(n/2)
    let i    = 0
    let j    = 0
    let temp = null
    
    while (gap > 0) {
        i = gap
        while (i < n) {
            temp = arr[i]
            j = i
            while (j >= gap && arr[j - gap] > temp) {
                arr[j] = arr[j - gap]
                j = j - gap
            }
            arr[j] = temp
            i = i + 1
        }
        gap = Math.floor(gap/2)
    }
}

var a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
var c;

for(c = 0; c < 10000000; c++){
  a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  // a = a.sort();
  shellsSort(a);
}

console.log('node 123');
