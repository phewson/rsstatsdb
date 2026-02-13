#' Read Schema Definition from YAML File
#'
#' Reads a schema definition YAML file and converts the column definitions
#' into a tibble suitable for downstream SQL generation. Any non-column
#' top-level YAML fields are stored as schema metadata on the returned object.
#'
#' @param file Character scalar. Path to the schema YAML file.
#'
#' @return A tibble containing column definitions. The tibble includes an
#'   attribute `"schema_metadata"` containing all non-column top-level YAML
#'   fields.
#'
#' @details
#' The YAML file must contain a top-level `columns` field that is a list of
#' column definition objects. For example:
#'
#' ```yaml
#' dataset: collisions
#' version: 1
#' columns:
#'   - field: collision_id
#'     strategy: cast
#'     target: bigint
#'   - field: collision_time
#'     strategy: dtg
#' ```
#'
#' Any fields other than `columns` are stored as metadata and can be accessed
#' using `schema_metadata()`.
#'
#' @seealso schema_metadata
#'
#' @examples
#' \dontrun{
#' schema_tbl <- read_schema_yaml("schemas/collisions.yaml")
#' }
#'
#' @export
read_schema_yaml <- function(file) {
  if (!file.exists(file)) {
    stop("Schema YAML file does not exist: ", file, call. = FALSE)
  }
  x <- yaml::read_yaml(file)
  if (is.null(x$columns) || !is.list(x$columns)) {
    stop("YAML must contain a 'columns' list")
  }
  columns_tbl <- purrr::map_dfr(x$columns, function(col) tibble::as_tibble(col))
  attr(columns_tbl, "schema_metadata") <- x[names(x) != "columns"]
  columns_tbl
}

#' Extract Schema Metadata from Schema Table
#'
#' Retrieves schema-level metadata stored as an attribute on a schema tibble
#' created by `read_schema_yaml()`.
#'
#' @param schema_tbl Tibble returned by `read_schema_yaml()`.
#'
#' @return A list containing schema metadata values extracted from the YAML
#'   file (all top-level fields except `columns`).
#'
#' @details
#' Metadata is stored as an attribute named `"schema_metadata"` on the
#' schema tibble.
#'
#' @seealso read_schema_yaml
#'
#' @examples
#' \dontrun{
#' schema_tbl <- read_schema_yaml("schemas/collisions.yaml")
#' meta <- schema_metadata(schema_tbl)
#' meta$dataset
#' }
#'
#' @export
schema_metadata <- function(schema_tbl) {
  attr(schema_tbl, "schema_metadata")
}

#' Write schema yaml
#'
#' Write schema yaml
#' Assuming we have a spec in a schema_tbl
#'
#' @param schema_tbl A tibble listing the looku pdata
#' @param file the target file name
#' @param metadata Important metadata we also want to store in the yaml
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
  yaml_obj <- c(metadata, list(columns = purrr::transpose(schema_tbl)))
  yaml::write_yaml(yaml_obj, file)
}


