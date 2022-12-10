library(tidyverse)

is_cd_dir <- function(x) str_detect(x, '^\\$.cd\\s[^\\.]')    # moves through tree
is_cd_up <- function(x) str_detect(x, '\\.\\.$')
cd_dest <- function(x) str_remove(x, '\\$\\scd\\s')
is_ls <- function(x) str_detect(x, '^\\$.ls')    # shows dirs and files
is_dir <- function(x) str_detect(x, '^dir ')     # a dir
is_file <- function(x) str_detect(x, '^[0-9]+')  # a file
getname <- function(x) str_extract(x, '[^\\s]$')

get_children <- function(input, i) {
  tail(input, -i) |> head_while(~is_dir(.) || is_file(.))
}

parse_child <- function(x){
  if (is_dir(x)) {
    lst(name = getname(x),
        type = 'dir')
  } else {
    lst(name = getname(x),
        type = 'file',
        size = str_extract(x, '^[0-9]+'))
  }
}

# ------

input <- read_lines('input/test.txt')
i <- 0
path <-  character()
adj_list <- lst()

while (i < length(input)) {
  i <- i + 1
  step <-  input[i]

  print(i)
  print(step)
  print(path)
  print(adj_list)

  if (is_cd_up(step)) {
    path <- head(path, -1)
  } else if (is_cd_dir(step)) {
    path <- append(path, cd_dest(step))
  } else if (is_ls(step)) {
    dir <- tail(path, 1)
    adj_list[[dir]] <- get_children(input, i) |> map_dfr(parse_child)
    i <- i + nrow(adj_list[[dir]])
  }
}


str(adj_list)

