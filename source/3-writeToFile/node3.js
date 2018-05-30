#!/usr/bin/env node

var fs = require('fs');

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

function evenHundred(x) {
    return (((x - x%10) % 100)/10)%2 == 0 
}

function randomIntInc (low, high) {
    return Math.floor(Math.random() * (high - low + 1) + low);
    // return 5;
}

function revertArray(a) {
    let c  = 0
    let l  = a.length
    let li = 0
    let t  = null
    while (c <= l/2) {
        t            = a[c]
        a[c]         = a[(l-1) - c]
        a[(l-1) - c] = t
        c            = c + 1
    }
}

function iterateArray(a) {
    let c = 0
    let l = a.length
    while (c < l) {
        a.push(a.splice(0, 1)[0])
        c = c + 1
    }
}

function makeRandomArray(x) {
    var arr = []
    var c   = 0
    while (c < x) {
        arr.push(randomIntInc(0, 9))
        c = c + 1
    }
    return arr
}

function clearFile(path) {
    fs.writeFile(path, '', (err) => {  
        if (err) throw err;
    });
}

function writeString(path, text) {
    fs.appendFile(path, text, function (err) {
        if (err) throw err;
    });
}


// var a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
var a = makeRandomArray(10);
var c = 0;
var p = './store/node.txt';
var s = "./store/swift.txt\n";
clearFile(p);

// while (c < 2000000) {
while (c < 20000) {
    // shellsSort(a);
    // writeString(p, `[${a.join(', ')}]\n`)
    writeString(p, s)
    // a = makeRandomArray(10);
    // revertArray(a);
    // writeString(p, `[${a.join(', ')}]\n`)
    // a = makeRandomArray(10);
    // iterateArray(a);
    // writeString(p, `[${a.join(', ')}]\n`)

    // if (evenHundred(c)) {
    //     a.splice(randomIntInc (0, 9), 0, c);
    // } else {
    //     a.splice(randomIntInc (0, 9), 1);
    // }
    c = c + 1
}

console.log('Node ' + process.versions.node + ' with remove and insert to array and write to file');
