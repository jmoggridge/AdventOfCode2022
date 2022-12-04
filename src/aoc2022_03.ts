import { readFileSync } from 'fs';

const alpha: string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

function intersect(a: string[], b: string[]): string[] {
  const A: string[] = [...new Set(a)];
  const B: string[] = [...new Set(b)];
  return A.filter((a) => B.includes(a));
}

const input: string[] = readFileSync('input/input-03.txt').toString().trim().split(/\n/);

const sumOfShareds: number = input
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


const groupedElfs: string[][] = input.reduce((elfGroup: any[], elf: string, index: number) => {
    const groupIndex: number = Math.floor(index / 3)
    if (!elfGroup[groupIndex]) {
        elfGroup[groupIndex] = [elf]
    } else {
        elfGroup[groupIndex].push(elf)
    }
    return elfGroup
}, <string[]>[])

const badgesSum: number = groupedElfs.map((group) => {
    const [a, b, c] = group.map((x) => x.split(''))
    const badge: string = intersect(intersect(a, b), c)[0];
    const priority: number = alpha.indexOf(badge) + 1;
    return priority
}).reduce((a,b)=> a + b);


console.log(badgesSum);
console.log('Correct ans: 2752', badgesSum === 2752);
