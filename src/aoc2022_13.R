# 13.R

library(tidyverse)

parse_input <- function(file) {
  file |>
    read_lines() |>
    keep(~ . != '') |>
    enframe() |>
    mutate(
      parsed = map(
        value,
        jsonlite::fromJSON,
        simplifyVector = F,
        simplifyMatrix = F,
        flatten = F
      ),
      pair = ((name - 1) %/% 2) + 1,
      lr = rep(c('left', 'right'), times = max(pair))
    )
}

parse_input2 <- function(file) {
  file |>
    read_lines() |>
    keep(~ . != '') |>
    append(c('[[2]]', '[[6]]')) |>
    enframe() |>
    mutate(
      parsed = map(
        value,
        jsonlite::fromJSON,
        simplifyVector = F,
        simplifyMatrix = F,
        flatten = F
      )
    )
}

both_numbers <- function(x, y) {
  all(is.numeric(x), length(x) == 1,
      is.numeric(y), length(y) == 1)
}
both_lists <- function(x, y) {
  all(is.list(x), length(x) > 0, is.list(y), length(y) > 0)
}
left_is_list_right_is_not <- function(x, y) {
  all(is.list(x), length(x) > 0, !is.list(y), length(y) > 0)
}
right_is_list_left_is_not <- function(x, y) {
  all(!is.list(x), length(x) > 0, is.list(y), length(y) > 0)
}

is_ints_ordered <- function(x, y) {
  if (x < y) {
    return(TRUE)
  } else if (x > y) {
    return(FALSE)
  } else {
    return(NA)
  }
}

is_empty_list <- function(x) {
  identical(x, list())
}


compare_lists <- function(left, right) {
  if (is_empty_list(left) & !is_empty_list(right)) {
    return(TRUE)
  } else if (!is_empty_list(left) & is_empty_list(right)) {
    return(FALSE)
  } else if (is_empty_list(left) & is_empty_list(right)) {
    return(NA)
  } else if (both_numbers(left, right)) {
    return(is_ints_ordered(left, right))
  } else if (both_lists(left, right)) {
    i <- 1
    while (i <= min(length(left), length(right))) {
      result <-  compare_lists(left[[i]], right[[i]])
      if (!is.na(result))
        return(result)
      i <- i + 1
    }
    if (i > length(left) & i <= length(right)) {
      return(TRUE)
    } else if (i > length(right) & i <= length(left)) {
      return(FALSE)
    } else {
      return(NA)
    }
  } else if (right_is_list_left_is_not(left, right)) {
    return(compare_lists(list(left), right))
  } else if (left_is_list_right_is_not(left, right)) {
    return(compare_lists(left, list(right)))
  }
}

# part 2
qsort_df <- function(df) {
  if (nrow(df) <= 1) return(df)
  pivot <- df |> slice_head(n = 1)
  rest <- df |>
    slice_tail(n = -1) |>
    mutate(greater_than = map_lgl(parsed, ~compare_lists(pivot$parsed[[1]], .)))

  bind_rows(
    rest |> filter(!greater_than) |> qsort_df(),
    pivot,
    rest |> filter(greater_than) |> qsort_df()
  )
}

# part 1 solution: 5252
part1 <- parse_input('input/input-13.txt') |>
  pivot_wider(
    id_cols = pair,
    names_from = lr,
    values_from = c(value, parsed)
  ) |>
  mutate(res = map2_lgl(parsed_left, parsed_right, compare_lists)) |>
  filter(res) |>
  pull(pair) |>
  sum() |>
  print()

part1 == 5252

# part 2 solution: 20592
part2 <-  'input/input-13.txt' |>
  parse_input2() |>
  qsort_df() |>
  mutate(index = row_number()) |>
  filter(value %in% c('[[2]]', '[[6]]')) |>
  pull(index) |>
  prod() |>
  print()

part2 == 20592


