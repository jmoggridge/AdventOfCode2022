# --- Day 16: Proboscidea Volcanium ---

library(tidyverse)

valves <- readLines('input/input-16.txt') |>
  as_tibble() |>
  tidyr::extract(value, into = c('valve', 'rate',  'to'),
                 regex = 'Valve ([A-Z]+).*?=([0-9]+).*?to [^ ]+ (.*+)$') |>
  transmute(
    valve,
    node = map2(as.integer(rate), to,
                ~lst(rate = .x, to = unlist(str_split(.y, ', '))))
    ) |>
  deframe()
#
# dfs_wrapper <- function(valves){

  dfs <- function(valve, time, released, flow_rate) {
    cat(paste('\n\nentering at', valve))
    cat(paste('\ntime is', time))

    # before recursion
    time <- time + 1L
    released <- released + flow_rate + 1
    if (time == 30L) {
      released
    } else {
    # recursion over options
    valves[[valve]]$to |>
      map_dbl(~dfs(., time, released, flow_rate)) |>
      max()
    }
  }

  # dfs(valve = 'AA', time = 0, released = 0, flow_rate = 0)


ntwk <- enframe(valves) |>
  unnest_wider(value) |>
  unnest(to) |>
  relocate(-rate) |>
  network::network(vertex.attrnames = 'rate')

print(ntwk)
network::print.summary.network(ntwk)

ntwk |> network::plot.network(x = _)
