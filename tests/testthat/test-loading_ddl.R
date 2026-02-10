test_that("rename_to_metadata renames mapped columns", {
  cols <- c("a", "b", "c")
  map <- c(a = "alpha", b = "beta")

  out <- rename_to_metadata(cols, map)

  expect_equal(out, c("alpha", "beta", "c"))
})

test_that("rename_to_metadata preserves order", {
  cols <- c("b", "a")
  map <- c(a = "alpha", b = "beta")

  expect_equal(rename_to_metadata(cols, map),
               c("beta", "alpha"))
})

test_that("rename_to_metadata works with empty map", {
  cols <- c("x", "y")

  expect_equal(rename_to_metadata(cols, c()),
               cols)
})

test_that("header contains datastore path", {
  script <- build_load_script_header("file.csv", "folder")

  expect_match(script, "INPUT=\"\\$DATASTORE/folder/file.csv\"")
})

test_that("header contains file existence check", {
  script <- build_load_script_header("file.csv", "folder")

  expect_match(script, "Missing input file")
})

test_that("footer contains copy command", {
  script <- build_load_script_footer("collisions", 2024)

  expect_match(script, "\\\\copy staging.dft_collisions")
})

test_that("footer contains promote call", {
  script <- build_load_script_footer("collisions", 2024)

  expect_match(script, "import_dft_collisions_2024")
})

test_that("landing script contains CREATE TABLE", {

  script <- build_landing_table_script(
    pg_table_name = "collisions",
    column_names = c("a", "b"),
    file_name = "file.csv",
    file_folder = "folder",
    import_schema = "landing"
  )

  expect_match(script, "CREATE TABLE IF NOT EXISTS landing.dft_collisions")
})

test_that("landing script creates TEXT columns", {

  script <- build_landing_table_script(
    "collisions",
    c("a", "b"),
    "file.csv",
    "folder",
    "landing"
  )

  expect_match(script, "a TEXT")
  expect_match(script, "b TEXT")
})

test_that("build_loading_ddl applies metadata renaming", {

  raw_cols <- c("a_raw", "b")
  map <- c(a_raw = "a")

  script <- build_loading_ddl(
    pg_table_name = "collisions",
    raw_column_names = raw_cols,
    meta_name_map = map,
    file_name = "file.csv"
  )

  expect_match(script, "a TEXT")
  expect_match(script, "b TEXT")
})

test_that("build_loading_ddl errors on empty column vector", {

  expect_error(
    build_loading_ddl(
      "collisions",
      character(0),
      c(),
      "file.csv"
    )
  )
})

