#' Generate PostgreSQL Table DDL from YAML Schema
#'
#' Reads a schema definition from a YAML file and generates PostgreSQL
#' CREATE TABLE DDL SQL for the dataset described in the schema metadata.
#'
#' @param yaml_file Character scalar. Path to schema YAML file.
#' @param pg_schema Character scalar. Target PostgreSQL schema name.
#'   Default is `"dft"`.
#'
#' @return Character scalar containing CREATE TABLE SQL statement.
#'
#' @details
#' The YAML file must be readable by `read_schema_yaml()` and must include
#' schema metadata containing a `dataset` field used as the table name.
#'
#' @examples
#' \dontrun{
#' generate_table_ddl_from_yaml("schemas/casualties.yaml")
#' }
#'
#' @export
generate_table_ddl_from_yaml <- function(yaml_file, pg_schema = "dft") {
  schema_tbl <- read_schema_yaml(yaml_file)
  meta <- attr(schema_tbl, "schema_metadata")
  table_name <- meta$dataset
  build_table_ddl(schema_tbl, table_name = table_name, pg_schema = pg_schema)
}

#' Build PostgreSQL CREATE TABLE DDL SQL
#'
#' Generates CREATE TABLE SQL using a schema mapping table.
#'
#' @param schema_tbl Data frame or list compatible with purrr::pmap,
#'   containing column mapping definitions.
#' @param table_name Character scalar. Table name to create.
#' @param pg_schema Character scalar. PostgreSQL schema name.
#'
#' @return Character scalar CREATE TABLE SQL statement.
#'
#' @export
build_table_ddl <- function(schema_tbl, table_name, pg_schema = "dft") {
  cols <- purrr::pmap_chr(schema_tbl, build_column_ddl)
  cols_sql <- glue::glue_collapse(cols, sep = ",\n  ")
  glue::glue(
"
CREATE TABLE IF NOT EXISTS {pg_schema}.{table_name} (
  {cols_sql}
);
"
  )
}

#' Build Column DDL SQL Fragment
#'
#' Generates SQL fragment defining a column name and PostgreSQL type.
#'
#' @param field Character scalar. Column name.
#' @param strategy Character scalar. Transformation strategy.
#' @param target Character scalar. Target PostgreSQL type where applicable.
#'
#' @return Character scalar column DDL SQL fragment.
#'
#' @export
build_column_ddl <- function(field, strategy, target) {
  pg_type <- resolve_postgres_type(field, strategy, target)
  glue::glue("{field} {pg_type}")
}

#' Resolve PostgreSQL Type from Strategy Mapping
#'
#' Maps transformation strategy to PostgreSQL column type.
#'
#' @param field Character scalar. Column name (currently unused but
#'   included for interface consistency and future extensibility).
#' @param strategy Character scalar. Transformation strategy.
#' @param target Character scalar. Target PostgreSQL type for cast/enum
#'   strategies.
#'
#' @return Character scalar PostgreSQL type name.
#'
#' @export
resolve_postgres_type <- function(field, strategy, target) {
  switch(
    strategy,
    cast = target,
    enum = target,
    postgis = "geometry(Point, 4326)",
    dtg = "timestamp",
    stop("Unknown strategy: ", strategy, call. = FALSE)
  )
}

