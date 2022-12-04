import { readFileSync } from "fs";

const input: number[][][] = readFileSync('input/input-04.txt')
    .toString()
    .trim()
    .split(/\n/)
    .map((pair) => pair
        .split(',')
        .map((elf) =>
            elf.split('-').map((i) => Number(i))
        ));

// check  if a in c:d or b in c:d
const nestedPairs: number = input.filter((pair) => {
    const [[a, b], [c, d]] = pair;
    return (a <= c && b >= d) || (a >= c && b <= d);
}).length;

// check if any: { a in c:d, b in c:d, or c in a:b }
const overlappingPairs: number = input.filter((pair) => {
    const [[a, b], [c, d]] = pair;
    const leftStart: boolean = a >= c && a <= d;
    const leftStop: boolean = b >= c && b <= d;
    const rightStart: boolean = c >= a && c <= b;
    return leftStart || leftStop || rightStart
}).length;
    
console.log('Part 1:', nestedPairs, ' -- Ans: 530'); // 530
console.log('Part 2:', overlappingPairs, ' -- Ans 903'); // 903
