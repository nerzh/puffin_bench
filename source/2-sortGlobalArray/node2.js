#!/usr/bin/env node
'use strict';

class Sorter {
    constructor() { this.arr = new Float64Array(100); }
shellsSort() {
    let gap = Math.floor(this.arr.length / 2);
    while (gap > 0) {
        let i = gap;
        while (i < this.arr.length) {
            const temp = this.arr[i];
            let j = i;
            while (j >= gap && this.arr[j - gap] > temp) {
                this.arr[j] = this.arr[j - gap];
                j = j - gap;
            }
            this.arr[j] = temp;
            i = i + 1;
        }
        gap = Math.floor(gap / 2);
    }
}
run(iterations, seed) {
    let state = seed;
    let checksum = 0;
    let c = 0;
    while (c < iterations) {
        let k = 0;
        while (k < this.arr.length) {
            state = (state * 1664525 + 1013904223) & 2147483647;
            this.arr[k] = (state >> 8) & 65535;
            k = k + 1;
        }
        this.shellsSort();
        k = 0;
        while (k < this.arr.length) {
            checksum = (checksum * 31 + this.arr[k]) & 2147483647;
            k = k + 1;
        }
        c = c + 1;
    }
    return checksum;
}
}
function argument(index, fallback) {
    const value = process.argv[index] === undefined ? fallback : Number(process.argv[index]);
    if (!Number.isInteger(value) || value < 0 || value > 2147483647) {
        throw new Error('Arguments must be in 0..2147483647');
    }
    return value;
}
if (process.argv.length < 3 || process.argv.length > 5) throw new Error('iterations [seed [warmup]]');
const iterations = argument(2, 0);
const seed = argument(3, 12345);
const warmup = argument(4, 10000);
const sorter = new Sorter();
const warmupChecksum = sorter.run(warmup, seed);
const start = process.hrtime.bigint();
const checksum = sorter.run(iterations, seed);
const elapsed = process.hrtime.bigint() - start;
console.log(`elapsed_ns=${elapsed} checksum=${checksum} warmup_checksum=${warmupChecksum}`);
