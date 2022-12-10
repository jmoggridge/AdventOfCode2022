"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const input = (0, fs_1.readFileSync)('input/input-04.txt')
    .toString()
    .trim()
    .split(/\n/)
    .map((pair) => pair
    .split(',')
    .map((elf) => elf.split('-').map((i) => Number(i))));
// check  if a in c:d or b in c:d
const nestedPairs = input.filter((pair) => {
    const [[a, b], [c, d]] = pair;
    return (a <= c && b >= d) || (a >= c && b <= d);
}).length;
// check if any: { a in c:d, b in c:d, or c in a:b }
const overlappingPairs = input.filter((pair) => {
    const [[a, b], [c, d]] = pair;
    const leftStart = a >= c && a <= d;
    const leftStop = b >= c && b <= d;
    const rightStart = c >= a && c <= b;
    return leftStart || leftStop || rightStart;
}).length;
console.log('Part 1:', nestedPairs, ' -- Ans: 530'); // 530
console.log('Part 2:', overlappingPairs, ' -- Ans 903'); // 903
