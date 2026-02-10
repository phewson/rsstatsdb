
col_expr <- function(field, strategy, target = NULL) {
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




join_expr <- function(field, strategy, target, table_name) {
  if (strategy == "enum") {
    glue::glue("
LEFT JOIN staging.stats19_metadata {field}
ON {field}.field_name = '{field}'
AND {field}.code = s.{field}")
  } else {
    NA  }
}


build_select_list <- function(schema, col_expr) {
    purrr::pmap_chr(schema, col_expr)

}

build_join_phrases <- function(schema, join_expr, table_name) {
    joins <- purrr::pmap_chr(schema, join_expr, table_name)
    joins <- joins[!is.na(joins)]
    return(joins)
    }

staging <- function(selects, joins, schema, table){
  glue::glue("
INSERT INTO {schema}.{table}
SELECT
{paste(selects, collapse = ',\n')}
FROM staging.{schema}_{table} s
{paste(joins, collapse = '\n')}
")
}

gen_schema <- function(intended_schema, col_expr, join_expr, table, psql_schema = "dft") {
  ss <- build_select_list(intended_schema, col_expr)
  jj <- build_join_phrases(intended_schema, join_expr, table)
  sql <- staging(ss, jj, psql_schema, paste("stats19_", table, sep = ""))
  return(sql)
}
