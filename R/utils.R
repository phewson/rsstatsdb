#' Read Header Row from CSV File
#'
#' Reads the first line of a CSV file and splits it into column names.
#'
#' @param file Character scalar. Path to the CSV file.
#'
#' @return Character vector of column names extracted from the first line.
#'
#' @details
#' This function performs a simple split on commas and does not handle:
#' \itemize{
#'   \item Quoted fields containing commas
#'   \item Alternate delimiters
#'   \item Escaped characters
#' }
#'
#' For robust CSV parsing, consider using `readr::read_csv()`.
#'
#' @examples
#' \dontrun{
#' read_csv_header("data/collisions.csv")
#' }
#'
#' @export
read_csv_header <- function(file) {
    strsplit(readLines(file, n = 1), ",")[[1]]
}

#' Guess File Text Encoding
#'
#' Wrapper around `readr::guess_encoding()` to detect likely text encodings
#' for an input file.
#'
#' @param file Character scalar. Path to the file.
#'
#' @return A tibble describing possible encodings and confidence scores.
#'
#' @details
#' This function simply forwards to `readr::guess_encoding()` and exists
#' primarily for convenience and consistency within the package.
#'
#' @seealso readr::guess_encoding
#'
#' @examples
#' \dontrun{
#' guess_encoding("data/collisions.csv")
#' }
#'
#' @export
guess_encoding <- function(file) {
    readr::guess_encoding(file)
}


#' Print Differences Between Metadata and Data Field Names
#'
#' Compares field names defined in metadata against field names found in
#' source data and prints any differences to the console.
#'
#' @param meta Data frame containing metadata with columns `table` and
#'   `field_name`.
#' @param name_lists Named list of character vectors containing field names
#'   from source data, grouped by table.
#' @param tables Character vector of table names to compare. Defaults to
#'   names of `name_lists`.
#'
#' @return Invisibly returns `NULL`. Results are printed to the console.
#'
#' @details
#' For each table, the function reports:
#' \itemize{
#'   \item Fields present in data but missing from metadata
#'   \item Fields present in metadata but missing from data
#' }
#'
#' @examples
#' \dontrun{
#' name_lists <- list(
#'   collision = collision_names,
#'   casualty  = casualty_names,
#'   vehicle   = vehicle_names
#' )
#'
#' print_name_setdiffs(meta, name_lists)
#' }
#'
#' @export
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
