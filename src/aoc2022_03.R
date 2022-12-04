library(tidyverse)

tibble(
    x = read_lines('input/input-03.txt'),
    left = str_sub(x, 1, nchar(x) / 2),
    right =  str_sub(x, (nchar(x) / 2) + 1, -1L)
  ) |>
  mutate(
    across(c(left,right), ~map(., ~str_split(., '') |> pluck(1))),
    shared = map2_chr(left, right, intersect)
    ) |>
  left_join(enframe(c(letters, LETTERS)), by = c('shared' = 'value')) |>
  pull(name) |>
  sum()

