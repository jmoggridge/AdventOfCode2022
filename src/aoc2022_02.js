// Day 2: Rock Paper Scissors
import { readFileSync } from 'fs';

const games = readFileSync('input/input-02.txt').toString().trim().split('\n');

const scores = {
  A: { X: 4, Y: 8, Z: 3 },
  B: { X: 1, Y: 5, Z: 9 },
  C: { X: 7, Y: 2, Z: 6 }
};

const part1 = games
  .map((game) => {
    const [opponent, player] = game.split(' ');
    return scores[opponent][player];
  })
  .reduce((a, b) => a + b);

const scores2 = {
  A: { X: 3, Y: 4, Z: 8 },
  B: { X: 1, Y: 5, Z: 9 },
  C: { X: 2, Y: 6, Z: 7 }
};

const part2 = games
  .map((game) => {
    const [opponent, result] = game.split(' ');
    return scores2[opponent][result];
  })
  .reduce((a, b) => a + b);

console.log(part1);
console.log(part2);

console.log(part1 === 14531);
console.log(part2 === 11258);
