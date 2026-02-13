test_that("cast strategy works", {
  expect_equal(
    build_column_select_sql("speed_limit", "cast", "int"),
    "s.speed_limit::int AS speed_limit"
  )
})

test_that("enum strategy works", {
  expect_equal(
    build_column_select_sql("junction_detail", "enum", "dft.stats19_junction_detail"),
    "junction_detail.label::dft.stats19_junction_detail AS junction_detail"
  )
})

test_that("postgis strategy returns geometry SQL", {
  expect_match(
    build_column_select_sql("ignored", "postgis"),
    "ST_SetSRID"
  )
})

test_that("dtg strategy returns timestamp SQL", {
  expect_match(
    build_column_select_sql("ignored", "dtg"),
    "to_timestamp"
  )
})

test_that("invalid field errors", {
  expect_error(build_column_select_sql(1, "cast", "int"))
  expect_error(build_column_select_sql(c("a","b"), "cast", "int"))
})

test_that("invalid target errors", {
  expect_error(build_column_select_sql("x", "cast", 123))
  expect_error(build_column_select_sql("x", "cast", c("a","b")))
})

test_that("unknown strategy errors", {
  expect_error(
    build_column_select_sql("x", "banana", "int"),
    "Unknown strategy"
  )
})
