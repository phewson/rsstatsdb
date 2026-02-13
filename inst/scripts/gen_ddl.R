library(readxl)
library(dplyr)

conn <- create_connection()

DATAHOME <- Sys.getenv("DATASTORE")
FOLDER <- "dft/stats19"
FILE <- "dft-road-casualty-statistics-road-safety-open-dataset-data-guide-2024.xlsx"
TARGET <- paste(DATAHOME, FOLDER, FILE, sep = "/")

meta <- read_excel(TARGET) |>
    rename("field_name" = `field name`, "code" = `code/format`)

enum_overrides <- read_schema_yaml("inst/schemas/stats19_enum_overrides.yml")


meta_fixed <- meta |>
  left_join(enum_overrides, by = c("table", "field_name", "code")) |>
  mutate(label = coalesce(label_override, label)) |>
  select(-label_override)


## Write the modified / cleaned metadata to staging
dbWriteTable(conn, name = Id(schema = "staging", table = "stats19_metadata"),
             value = meta_fixed, overwrite = TRUE, row.names = FALSE)


###################### load the crash data

COLLISION_DATA <- "new-dft-road-casualty-statistics-collision-1979-latest-published-year.csv"
CASUALTY_DATA <- "new-dft-road-casualty-statistics-casualty-1979-latest-published-year.csv"
VEHICLE_DATA <- "new-dft-road-casualty-statistics-vehicle-1979-latest-published-year.csv"

COLLISION_FILE <- paste(DATAHOME, FOLDER, COLLISION_DATA, sep = "/")
CASUALTY_FILE <- paste(DATAHOME, FOLDER, CASUALTY_DATA, sep = "/")
VEHICLE_FILE <- paste(DATAHOME, FOLDER, VEHICLE_DATA, sep = "/")

guess_encoding(COLLISION_FILE)

collision_names <- read_csv_header(COLLISION_FILE)
casualty_names <- read_csv_header(CASUALTY_FILE)
vehicle_names <- read_csv_header(VEHICLE_FILE)

############### Generate code for enums



sql <- generate_all_enum_sql(meta_fixed)

writeLines(sql, "dft_stats19_enums.sql")


drop_sql <- generate_all_enum_drop_sql(meta_fixed)

name_map <- c(
  casualty_adjusted_severity_serious = "casualty_adjusted_serious",
  casualty_adjusted_severity_slight = "casualty_adjusted_slight",
  enhanced_severity_collision = "enhanced_collision_severity",
  collision_adjusted_severity_serious = "collision_adjusted_serious",
  collision_adjusted_severity_slight = "collision_adjusted_slight"
)

writeLines(build_loading_ddl("stats19_collisions", collision_names, name_map, COLLISION_DATA), con = "import_stats19_collisions.sh")
writeLines(build_loading_ddl("stats19_casualties", casualty_names, name_map, CASUALTY_DATA),
           con = "import_stats19_casualties.sh")

writeLines(build_loading_ddl("stats19_vehicles", vehicle_names, name_map, VEHICLE_DATA),
           con = "import_stats19_vehicles.sh")

promote_colllisions <- generate_promotion_sql(read_schema_yaml("inst/schemas/stats19_collision.yml"),
                                             build_column_select_sql,
                                             build_join_sql, "collision", psql_schema = "dft")
writeLines(promote_collisions, con = "dft_stats19_collisions.sql")
promote_casualties <- generate_promotion_sql(read_schema_yaml("inst/schemas/stats19_casualty.yml"), build_column_select_sql,
                                             build_join_sql, "casualty", psql_schema = "dft")
writeLines(promote_casualties, con = "dft_stats19_casualties.sql")
promote_vehicles <- generate_promotion_sql(read_schema_yaml("inst/schemas/stats19_vehicle.yml"), build_column_select_sql, build_join_sql, "vehicle", psql_schema = "dft")
writeLines(promote_vehicles, con = "dft_stats19_vehicles.sql")


colllisions_ddl <- generate_table_ddl_from_yaml <- function(read_schema_yaml("inst/schemas/stats19_collision.yml"),pg_schema = "dft")
writeLines(collisions_ddl, con = "ddl_dft_stats19_collisions.sql")
casualties_ddl <- generate_table_ddl_from_yaml <- function(read_schema_yaml("inst/schemas/stats19_casualty.yml"),pg_schema = "dft")
writeLines(collisions_ddl, con = "ddl_dft_stats19_casualties.sql")
vehicles_ddl <- generate_table_ddl_from_yaml <- function(read_schema_yaml("inst/schemas/stats19_vehicle.yml"),pg_schema = "dft")
writeLines(vehicles_ddl, con = "ddl_dft_stats19_vehicle.sql")


