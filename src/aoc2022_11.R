library(tidyverse)

file <- 'input/input-11.txt'
# file <- 'input/test.txt'

notes <-
  readr::read_file(file) |>
  str_split(pattern = '\n\n') |>
  unlist() |>
  map( ~ str_split(.x, '\n') |> unlist()) |>
  map_dfr( ~ {
    lst(
      monkey   = parse_number(.[1]) + 1,
      items    = str_extract_all(.[2], '[0-9]+') |> map(as.numeric),
      worry    = str_remove(.[3], 'Operation: new =') |> str_trim(),
      test     = parse_number(.[4]),
      if_true  = parse_number(.[5]) + 1,
      if_false = parse_number(.[6]) + 1,
    )
  }) |>
  group_by(monkey) |>
  nest(behaviour = c(worry, test, if_true, if_false))

monkey_business1 <- function(rounds, worry_reduction = 3) {
  monkey_counter <- rep(0, nrow(notes))

  keepaway <- function(notes, i, worry_reduction) {
    monkey <- notes$behaviour[[i]]
    for (old in notes$items[[i]]) {
      monkey_counter[[i]] <<- monkey_counter[[i]] + 1
      new_item <-
        (eval(parse(text = monkey$worry)) / worry_reduction) %/% 1
      test_rs <- new_item %% monkey$test == 0
      if (test_rs) {
        notes$items[[monkey$if_true]] <-
          c(notes$items[[monkey$if_true]], new_item)
      } else {
        notes$items[[monkey$if_false]] <-
          c(notes$items[[monkey$if_false]], new_item)
      }
    }
    notes$items[[i]] <- numeric(length = 0L)
    return(notes)
  }

  for (round in 1:20) {
    for (monkey in seq(1:nrow(notes))) {
      notes <- keepaway(notes, monkey, worry_reduction)
    }
  }
  return(monkey_counter)
}


monkey_business2 <- function(notes, rounds) {
  keepaway <- function(notes, i, modular_size) {
    monkey <- notes$behaviour[[i]]
    for (old in notes$items[[i]]) {
      monkey_counter[[i]] <<- monkey_counter[[i]] + 1
      new <-
        (eval(parse(text = monkey$worry)) |> round(0)) %% modular_size
      test_rs <- new %% monkey$test == 0L
      if (test_rs) {
        notes$items[[monkey$if_true]] <-
          c(notes$items[[monkey$if_true]], new)
      } else {
        notes$items[[monkey$if_false]] <-
          c(notes$items[[monkey$if_false]], new)
      }
    }
    notes$items[[i]] <- numeric(length = 0L)
    return(notes)
  }

  modular_size <- notes |>
    unnest(behaviour) |>
    pull(test) |>
    prod()

  monkey_counter <- rep(0, nrow(notes))

  for (round in 1:rounds) {
    for (monkey in seq(1:nrow(notes))) {
      notes <- keepaway(notes, monkey, modular_size)
    }
  }
  return(monkey_counter)
}

# 88208
monkey_business1(rounds = 20, worry_reduction = 3) |>
  sort(decreasing = T) |>
  head(2) |>
  prod() |>
  print()

# 21115867968
monkey_business2(notes, rounds = 10000) |>
  sort(decreasing = T) |>
  head(2) |>
  prod() |>
  print()
