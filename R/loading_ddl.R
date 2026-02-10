#' Rename data columns to match metadata naming
#'
#' Some released datasets use column names that differ slightly from
#' the official metadata field names. This helper maps raw data column
#' names to the canonical metadata names.
#'
#' @param column_names Character vector of column names from raw data.
#' @param name_map Named character vector mapping raw names → metadata names.
#'
#' @return Character vector of column names aligned to metadata naming.
#' @export
rename_to_metadata <- function(column_names, name_map) {
  dplyr::recode(column_names, !!!name_map, .default = column_names)
}

#' Build shell script header for loading raw data into landing schema
#'
#' Generates the initial part of a bash script that:
#' - Defines the INPUT file location
#' - Checks that the file exists before continuing
#'
#' @param file_name Name of the raw data file.
#' @param file_folder Folder under `$DATASTORE` containing the file.
#'
#' @return Character string containing bash script header.
#' @export
build_load_script_header <- function(file_name, file_folder) {
    paste("#!/bin/bash\n",
          "set -e; set -u;\n\n",
          "INPUT=\"$DATASTORE/", file_folder, "/", file_name, "\"\n",
          "[[ -f \"$INPUT\" ]] || { >&2 echo \"Missing input file: [$INPUT]\" ; exit 5 ; }\n",
          sep = "")
    }

#' Build shell script footer for loading and promoting data
#'
#' Generates the part of the bash script that:
#' - Copies CSV data into landing table
#' - Calls database promote function
#'
build_load_script_footer <- function(pg_table, year=2024) {
    paste("echo \"\\copy staging.dft_", pg_table, " FROM $INPUT delimiter ',' csv header;\"\n",
          "echo \"SELECT dft.import_dft_", pg_table, "_", year, "();\"\n",
           sep = "")
}

#' Build landing table load script
#'
#' Generates a bash script that:
#' 1. Creates or replaces a landing table (all TEXT columns)
#' 2. Loads raw CSV data into the landing table
#' 3. Calls downstream promote function
#'
#' @param pg_table_name Target table name (without schema prefix).
#' @param column_names Character vector of landing column names.
#' @param file_name Raw CSV file name.
#' @param file_folder Folder containing raw files (under `$DATASTORE`).
#' @param import_schema Database schema for landing tables.
#'
#' @return Character string containing full bash + SQL load script.
#' @export
build_landing_table_script <- function(pg_table_name, column_names, file_name, file_folder, import_schema) {
    columns_sql <- glue::glue_collapse(glue::glue("  {column_names} TEXT"), sep = ",\n")
    ddl <- paste0(build_load_script_header(file_name, file_folder),
                  "cat << EOF\n\n",
                "DROP TABLE IF EXISTS ", import_schema, ".dft_", pg_table_name, ";\n",
                "CREATE TABLE IF NOT EXISTS ", import_schema, ".dft_", pg_table_name, " (\n",
                columns_sql,
                ");\n",
                "EOF\n\n",
                build_load_script_footer(pg_table_name), "\n"
                )
    ddl
}

#' Build landing load script using raw column names
#'
#' Convenience wrapper that:
#' - Renames raw columns to metadata names
#' - Generates landing table load script
#'
#' @param pg_table_name Target Postgres table name.
#' @param raw_column_names Column names from raw CSV file.
#' @param meta_name_map Named vector mapping raw → metadata column names.
#' @param file_name Raw CSV file name.
#' @param file_folder Folder containing raw files (under `$DATASTORE`).
#' @param import_schema Landing schema name.
#'
#' @return Character string containing load script.
#' @export
build_loading_ddl <- function(pg_table_name, raw_column_names, meta_name_map, file_name,
                              file_folder = "dft/stats19", import_schema = "landing") {
  stopifnot(is.character(raw_column_names))
  stopifnot(length(raw_column_names) > 0)
  canonical_column_names <- rename_to_metadata(raw_column_names, meta_name_map)
  build_landing_table_script(pg_table_name, canonical_column_names, file_name, file_folder, import_schema)
}
