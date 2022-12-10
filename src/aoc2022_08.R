# aoc2022_08.R
library(tidyverse)

trees_in_nswe_dirs <- function(i, j, forest) {
  lst(north = forest[(i - 1):1, j],
      south = forest[(i + 1):ncol(forest), j],
      west = forest[i, (j - 1):1],
      east = forest[i, (j + 1):ncol(forest)])
}

is_border_tree <- function(i, j, forest) {
  (i %in% c(1, nrow(forest)) | j %in% c(1,ncol(forest)))
}

is_tree_visible <- function(i, j, forest) {
  if (is_border_tree(i, j, forest)) {
    return(TRUE)
  }
  trees_in_nswe_dirs(i, j, forest) |>
    map_dbl(max) |>
    map_lgl(~.x < forest[i,j]) |>
    any()
}

forest <-
  read_lines('input/input-08.txt') |>
  # read_lines('input/test.txt') |>
  map(strsplit, '') |>
  unlist() |>
  as.numeric() |>
  {\(x) matrix(x, nrow = sqrt(length(x)), ncol = sqrt(length(x)), byrow = T)}()

part1 <-
  crossing(i = seq(ncol(forest)), j = i) |>
  mutate(visibility = map2_lgl(i, j, ~is_tree_visible(.x, .y, forest))) |>
  pull(visibility) |>
  sum()

visible_trees <- function(trees, tree) {
  visible <- trees |> head_while(~. < tree) |> length()
  if (visible < length(trees)) {
    return(visible + 1)
  }
  return(visible)
}

scenic_score <- function(i, j, forest){
  if (is_border_tree(i, j, forest)) {
    return(0)
  }
  tree <- forest[i, j]
  trees_in_nswe_dirs(i, j, forest) |>
    map_dbl(~visible_trees(., tree)) |>
    prod()
}
part2 <- crossing(i = seq(ncol(forest)), j = i) |>
  mutate(score = map2_dbl(i, j, ~scenic_score(.x, .y, forest))) |>
  filter(score == max(score)) |>
  pull(score)


print(part1)
print(part2)