#' Rename field_names in staging table to match metadata
#'
#' There are a few minor differences between meta-data variable
#' names and the released data column names.
#' The logic here is to recode the imported variable names
#' so they match the metadata.
#'
#' @param column_names The data column names
#' @param name_map The lookup that converts data names to meta data names
#' @return Vector of renamed column names
rename_to_metadata <- function(column_names, name_map) {
  dplyr::recode(column_names, !!!name_map, .default = column_names)
}

#' ddl intro
#'
#' To import data to staging
#' Given an import file name this creates the initial
#' part of the bash script (specifying it as INPUT and
#' checking it exists)
#'
#' @param file_name The name of the target file
#' @param file_folder The name of the datastore folder
#' @return Some sql
ddl_intro <- function(file_name, file_folder = "dft/stats19") {
    paste("#!/bin/bash\n",
          "set -e; set -u;\n\n",
          "INPUT=\"$DATASTORE/", file_folder, "/", file_name, "\"\n",
          "[[ -f \"$INPUT\" ]] || { >&2 echo \"Missing input file: [$INPUT]\" ; exit 5 ; }\n",
          sep = "")
    }

#' ddl intro
#'
#' To import data to staging
#' Given an import file name this creates the initial
#' part of the bash script (specifying it as INPUT and
#' checking it exists)
#'
#' @param table Name of the target staging table
#' @return Some sql
ddl_tail <- function(pg_table, year=2024) {
    paste("echo \"\\copy staging.dft_", pg_table, " FROM $INPUT delimiter ',' csv header;\"\n",
          "echo \"SELECT dft.import_dft_", pg_table, "_", year, "();\"\n",
           sep = "")
}

#' Generate the staging table ddl
#'
#' THis is intended to be used in a bash script that is piped
#' through to SQL
#' @param table_name The name of the table
#' @param columns A vector of column names / field_names
#' @param file the file holding the import data
#' @param folder the folder containing the data file
#' @param schema the schema where the imported table is to go
#' @return SQL
generate_staging_ddl <- function(pg_table_name, column_names, file_name, file_folder = "dft/stats19", staging_schema= "staging") {
    columns_sql <- paste0("  ", column_names, " TEXT", collapse = ",\n")
    ddl <- paste0(ddl_intro(file_name, file_folder),
                  "cat << EOF\n\n",
                "DROP TABLE IF EXISTS ", staging_schema, ".dft_", pg_table_name, ";\n",
                "CREATE TABLE IF NOT EXISTS ", staging_schema, ".dft_", pg_table_name, " (\n",
                columns_sql,
                ");\n",
                "EOF\n\n",
                ddl_tail(pg_table_name), "\n"
                )
    ddl
}

#' Wrapper function that builds the staging table
#'
#' @param pg_table_name The final intended pg table name
#' @param raw_column_names The imported data column names
#' @param meta_name_map The lookup that ensures we use names from the meta data
#' @param source_file path to the raw data file
#' @param staging_schema The schema for the staging file
#' @export'
build_staging_table <- function(pg_table_name, raw_column_names, meta_name_map, file_name, staging_schema = "staging") {
  canonical_col_names <- rename_to_metadata(raw_column_names, meta_name_map)
  generate_staging_ddl(pg_table_name, canonical_col_names, file_name, staging_schema)
}
