# --- Day 14: Regolith Reservoir ---

library(tidyverse)

plot_cave <- function(cave){

  cave |>
    bind_rows(list(x = 500, y = 0, fill = 'source')) |>
    ggplot(aes(x, y, fill = fill)) +
    geom_tile(color = 'white', width = 1, height = 1) +
    scale_y_reverse(breaks = scales::pretty_breaks()) +
    scale_x_continuous(breaks = scales::pretty_breaks()) +
    coord_equal(expand = T) +
    scale_fill_manual(values = c('#997799', '#fa9900',  '#00aaff')) +
    theme_void() +
    scale_shape(solid = F) +
    labs(title = 'Cave') +
    theme(panel.background = element_blank(),
          panel.grid.major = element_blank())
}

find_points <- function(x_start, x_end, y_start, y_end){
  crossing(x = seq(x_start, x_end), y = seq(y_start, y_end))
}

sand_string <- function(x, y) paste0(x, '_', y)

parse_cave <- function(file){
  tibble(line = read_lines(file)) |>
    mutate(i = row_number(),
           lines = map(line, ~flatten(str_split(., ' -> ')))) |>
    unnest_longer(lines) |>
    separate(lines, into = c('x_start', 'y_start'), sep = ',') |>
    group_by(i) |>
    mutate(x_end = lag(x_start),
           y_end  = lag(y_start)) |>
    ungroup() |>
    filter(!is.na(x_end)) |>
    mutate(points = pmap(list(x_start, x_end, y_start, y_end),
                         find_points)) |>
    pull(points) |>
    bind_rows() |>
    mutate(fill = 'rock', string = sand_string(x, y))
}

move_sand <- function(sand, cave){
  x <- sand$x; y <- sand$y
  squares <- sand_string(x = c(x, x - 1, x + 1), y = y + 1)
  moves <- (!squares %in% cave$string)
  if (moves[1]) {
    list_modify(sand, y = y + 1)
  } else if (moves[2]) {
    list_modify(sand, x = x - 1, y = y + 1)
  } else if (moves[3]) {
    list_modify(sand, x = x + 1, y = y + 1)
  } else {
    NULL
  }
}


fill_cave <- function(cave){

  lowest_rock <- max(cave$y)
  overflow <- F
  start_sand <- list(x = 500, y = 0, fill = 'sand')

  while (!overflow) {
    sand <- start_sand
    while (!overflow) {
      new_sand <- move_sand(sand, cave)
      if (is.null(new_sand)) break
      if (new_sand$y > lowest_rock) {
        overflow = T
        break
      }
      sand <- new_sand
    }
    if (!overflow) {
      sand$string <- sand_string(sand$x, sand$y)
      cave <- bind_rows(cave, sand)
    }
  }
  cave
}

cave <- parse_cave('input/input-14.txt')

# part 1: 1078
cave |>
  fill_cave() |>
  filter(fill != 'rock') |>
  nrow() |>
  print()




## part 2 with floor

move_sand2 <- function(sand, cave, floor){

  x <- sand$x; y <- sand$y
  if (y == (floor - 1)) return(NULL)

  squares <- sand_string(x = c(x, x - 1, x + 1), y = y + 1)
  moves <- (!squares %in% cave$string)

  if (moves[1]) {
    list_modify(sand, y = y + 1)
  } else if (moves[2]) {
    list_modify(sand, x = x - 1, y = y + 1)
  } else if (moves[3]) {
    list_modify(sand, x = x + 1, y = y + 1)
  } else {
    NULL
  }
}


fill_cave2 <- function(cave){

  floor <- max(cave$y) + 2
  start_sand <- list(x = 500, y = 0, fill = 'sand')
  filled_cave <- FALSE

  while (!filled_cave) {
    sand <- start_sand
    while (!filled_cave) {
      new_sand <- move_sand2(sand, cave, floor)
      if (is.null(new_sand)) {
        if (identical(sand, start_sand)) filled_cave <- T
        break
      }
      sand <- new_sand
    }
    sand$string <- sand_string(sand$x, sand$y)
    cave <- bind_rows(cave, sand)
  }
  cave
}

# incredibly slow...
filled_cave2 <- fill_cave2(cave)
filled_cave2 |> filter(fill == 'sand') |> nrow()

plot_cave(filled_cave2)

beepr::beep()
