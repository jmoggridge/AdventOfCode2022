"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const alpha = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
function intersect(a, b) {
    const A = [...new Set(a)];
    const B = [...new Set(b)];
    return A.filter((a) => B.includes(a));
}
const input = (0, fs_1.readFileSync)('input/input-03.txt').toString().trim().split(/\n/);
const sumOfShareds = input
    .map((sack) => {
    const len = sack.length;
    const left = sack.substring(0, len / 2).split('');
    const right = sack.substring(len / 2, len).split('');
    const shared = intersect(left, right)[0];
    return alpha.indexOf(shared) + 1;
})
    .reduce((a, b) => a + b);
console.log(sumOfShareds);
console.log('Correct ans: 7821', sumOfShareds === 7821);
const groupedElfs = input.reduce((elfGroup, elf, index) => {
    const groupIndex = Math.floor(index / 3);
    if (!elfGroup[groupIndex]) {
        elfGroup[groupIndex] = [elf];
    }
    else {
        elfGroup[groupIndex].push(elf);
    }
    return elfGroup;
}, []);
const badgesSum = groupedElfs.map((group) => {
    const [a, b, c] = group.map((x) => x.split(''));
    const badge = intersect(intersect(a, b), c)[0];
    const priority = alpha.indexOf(badge) + 1;
    return priority;
}).reduce((a, b) => a + b);
console.log(badgesSum);
console.log('Correct ans: 2752', badgesSum === 2752);
