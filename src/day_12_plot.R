




#
# plt_matrix <- function(x){
#   x |>
#     as_tibble() |>
#     rownames_to_column('row') |>
#     pivot_longer(-row, names_to = 'col', names_pattern = '([0-9]+)') |>
#     ggplot() +
#     geom_tile(
#       aes(as.numeric(col), as.numeric(row), fill = value),
#       color = 'gray50'
#       )
# }
#
# pts <- tibble(row = c(21, 21), col = c(1,59), symbol = c('S', 'E'))
#
# p1 <- topo |>
#   plt_matrix() +
#   scale_fill_viridis_c(option = 'D') +
#   ggrepel::geom_label_repel(
#     data = pts, aes(col, row, label = symbol), label.r = 0.25,
#     color = 'gray20', size = 3) +
#   geom_point(
#     data = pts, aes(col, row),
#     color = 'white') +
#   labs(fill = 'Height', subtitle = 'Topography') +
#   theme_void()
#
# p2 <- steps |>
#   plt_matrix() +
#   geom_point(
#     data = pts, aes(col, row),
#     color = 'white') +
#   scale_fill_viridis_c(option = 'B') +
#   labs(fill = 'Steps', subtitle = "Part 1: 408 Steps from S to E") +
#   theme_void()
#
# ends <- steps2 |>
#   as_tibble() |>
#   rownames_to_column('row') |>
#   pivot_longer(-row, names_to = 'col', names_pattern = '([0-9]+)') |>
#   mutate(across(everything(), as.numeric)) |>
#   filter(value == 399)
#
# p3 <- steps2 |>
#   plt_matrix() +
#   scale_fill_viridis_c(option = 'B') +
#   geom_point(
#     data = pts |> filter(symbol == 'E'), aes(col, row),
#     color = 'white'
#     ) +
#   geom_point(
#     data = ends,
#     aes(col, row),
#     color = 'black',
#     shape = 4
#   ) +
#   labs(fill = 'Steps', subtitle = "Part 2: 399 Steps to closest 'a's from 'E'") +
#   theme_void()
#
# library(patchwork)
#
# p1 / p2 / p3
#

