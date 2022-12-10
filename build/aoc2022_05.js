"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const input = (0, fs_1.readFileSync)('input/test.txt')
    .toString()
    .trim()
    .split(/\n/);
let stack = [];
let moves = [];
let i = 0;
while (i < input.length) {
    console.log(i);
    console.log(input[i]);
    if (input[i] === '') {
        i++;
        continue;
    }
    else if (/^move/.test(input[i])) {
        moves.push(input[i]);
    }
    else {
        stack.push(input[i]);
    }
    i++;
    console.log(/^move/.test(input[i]));
    //   //   if (input[i] === '') continue;
    //   if () {
    //     moves.push(input[i]);
    //   } else {
    //     stack.push(input[i]);
    //   }
}
console.log(stack);
console.log(moves);
