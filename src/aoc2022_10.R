library(tidyverse)

input <-
  tibble(x = read_lines('input/input-10.txt')) |>
  transmute(
    cmd = str_extract(x, '[^\\s]+'),
    dx = parse_number(x) |> replace_na(0) |> suppressWarnings(),
    cycle_x = map2(cmd, dx, ~{
      if (.x == 'noop') return(0)
      c(0, .y)
    })
  ) |>
  unnest(cycle_x) |>
  transmute(
    cycle = row_number(),
    register = lag(1 + accumulate(cycle_x, ~.x + .y)),
    signal_strength = cycle * register
  )

# 16880
part1 <- input |>
  filter(cycle %in% c(20, seq(60, 220, 40))) |>
  pull(signal_strength) |>
  sum() |> print()

# RKAZAJB
part2 <- input |>
  mutate(
    register = replace_na(register, 1),
    position = (cycle - 1) %% 40,
    pixel = map2_chr(position, register,
                     ~if_else(.x %in% (.y - 1):(.y + 1),  '#', '.')
                     ),
    row = rep(1:6, each = 40)
  ) |>
  group_by(row) |>
  summarise(pixels = list(pixel)) |>
  transmute(crt = map_chr(pixels, ~paste0(.x, collapse = '') |>
                         str_replace_all('\\.', ' '))
  ) |> print()
