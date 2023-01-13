# --- Day 16: Proboscidea Volcanium ---

# 30 minutes before the volcano erupts
# one minute to open a single valve and
# one minute to follow any tunnel from one valve to another
#


library(tidyverse)

parse_graph <- function(file){
  tibble(line = readLines(file)) |>
    tidyr::extract(
      line,
      into = c('name', 'rate',  'to'),
      regex = 'Valve ([A-Z]+).*?=([0-9]+).*?to [^ ]+ (.*+)$'
    ) |>
    transmute(
      name,
      data = pmap(
        list(name, rate, to),
        ~lst(
          name = ..1,
          rate = as.integer(..2),
          to = tibble(
            name = unlist(str_split(..3, ', ')),
            dist = 1)
        ))) |>
    deframe()
}

#
plot_graph <- function(graph) {
  ntwk <-
    enframe(graph) |>
    select(-name) |>
    unnest_wider(value) |>
    rename(node = name) |>
    unnest(to) |>
    relocate(-rate) |>
    mutate(rate = rate/10) |>
    network::network(loops = T)

  ntwk |> network::plot.network(
    x = _,
    label = paste0(
      # names(graph), ' (',
      graph |> map_chr(~pluck(., 'rate'))
      # , ')'
    ),
    label.cex = 0.79,
    vertex.cex = graph |> map_int(~pluck(., 'rate')) / 10
  )
}

# remove a single node from the graph and bridge neighbors
collapse_node <- function(graph, node){

  new_graph <- keep(graph, ~!.$name == node$name)

  # compute distance between null nodes neighbors for reconnection
  neighbors <- crossing(
    x = node$to |> set_names(c('name', 'x_dist')),
    y = node$to |> set_names(c('dest', 'y_dist'))
  ) |>
    unnest(cols = c(x, y)) |>
    filter(name != dest) |>
    transmute(name, dest, dist = x_dist + y_dist)

  # update edge distances for each neighbor
  for (i in seq_len(nrow(neighbors))) {
    neighbor <- graph[[neighbors$name[i]]]
    neighbor$to <- neighbor$to |>
      bind_rows(neighbors |> select(name, dist)) |>
      filter(name != node$name, name != neighbor$name) |>
      group_by(name) |>
      filter(dist == min(dist)) |>
      ungroup() |>
      distinct()
    new_graph[[neighbor$name]] <- neighbor
  }
  new_graph
}

# collapse any nodes where rate of valve is 0
simplify_graph <- function(graph){
  repeat {
    nulls <- graph |> keep(~.$rate == 0 && .$name != 'AA')
    if (!length(nulls)) break
    node <- nulls[[1]]
    graph <- collapse_node(graph, node)
    plot_graph(graph)
  }
  graph
}

plots <- lst()

graph <- parse_graph('input/input-16.txt')
plots <- append(plots, plot_graph(graph))
graph <- simplify_graph(graph)
plot_graph(graph)

graph |> map('name')

graph |> str()

# find every hamiltonian path and evaluate score
bfs <- function(graph, start) {
  open_valves <- vector(length = length(graph)) |>
    set_names(graph |> map_chr('name') |> sort())
  open_valves['AA'] <- T
  node <- graph[['AA']]
  queue <- node$to |>
    rename(time = dist) |>
    split(~name) |>
    set_names(NULL) |>
    map(as.list)
}

