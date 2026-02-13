#' Build SQL SELECT Expression for a Column
#'
#' Generates a SQL SELECT expression string for a given field based on the
#' transformation strategy defined in the schema mapping.
#'
#' @param field Character scalar. Source column name.
#' @param strategy Character scalar. Transformation strategy. Supported values:
#'   \itemize{
#'     \item `"cast"` - Cast source column to target type.
#'     \item `"enum"` - Join to enum lookup table and cast label.
#'     \item `"postgis"` - Build geometry from latitude/longitude.
#'     \item `"dtg"` - Combine date/time fields into timestamp.
#'   }
#' @param target Optional character scalar. Target SQL type for casting.
#'
#' @return Character scalar SQL SELECT expression.
#'
#' @examples
#' build_column_select_sql("speed_limit", "cast", "int")
#'
#' @export
build_column_select_sql <- function(field, strategy, target = NULL) {
  if (!is.character(field) || length(field) != 1) {
    stop("field must be a single string", call. = FALSE)
  }
  if (!is.null(target) && (!is.character(target) || length(target) != 1)) {
    stop("target must be NULL or a single string", call. = FALSE)
  }
  switch(
    strategy,
    cast = glue::glue("s.{field}::{target} AS {field}"),
    enum = glue::glue("{field}.label::{target} AS {field}"),
    postgis =
      "ST_SetSRID(ST_MakePoint(s.longitude::float8, s.latitude::float8), 4326) AS geom",
    dtg =
      "to_timestamp(nullif(date,'NULL') || ' ' || nullif(time,'NULL'), 'DD/MM/YYYY HH24:MI')",
    stop(glue::glue("Unknown strategy: {strategy}"), call. = FALSE)
  )
}

#' Build SQL JOIN Clause for a Column Strategy
#'
#' Generates SQL JOIN clause text when required by the transformation strategy.
#' Currently only enum strategy requires a join.
#'
#' @param field Character scalar. Source column name.
#' @param strategy Character scalar. Transformation strategy.
#' @param target Character scalar. Target type (unused for most joins but kept
#'   for interface consistency).
#' @param table_name Character scalar. Destination table name.
#'
#' @return Character scalar SQL JOIN clause, or NA if no join required.
#'
#' @export
build_join_sql <- function(field, strategy, target, table_name) {
  if (strategy == "enum") {
    glue::glue("
LEFT JOIN staging.stats19_metadata {field}
ON {field}.field_name = '{field}'
AND {field}.code = s.{field}")
  } else {
    NA  }
}

#' Build Vector of SELECT Expressions from Schema
#'
#' Applies column expression builder across schema definition to produce
#' a vector of SQL SELECT expressions.
#'
#' @param schema Data frame or list compatible with purrr::pmap.
#' @param build_column_select_sql Function used to build column SQL expressions.
#'
#' @return Character vector of SQL SELECT expressions.
#'
#' @export
build_select_clause_vector <- function(schema, build_column_select_sql) {
    purrr::pmap_chr(schema, build_column_select_sql)
}

#' Build Vector of JOIN Clauses from Schema
#'
#' Applies join builder across schema definition and removes NA entries
#' where joins are not required.
#'
#' @param schema Data frame or list compatible with purrr::pmap.
#' @param build_join_sql Function used to build join SQL.
#' @param table_name Character scalar. Destination table name.
#'
#' @return Character vector of SQL JOIN clauses.
#'
#' @export
build_join_clause_vector <- function(schema, build_join_sql, table_name) {
    joins <- purrr::pmap_chr(schema, build_join_sql, table_name)
    joins <- joins[!is.na(joins)]
    return(joins)
    }

#' Build PL/pgSQL Import Function SQL
#'
#' Generates SQL text for a PL/pgSQL function that imports data from staging
#' into a destination schema table.
#'
#' @param selects Character vector of SELECT expressions.
#' @param joins Character vector of JOIN clauses.
#' @param schema Character scalar. Destination schema name.
#' @param table Character scalar. Destination table name.
#'
#' @return Character scalar SQL function definition.
#'
#' @export
build_promote_function_sql <- function(selects, joins, schema, table){
  glue::glue("
CREATE FUNCTION dft.import_{schema}_{table}() RETURNS void
AS $$
declare
begin
INSERT INTO {schema}.{table}
SELECT
{paste(selects, collapse = ',\n')}
FROM staging.{schema}_{table} s
{paste(joins, collapse = '\n')}
;
end
$$ LANGUAGE plpgsql;
")
}

#' Generate Import SQL for Stats19 Table
#'
#' High-level orchestration function that builds SELECT clauses, JOIN clauses,
#' and final PL/pgSQL import function SQL for a given schema mapping.
#'
#' @param intended_schema Schema definition used for column mapping.
#' @param build_column_select_sql Function used to build column SELECT SQL.
#' @param build_join_sql Function used to build JOIN SQL.
#' @param table Character scalar. Base table name (without prefix).
#' @param psql_schema Character scalar. Destination PostgreSQL schema.
#'   Default is `"dft"`.
#'
#' @return Character scalar SQL definition for import function.
#'
#' @export
generate_promotion_sql <- function(intended_schema, build_column_select_sql, build_join_sql, table, psql_schema = "dft") {
  ss <- build_select_clause_vector(intended_schema, build_column_select_sql)
  jj <- build_join_clause_vector(intended_schema, build_join_sql, table)
  sql <- build_promote_function_sql(ss, jj, psql_schema, paste("stats19_", table, sep = ""))
  return(sql)
}
