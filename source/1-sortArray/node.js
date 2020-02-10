#!/usr/bin/env node

function shellsSort(arr) {
  let n    = arr.length;
  let gap  = Math.floor(n/2);
  let i    = 0;
  let j    = 0;
  let temp = null;
  
  while (gap > 0) {
    i = gap
    while (i < n) {
      temp = arr[i]
      j    = i
      while (j >= gap && arr[j - gap] > temp) {
        arr[j] = arr[j - gap]
        j      = j - gap
      }
      arr[j] = temp
      i      = i + 1
    }
    gap = Math.floor(gap/2)
  }
}

function main() {
  var arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  var c   = 0;
  var c2  = 0;
  var i   = process.argv[2];
  
  while (c < i) {
    while(c2 < 10) {
      arr[c2] = 9 - c2;
      c2 = c2 + 1;
    }
    shellsSort(arr);
    c  = c + 1;
    c2 = 0;
  }  
}

main()

// console.log('version: ' + process.versions.node);
