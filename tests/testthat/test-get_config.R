queries_cfg <- test_path("fixtures", "queries.json")
db_cfg <- test_path("fixtures", "db_config.json")

test_that("all queries are selected by default", {
  config <- get_config(qry_cfg = queries_cfg, db_cfg = db_cfg)

  expect_named(config, c("qry_cfg", "db_cfg"))
  expect_s3_class(config$qry_cfg, "data.frame")
  expect_s3_class(config$db_cfg, "data.frame")
  expect_setequal(config$qry_cfg$name, c("gridcells", "plots", "species_per_sector"))
})

test_that("only connections used by the queries are returned", {
  config <- get_config(qry_cfg = queries_cfg, db_cfg = db_cfg)

  # oe_archive is defined in the db config but used by no query
  expect_setequal(config$db_cfg$name, c("oe_local", "oe_foreign"))
})

test_that("queries selects a subset of queries and connections", {
  config <- get_config(qry_cfg = queries_cfg, db_cfg = db_cfg, queries = "plots")

  expect_setequal(config$qry_cfg$name, "plots")
  expect_setequal(config$db_cfg$name, "oe_local")
})

test_that("unknown query names warn and are ignored", {
  expect_snapshot({
    config <- get_config(
      qry_cfg = queries_cfg,
      db_cfg = db_cfg,
      queries = c("plots", "typo")
    )
    config$qry_cfg$name
  })
})

test_that("duplicate query names error", {
  expect_snapshot(
    get_config(
      qry_cfg = test_path("fixtures", "queries_duplicate_names.json"),
      db_cfg = db_cfg
    ),
    error = TRUE
  )
})

test_that("queries referring to undefined connections error", {
  expect_snapshot(
    get_config(
      qry_cfg = test_path("fixtures", "queries_unknown_connection.json"),
      db_cfg = db_cfg
    ),
    error = TRUE
  )
})

test_that("queries referring to missing SQL files error", {
  expect_snapshot(
    get_config(
      qry_cfg = test_path("fixtures", "queries_missing_file.json"),
      db_cfg = db_cfg
    ),
    error = TRUE
  )
})
