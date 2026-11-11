# OeDataAccess 0.1.0

* `setup_config()` is a new helper that writes template configuration files to
  the default location (`config/`). It can only be run interactively and
  fails when config files already exist, so configurations are never
  overwritten.
* `get_datasets()` now reads the SQL query files with `read_file()` from the
  readr package, which is added as an import. Previously the function failed
  because `read_file()` was not defined.

