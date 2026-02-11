#' Add an SQL (single) quote
#'
#' Adds an SQL style quotation
#'
#' @param x String
#' @return String with sql quotes
sql_quote <- function(x) {
  paste0("'", gsub("'", "''", x), "'")
}

#' Generate enum
#'
#' Generate code to create an enum in Postgres
#'
#' @param field The name of the variable to be enummed
#' @param values The values of the enum
#' @param schema The schema to store the enum
#' @return A multiline string which should be valid sql
generate_enum_sql <- function(field, values, schema = "dft", prefix = "stats19") {
  enum_name <- paste(prefix, field, sep = "_")
  values_sql <- values |>
    unique() |>
    sort() |>
    sql_quote() |>
    paste(collapse = ", ")
   glue::glue("
IF NOT EXISTS (
  SELECT 1
  FROM pg_type
  WHERE typname = '{enum_name}' AND typnamespace::regnamespace = '{schema}'::regnamespace) THEN
CREATE TYPE {schema}.{enum_name} AS ENUM ({values_sql});
END IF;
")
}

#' Generate a set of enums
#'
#' Given a dataframe containing `table` and `field_name`
#' assuming one row for each value of the enum
#' This will create the sql to specify these enums.
#' Will only do this for coded variables with 3 or more and less than 15 values
#'
#' @param df A data frame containing table, field_name and label
#' @return A long string encoding all enums
#' @export
generate_all_enum_sql <- function(df) {
  chunks <- df |>
      group_by(table, field_name) |>
      filter(n() >= 3 & n() < 15) |>
    summarise(
      sql = generate_enum_sql(first(field_name), label),
      .groups = "drop")
  glue::glue("
DO $$
BEGIN
{paste(chunks$sql, collapse = '\n')}
END $$;
")
}

#' Generate drop enum code
#'
#' Given the same data frame (containing table, field_name and labels)
#' will create sql to drop these enums
#' @param df The name of th4e dataframe containing
#' table, field_name. The latter is the name of the enums to be
#' dropped.
#' @return SQL
#' @export
generate_all_enum_drop_sql <- function(df) {

  fields <- df |>
    group_by(table, field_name) |>
    filter(n() >= 3 & n() < 15) |>
    summarise(
      type_name = paste0("stats19_", first(field_name)),
      .groups = "drop"
    )

  drop_statements <- glue::glue(
    "DROP TYPE IF EXISTS dft.{fields$type_name} CASCADE;"
  )

  glue::glue("
DO $$
BEGIN
{paste(drop_statements, collapse = '\n')}
END $$;
")

    }
