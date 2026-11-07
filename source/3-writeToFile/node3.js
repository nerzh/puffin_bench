#!/usr/bin/env node
'use strict';
const fs = require('fs');
function argument(index, fallback) {
    const value = process.argv[index] === undefined ? fallback : Number(process.argv[index]);
    if (!Number.isInteger(value) || value < 0 || value > 2147483647) throw new Error('Invalid count');
    return value;
}
function run(iterations) {
    const template = 'test_text\n';
    let result = '';
    let count = 0;
    while (count < iterations) {
        result += template;
        count = count + 1;
    }
    fs.writeFileSync('./store/node.txt', result);
    return result.length; // All characters in this workload are single-byte UTF-8.
}
if (process.argv.length > 4) throw new Error('lines [warmup_lines]');
const iterations = argument(2, 80000000);
const warmup = argument(3, 10000);
const warmupBytes = run(warmup);
const start = process.hrtime.bigint();
const bytes = run(iterations);
const elapsed = process.hrtime.bigint() - start;
console.log(`elapsed_ns=${elapsed} bytes=${bytes} warmup_bytes=${warmupBytes}`);
