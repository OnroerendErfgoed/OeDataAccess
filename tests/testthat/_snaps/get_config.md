# unknown query names warn and are ignored

    Code
      config <- get_config(qry_cfg = queries_cfg, db_cfg = db_cfg, queries = c(
        "plots", "typo"))
    Condition
      Warning:
      Unknown query name(s), not defined in fixtures/queries.json: typo
    Code
      config$qry_cfg$name
    Output
      [1] "plots"

# duplicate query names error

    Code
      get_config(qry_cfg = test_path("fixtures", "queries_duplicate_names.json"),
      db_cfg = db_cfg)
    Condition
      Error:
      ! Duplicate query name(s) in fixtures/queries_duplicate_names.json: gridcells

# queries referring to undefined connections error

    Code
      get_config(qry_cfg = test_path("fixtures", "queries_unknown_connection.json"),
      db_cfg = db_cfg)
    Condition
      Error:
      ! Undefined database connection(s) in fixtures/queries_unknown_connection.json: oe_nonexistent

# queries referring to missing SQL files error

    Code
      get_config(qry_cfg = test_path("fixtures", "queries_missing_file.json"),
      db_cfg = db_cfg)
    Condition
      Error:
      ! SQL file(s) not found: fixtures/sql/does_not_exist.sql

