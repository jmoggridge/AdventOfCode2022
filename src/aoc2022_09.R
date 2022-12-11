# aoc2022_09.R
library(tidyverse)

moves <- lst(
  R  = c( 1,  0),
  L  = c(-1,  0),
  U  = c( 0,  1),
  D  = c( 0, -1),
  RU = c( 1,  1),
  LU = c(-1,  1),
  RD = c( 1, -1),
  LD = c(-1, -1)
)

tail_moves <- tribble(
  ~x, ~y, ~move,
   2,  0, 'R',
   2,  1, 'RU',
   2,  2, 'RU',
   2, -1, 'RD',
   2, -2, 'RD',
  -2,  0, 'L',
  -2,  1, 'LU',
  -2,  2, 'LU',
  -2, -1, 'LD',
  -2, -2, 'LD',
   0,  2, 'U',
   1,  2, 'RU',
  -1,  2, 'LU',
   0, -2, 'D',
   1, -2, 'RD',
  -1, -2, 'LD',
) |>
  transmute(
    value = map(move, ~moves[[.]]),
    name = str_glue('{x},{y}')
  )

tail_move_hash <- tail_moves$value |> set_names(tail_moves$name)


find_head_path <- function(input){
  input |>
    accumulate(.f = ~.x + .y, init = c(0, 0)) |>
    prepend(list(c(x = 0, y = 0)))
}

find_tail_path <- function(head_path){
  tail_move <- function(tail, head) {
    dif <- head - tail
    if (all(abs( dif ) <= 1)) return(tail)
    tail + tail_move_hash[[str_glue('{dif[1]},{dif[2]}')]]
  }
  head_path |> accumulate(.f = ~tail_move(.x, .y), init = c(0, 0))
}

input <-
  read_lines('input/input-09.txt') |>
  map(~rep(str_extract(., '[A-Z]'), times = parse_number(.))) |>
  flatten_chr() |>
  map(~moves[[.]])

tail_path <- input |> find_head_path() |> find_tail_path()

# part 1
tail_path |> unique() |> length()

# part 2
for (i in 1:8) {
  tail_path <- find_tail_path(tail_path)
}
tail_path |> unique() |> length()




