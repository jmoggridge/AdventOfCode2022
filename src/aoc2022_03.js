"use strict";
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
exports.__esModule = true;
var fs_1 = require("fs");
var alpha = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
function intersect(a, b) {
    var A = __spreadArray([], new Set(a), true);
    var B = __spreadArray([], new Set(b), true);
    return A.filter(function (a) { return B.includes(a); });
}
var input = (0, fs_1.readFileSync)('input/input-03.txt').toString().trim().split(/\n/);
var splits = input
    .map(function (sack) {
    var left = sack.substring(0, sack.length / 2).split('');
    var right = sack.substring(sack.length / 2, sack.length).split('');
    var shared = intersect(left, right)[0];
    return alpha.indexOf(shared) + 1;
})
    .reduce(function (a, b) { return a + b; });
console.log(input);
console.log(splits);
// import { readFileSync } from 'fs';
// import { isUndefined } from 'util';
// const sacks: { left: string[], right: string[] }[]  = readFileSync('input/input-03.txt')
//     .toString()
//     .trim()
//     .split(/\n/)
//     .map((sack) => {
//         const mid: number = sack.length/2;
//         return {
//             left: sack.slice(0, mid-1).split(''),
//             right: sack.slice(mid).split('')
//         }
//     })
// const duplicated: string[] = sacks.map((sack) => {
//     const left: string[] = [...new Set(sack.left)];
//     const right: string[] = [...new Set(sack.right)];
//     const intersect: string = right.filter(
//         (a) => left.includes(a)
//         )[0];
//     return intersect
// })
// const alpha: string[] =
//     'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
// console.log(alpha.length);
// const sol: number[] = duplicated.map((x) => alpha.indexOf(x) + 1)
// const solution = sol.reduce((a,b) => a+b)
// // console.log(sacks);
// console.log('duplicated',duplicated)
// console.log('sol',sol)
// console.log('sol',solution)
