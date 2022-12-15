# aoc2022_12.R
library(tidyverse)

parse_topo <- function(file){
  lookup <-
    c('S', letters, 'E') |>
    enframe(name = 'height') |>
    mutate(height = height - 1)
  rows <-
    read_lines(file) |>
    map(~strsplit(., split = '') |> unlist()) |>
    enframe() |>
    unnest(value) |>
    left_join(lookup, by = 'value')
  return(matrix(rows$height, nrow = max(rows$name), byrow = T))
}

get_start_point <- function(topo, height) {
  lst(
    i = which(topo == height) %% nrow(topo),
    j = 1 + (which(topo == height) %/% nrow(topo)),
    steps = 0,
    height = height
  )
}

neighbors <- function(current, topo, steps){
  i <- current$i
  j <- current$j
  lst(
    down   = lst(i = i + 1, j = j),
    up     = lst(i = i - 1, j = j),
    left   = lst(i = i,     j = j - 1),
    right  = lst(i = i,     j = j + 1),
  ) |>
    keep(~all(.$i > 0, .$j > 0, .$i <= nrow(topo), .$j <= ncol(topo))) |>
    keep(~steps[.$i, .$j] > current$steps + 1) |>
    map(~list_modify(., height = topo[.$i, .$j], steps = current$steps + 1))
}

forward_neighbors <- function(current, topo, steps){
  neighbors(current, topo, steps) |>
    keep(~.$height <= current$height + 1)
}
backward_neighbors <- function(current, topo, steps){
  neighbors(current, topo, steps) |>
    keep(~.$height >= current$height - 1)
}

curry_bfs <- function(neighbors_fn, start_height){
  return(
    function(x){
      start <- get_start_point(x, start_height)
      queue <- lst(start)
      steps <- matrix(Inf, nrow = nrow(x), ncol = ncol(x))
      steps[start$i, start$j] <- 0
      while (length(queue) > 0) {
        current <- queue[[1]]
        queue <- queue[-1]
        neighbors <- neighbors_fn(current, x, steps)
        walk(neighbors, ~{steps[.$i, .$j] <<- .$steps})
        queue <- append(queue, neighbors)
      }
      return(steps)
    }
  )
}

topo <- parse_topo('input/input-12.txt')

steps <- curry_bfs(forward_neighbors, start_height = 0)(topo)
sol1 <- steps[which(topo == 27)]
print(paste('Part 1:', sol1)) # 408

steps2 <- curry_bfs(backward_neighbors, start_height = 27)(topo)
sol2 <- steps2[which(topo == 1)] |> min()
print(paste('Part 2:', sol2)) # 399
