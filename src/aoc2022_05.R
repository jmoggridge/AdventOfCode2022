library(tidyverse)

parse_crates <- function(input) {
  input |>
    purrr::head_while(~ !str_detect(., '[0-9a-z]')) |>
    map(
      ~ .x |>
        str_sub(start = seq(1, nchar(.x), 4), end = seq(3, nchar(.x), 4)) |>
        str_trim() |>
        str_extract('[A-Z]') |>
        set_names(
          paste0('x_', seq(1, (nchar(input[1]) + 1) / 4, 1))
        )
    ) |>
    tibble() |>
    unnest_wider(1) |>
    as.list() |>
    map(~.x |> keep(~ !is.na(.x)) |> rev())
}

parse_moves <- function(input) {
  tibble(lines = input |> purrr::tail_while(~ . != "")) |>
    mutate(
      digits = map(
        .x = lines,
        .f = ~ .x |>
          str_extract_all('[0-9]+') |>
          flatten() |>
          map(as.numeric) |>
          set_names(c('crates', 'from', 'to')) |>
          as_tibble_row()
      )
    ) |>
    unnest(digits)
}

make_move <- function(crates, move, stacker) {
  moving_crates <- crates[[move$from]] |> stacker(move$crates)
  crates[[move$from]] <-
    head(crates[[move$from]], -move$crates)
  crates[[move$to]] <-
    append(crates[[move$to]], moving_crates)
  return(crates)
}

rearrange_crates <- function(crates, moves, peeker) {
  i = 1
  while (i <= nrow(moves)) {
    crates <- make_move(crates, move = moves[i, ], peeker)
    i <- i + 1
  }
  return(crates)
}

inputfile <- "input/input-05.txt"
input <- read_lines(here::here(inputfile))
moves <- parse_moves(input)
crates <-
  input |>
  parse_crates()

part1_ans <- crates |>
  rearrange_crates(moves, \(x, n) tail(x, n) |> rev()
                   ) |>
  map_chr(~ tail(.x, 1)) |>
  reduce(str_c)

part2_ans <- crates |>
  rearrange_crates(moves, \(x, n) tail(x, n)) |>
  map_chr(~ tail(.x, 1)) |>
  reduce(str_c)

print(paste('Part 1:', part1_ans))
print(paste('Part 2:', part2_ans))
