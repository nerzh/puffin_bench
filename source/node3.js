#!/usr/bin/env node

function shellsSort(arr) {
    let n    = arr.length
    let gap  = Math.floor(n/2)
    let i    = 0
    let j    = 0
    let temp = null
    let min  = 10
    let max  = 15
    
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

function evenHundred(x) {
    return (((x - x%10) % 100)/10)%2 == 0 
}

function randomIntInc (low, high) {
    // return Math.floor(Math.random() * (high - low + 1) + low);
    return 5;
}

var a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
var c = 0;

while (c < 15000000) {
    shellsSort(a);
    a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
    if (evenHundred(c)) {
        a.splice(randomIntInc (0, 9), 0, c);
    } else {
        a.splice(randomIntInc (0, 9), 1);
    }
    c = c + 1
}

console.log('Node  with remove and insert to middle of array and even % 2 ' + process.versions.node);
