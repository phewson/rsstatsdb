test_that("cast strategy works", {
  expect_equal(
    col_expr("speed_limit", "cast", "int"),
    "s.speed_limit::int AS speed_limit"
  )
})

test_that("enum strategy works", {
  expect_equal(
    col_expr("junction_detail", "enum", "dft.stats19_junction_detail"),
    "junction_detail.label::dft.stats19_junction_detail AS junction_detail"
  )
})

test_that("postgis strategy returns geometry SQL", {
  expect_match(
    col_expr("ignored", "postgis"),
    "ST_SetSRID"
  )
})

test_that("dtg strategy returns timestamp SQL", {
  expect_match(
    col_expr("ignored", "dtg"),
    "to_timestamp"
  )
})

test_that("invalid field errors", {
  expect_error(col_expr(1, "cast", "int"))
  expect_error(col_expr(c("a","b"), "cast", "int"))
})

test_that("invalid target errors", {
  expect_error(col_expr("x", "cast", 123))
  expect_error(col_expr("x", "cast", c("a","b")))
})

test_that("unknown strategy errors", {
  expect_error(
    col_expr("x", "banana", "int"),
    "Unknown strategy"
  )
})
