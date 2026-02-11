read_schema_yaml <- function(file) {

  if (!file.exists(file)) {
    stop("Schema YAML file does not exist: ", file, call. = FALSE)
  }

  x <- yaml::read_yaml(file)
  columns_tbl <- purrr::map_dfr(
    x$columns,
    ~ tibble::as_tibble(.x)
  )
  attr(columns_tbl, "schema_metadata") <- x[names(x) != "columns"]
  columns_tbl
}

schema_metadata <- function(schema_tbl) {
  attr(schema_tbl, "schema_metadata")
}


schema_yaml <- list(
  dataset = "stats19_collision",
  download_date = as.character(Sys.Date()),
  source = "DfT Stats19 open data",
  columns = purrr::transpose(schema_collisions)
)

#' Write schema yaml
#'
#' Write schema yaml
#' Assuming we have a spec in a schema_tbl
#' @examples
#' \dontrun{
#' write_schema_yaml(
#'  schema_casualty,
#'  "schemas/stats19_casualty.yml",
#'  metadata = list(
#'    dataset = "stats19_casualty",
#'    download_date = as.character(Sys.Date()),
#'    source = "DfT Stats19",
#'    notes = "Generated from 2024 metadata"
#'  )
#' )
#' }
write_schema_yaml <- function(schema_tbl, file, metadata = list()) {
  yaml_obj <- c(
    metadata,
    list(columns = purrr::transpose(schema_tbl))
  )
  yaml::write_yaml(yaml_obj, file)
}


