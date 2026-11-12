# Changelog

## OeDataAccess 0.1.0

- [`setup_config()`](https://onroerenderfgoed.github.io/OeDataAccess/reference/setup_config.md)
  is a new helper that writes template configuration files to the
  default location (`config/`). It can only be run interactively and
  fails when config files already exist, so configurations are never
  overwritten.
- [`get_datasets()`](https://onroerenderfgoed.github.io/OeDataAccess/reference/get_datasets.md)
  now reads the SQL query files with `read_file()` from the readr
  package, which is added as an import. Previously the function failed
  because `read_file()` was not defined.
