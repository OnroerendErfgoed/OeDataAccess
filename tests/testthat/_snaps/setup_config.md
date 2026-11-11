# setup_config() requires an interactive session

    Code
      setup_config()
    Condition
      Error:
      ! `setup_config()` can only be used interactively.

# setup_config() writes valid templates to the default location

    Code
      qry$name
    Output
      [1] "gridcells"

---

    Code
      db$name
    Output
      [1] "oe_local"

# fresh templates are read by get_config() up to the missing SQL file

    Code
      get_config()
    Condition
      Error:
      ! SQL file(s) not found: config/sql/gridcells.sql

# setup_config() fails when config files already exist

    Code
      setup_config()
    Condition
      Error:
      ! Config file(s) already exist, refusing to overwrite: config/queries.json, config/db_config.json

# setup_config() fails when only one config file exists

    Code
      setup_config()
    Condition
      Error:
      ! Config file(s) already exist, refusing to overwrite: config/queries.json

