import { readFileSync } from 'fs';

const input: string[] = readFileSync('input/test.txt')
  .toString()
  .trim()
  .split(/\n/);

let stack: string[] = [];
let moves: string[] = [];
let i = 0;
while (i < input.length) {
  if (input[i] === '') {
    i++;
    continue;
  } else if (/^move/.test(input[i])) {
    moves.push(input[i]);
  } else {
    stack.push(input[i]);
  }
  i++;
}

console.log(stack);
console.log(moves);
