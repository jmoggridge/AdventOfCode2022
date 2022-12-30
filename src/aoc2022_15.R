# --- Day 15: Beacon Exclusion Zone ---

# manhattan distance between x1,y1 and x2,y2
distance <- function(x1, y1, x2, y2) abs(x2 - x1) + abs(y2 - y1)

# parse input to df
parse_dat <- function(file) {
  readLines(file) |>
    lapply(\(x) regmatches(x, m = gregexpr('[-0-9]+', x)) |>
             unlist() |>
             as.integer()) |>
    do.call(rbind, args = _) |>
    as.data.frame() |>
    setNames(c('sx', 'sy', 'bx', 'by')) |>
    transform(range = distance(sx, sy, bx, by))
}

## Part 1 ----

# check if row is within sensor range in y dimension
is_in_range <- function(y, range, row) {
  (row >= (y - range)) & (row <= (y + range))
}

# find sensor range over row of interest
sensor_range <- function(x, y, range, row) {
  remains <- range - abs(row - y)
  data.frame(min = x - remains, max = x + remains)
}

part1 <- function(dat, row) {
  # relevant sensors and their range-limits
  sensors <-
    subset(dat,
           select = c(sx, sy, range),
           subset = is_in_range(sy, range, row)) |>
    transform(cvr = sensor_range(sx, sy, range, row))

  # only keep beacons on the row of interest
  beacons <-
    subset(dat, select = c(bx, by)) |>
    unique() |>
    subset(by == row)

  # create sequences on row, remove overlap, remove beacons
  mapply(seq, sensors$cvr.min, sensors$cvr.max) |>
    do.call(c, args = _) |>
    unique() |>
    setdiff(beacons$bx)
}

row <- 2e6
dat <- parse_dat('input/input-15.txt')
# 4724228
part1(dat, row) |> length()

rm(part1, sensor_range, is_in_range, row)

## Part 2 ----

library(tidyverse)
library(furrr)
plan(multisession)

# manhattan distance between x1,y1 and x2,y2
distance <- function(x1, y1, x2, y2) abs(x2 - x1) + abs(y2 - y1)
tuning_freq <- function(p)  4e6 * p$px + p$py

# ring of points outside of sensor range
perimeter_pts <- function(x, y, r) {
  perim_wide <- tibble(
    py = seq(y - (r + 1), y + (r + 1)),
    px1 =  x - ((r + 1) - abs(py - y)),
    px2 =  x + ((r + 1) - abs(py - y))
  )
  tibble(
    px = c(perim_wide$px1, perim_wide$px2),
    py = rep(perim_wide$py, times = 2),
  ) |>
    distinct()
}

# check all perimeter points against sensors,
# dropping pts that are within sensor range
perimeter_sift <- function(perimeter_pts, sensors){
  for (i in seq_len(nrow(sensors))) {
    s <- sensors[i, ]
    perimeter_pts <- perimeter_pts |>
      mutate(valid = distance(px, py, s$sx, s$sy) > s$range) |>
      filter(valid)
    if (nrow(perimeter_pts) == 1) break
  }
  perimeter_pts
}

range <- seq(0, 4e6); upper <- 4e6
sensors <- subset(dat, select = c(sx, sy, range))

p <- sensors |>
  transmute(perim = furrr::future_pmap(
    list(sx, sy, range),
    ~perimeter_pts(..1, ..2, ..3)
  )) |>
  unnest(perim) |>
  filter(between(px, 0, upper), between(py, 0, upper)) |>
  distinct() |>
  perimeter_sift(sensors)

# 13622251246513
print(paste('part 2:', tuning_freq(p = p)))
