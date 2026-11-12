is_interactive <- function() {
  interactive()
}

queries_template <- c(
  "[",
  "  {",
  "    \"name\": \"gridcells\",",
  "    \"connection\": \"oe_local\",",
  "    \"query_file\": \"config/sql/gridcells.sql\"",
  "  }",
  "]"
)

db_config_template <- c(
  "[",
  "  {",
  "    \"name\": \"oe_local\",",
  "    \"dbname\": \"oe_inventaris\",",
  "    \"hostname\": \"localhost\"",
  "  }",
  "]"
)

#' Set up default configuration files
#'
#' Writes template configuration files to the default locations
#' `config/queries.json` and `config/db_config.json`, relative to the
#' working directory, for use with [get_config()].
#'
#' This function is meant to be run once at the start of a project, in an
#' interactive session. It fails outside of interactive sessions and when
#' either of the files already exists, so existing configurations are
#' never overwritten.
#'
#' @details
#' The templates contain a single example query and database connection
#' each. After running this function, edit both files to describe your
#' queries and connections, and make sure every `query_file` points to an
#' existing SQL file. The required fields are described in [get_config()].
#'
#' @return Invisibly, a list with the paths of the created files:
#'   `qry_cfg` and `db_cfg`.
#'
#' @examples
#' \dontrun{
#' setup_config()
#' # edit config/queries.json and config/db_config.json, then:
#' config <- get_config()
#' datasets <- get_datasets(config)
#' }
#'
#' @export
setup_config <- function() {
  if (!is_interactive()) {
    stop("`setup_config()` can only be used interactively.", call. = FALSE)
  }

  qry_cfg <- "config/queries.json"
  db_cfg <- "config/db_config.json"

  existing <- c(qry_cfg, db_cfg)[file.exists(c(qry_cfg, db_cfg))]
  if (length(existing) > 0) {
    stop(
      "Config file(s) already exist, refusing to overwrite: ",
      paste(existing, collapse = ", "),
      call. = FALSE
    )
  }

  if (!dir.exists("config")) {
    dir.create("config")
  }

  writeLines(queries_template, qry_cfg)
  writeLines(db_config_template, db_cfg)

  message(
    "Configuration files written:\n",
    "* ",
    qry_cfg,
    "\n",
    "* ",
    db_cfg,
    "\n",
    "Edit them before calling `get_config()`."
  )

  invisible(list(qry_cfg = qry_cfg, db_cfg = db_cfg))
}
