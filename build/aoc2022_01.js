"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// --- Day 1: Calorie Counting ---
const fs_1 = require("fs");
const star1 = (0, fs_1.readFileSync)('input/input-01.txt')
    .toString()
    .split('\n\n')
    .map((elf) => elf
    .split(/[^0-9]/)
    .map(Number)
    .reduce((a, b) => a + b))
    .sort((a, b) => a - b)
    .reverse();
const star2 = star1.slice(0, 3).reduce((a, b) => a + b, 0);
console.log('solution part 1: most calorific elf', star1[0]);
console.log('solution part 2: top three elves', star2);
