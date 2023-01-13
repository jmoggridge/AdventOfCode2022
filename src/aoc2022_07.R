# AOC day 7
library(tidyverse)

parse_input <- function(lines) {
  path <- lst('root'); dir_ls <- lst('root'); files <- tibble()
  for (x in lines){
    if (x %in% c('$ cd /', '$ ls') || str_detect(x, '^dir')) {
      next
    } else if (x == '$ cd ..') {
      path <- head(path, -1)
      next
    } else if (str_detect(x, '\\$ cd ')) {
      path <- append(path, str_remove(x, '\\$ cd '))
      dir_ls <- c(dir_ls, paste0(path, collapse = ' '))
      next
    } else {
      file <-  lst(path = paste0(path, collapse = ' '),
                   name = str_extract(x, '[^ ]+$'),
                   size = str_extract(x, '^[0-9]+') |> as.double())
      files <- bind_rows(files, file)
    }
  }
  lst(dirs = dir_ls, files = files)
}

tally_dir_size <- function(target, folders){
  folders |>
    filter(str_detect(path, target)) |>
    pull(size) |>
    sum()
}

input <- readLines('input/input-07.txt') |> parse_input()

# complete list of directories including those w/o files
dirs <- as.character(input$dirs)

# tally file sizes directly in each folder
folders <- input$files |>
  group_by(path) |>
  summarise(size = sum(size))

# find directories' total size including their children dirs
dirs <-
  tibble(path = dirs) |>
  mutate(size = map_dbl(path, ~tally_dir_size(., folders)))

## Part 1 ----

# get directories smaller than 100k, add their sizes
dirs |>
  filter(size <= 100000) |>
  summarise(solution = sum(size))


## Part 2 ----
# total disk space available to the filesystem is 70000000
# To run the update, you need unused space of at least 30000000
# Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update.
# What is the total size of that directory?

total_disk_space <- 70000000
needed_for_update <- 30000000
current_usage <- dirs[1,2][[1]]
available_memory <- total_disk_space - current_usage
shortage <- needed_for_update - available_memory

dirs |>
  arrange(size) |>
  filter(size > shortage) |>
  slice(1)

