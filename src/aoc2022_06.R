
start_of_segment <- function(x, signature) {
  position <- signature
  chars <- FALSE
  while (chars != signature) {
    chars <-
      substring(x, position - signature + 1, position) |>
      strsplit('') |>
      {\(x) x[[1]]}() |>
      unique() |>
      length()
    position <- position + 1
  }
  return(position)
}

# part 1
readLines('input/input-06.txt') |> start_of_segment(4)

# part 2
readLines('input/input-06.txt') |> start_of_segment(14)
