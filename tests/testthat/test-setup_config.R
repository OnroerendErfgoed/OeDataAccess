local_config_dir <- function() {
  dir <- tempfile("setup_config-")
  dir.create(dir, recursive = TRUE)
  dir
}

test_that("setup_config() requires an interactive session", {
  # testthat runs tests in a non-interactive session, so this is the
  # real error path
  withr::with_dir(local_config_dir(), {
    expect_snapshot(setup_config(), error = TRUE)
  })
})

test_that("setup_config() writes valid templates to the default location", {
  withr::with_dir(local_config_dir(), {
    local_mocked_bindings(is_interactive = function() TRUE)

    paths <- setup_config()

    expect_identical(
      paths,
      list(qry_cfg = "config/queries.json", db_cfg = "config/db_config.json")
    )

    qry <- jsonlite::read_json("config/queries.json", simplifyVector = TRUE)
    expect_s3_class(qry, "data.frame")
    expect_named(qry, c("name", "connection", "query_file"))
    expect_snapshot(qry$name)

    db <- jsonlite::read_json("config/db_config.json", simplifyVector = TRUE)
    expect_s3_class(db, "data.frame")
    expect_named(db, c("name", "dbname", "hostname"))
    expect_snapshot(db$name)
  })
})

test_that("fresh templates are read by get_config() up to the missing SQL file", {
  withr::with_dir(local_config_dir(), {
    local_mocked_bindings(is_interactive = function() TRUE)

    setup_config()

    expect_snapshot(get_config(), error = TRUE)
  })
})

test_that("setup_config() fails when config files already exist", {
  withr::with_dir(local_config_dir(), {
    local_mocked_bindings(is_interactive = function() TRUE)

    setup_config()

    expect_snapshot(setup_config(), error = TRUE)
  })
})

test_that("setup_config() fails when only one config file exists", {
  withr::with_dir(local_config_dir(), {
    local_mocked_bindings(is_interactive = function() TRUE)

    dir.create("config")
    writeLines("[]", "config/queries.json")

    expect_snapshot(setup_config(), error = TRUE)
  })
})
