read_csv_header <- function(file) {
    strsplit(readLines(file, n = 1), ",")[[1]]
}


guess_encoding <- function(file) {
    readr::guess_encoding(file)
}


#'@example \dontrun{ name_lists <- list(
#'  collision = collision_names,
#'  casualty  = casualty_names,
#'  vehicle   = vehicle_names
#')
#'
#' print_name_setdiffs(meta, name_lists)
#' }
print_name_setdiffs <- function(meta, name_lists, tables = names(name_lists)) {
  for (tbl in tables) {
    meta_names <- unique(meta[meta$table == tbl, "field_name"][[1]])
    data_names <- name_lists[[tbl]]
    not_in_meta <- setdiff(data_names, meta_names)
    not_in_data <- setdiff(meta_names, data_names)
    if (length(not_in_meta) > 0 || length(not_in_data) > 0) {
      cat("\n---", tbl, "---\n")
      if (length(not_in_meta) > 0) {
        cat("In data not in meta:\n")
        print(not_in_meta)
      }
      if (length(not_in_data) > 0) {
        cat("In meta not in data:\n")
        print(not_in_data)
      }
    }
  }
}
