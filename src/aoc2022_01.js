// --- Day 1: Calorie Counting ---
import { readFileSync } from 'fs';

const star1 = readFileSync('input-01.txt')
  .toString()
  .split('\n\n')
  .map((elf) =>
    elf
      .split(/[^0-9]/)
      .filter((food) => food !== '')
      .reduce((sum, food) => sum + parseInt(food), 0)
  )
  .sort((a, b) => a - b)
  .reverse();

const star2 = star1.slice(0, 3).reduce((a, b) => a + b, 0);

console.log('solution part 1: most calorific elf', star1[0]);
console.log('solution part 2: top three elves', star2);
