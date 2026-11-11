#' Load query and database configuration
#'
#' Reads the query configuration and database configuration from JSON files
#' and validates them against each other. The result is meant to be passed to
#' [get_datasets()].
#'
#' @param qry_cfg Path to the JSON file with the query configuration. Every
#'   query must have a `name`, a `connection` and a `query_file`.
#' @param db_cfg Path to the JSON file with the database configuration.
#'   Every connection must have a `name`, a `dbname` and a `hostname`, and
#'   can optionally have a `username` and a `password`.
#' @param queries Optional character vector of query names to select from
#'   `qry_cfg`. By default all queries are selected.
#'
#' @return A list with two elements:
#'   * `qry_cfg`: the query configuration, filtered to `queries`.
#'   * `db_cfg`: the database configuration, filtered to the connections
#'     used by the selected queries.
#'
#' @details
#' An error is raised when:
#' * a query `name` occurs more than once in `qry_cfg`,
#' * a query refers to a `connection` that is not defined in `db_cfg`,
#' * a `query_file` does not exist on disk.
#'
#' Query names in `queries` that are not defined in `qry_cfg` are ignored,
#' with a warning.
#'
#' @examples
#' \dontrun{
#' config <- get_config(
#'   qry_cfg = "config/queries.json",
#'   db_cfg = "config/db_config.json",
#'   queries = "gridcells"
#' )
#' datasets <- get_datasets(config)
#' }
#'
#' @export
#' @importFrom jsonlite read_json
get_config <- function(qry_cfg = "config/queries.json",
                       db_cfg = "config/db_config.json",
                       queries = c()) {
  qry_conf <- read_json(qry_cfg, simplifyVector = TRUE)
  db_conf <- read_json(db_cfg, simplifyVector = TRUE)

  if (anyDuplicated(qry_conf$name)) {
    duplicated_names <- unique(qry_conf$name[duplicated(qry_conf$name)])
    stop("Duplicate query name(s) in ", qry_cfg, ": ",
         paste(duplicated_names, collapse = ", "), call. = FALSE)
  }

  config <- list()

  if (length(queries) > 0) {
    unknown <- setdiff(queries, qry_conf$name)
    if (length(unknown) > 0) {
      warning("Unknown query name(s), not defined in ", qry_cfg, ": ",
              paste(unknown, collapse = ", "), call. = FALSE)
    }
    config$qry_cfg <- subset(qry_conf, name %in% queries)
  } else {
    config$qry_cfg <- qry_conf
  }

  missing_connections <- setdiff(config$qry_cfg$connection, db_conf$name)
  if (length(missing_connections) > 0) {
    stop("Undefined database connection(s) in ", qry_cfg, ": ",
         paste(missing_connections, collapse = ", "), call. = FALSE)
  }

  missing_files <- config$qry_cfg$query_file[!file.exists(config$qry_cfg$query_file)]
  if (length(missing_files) > 0) {
    stop("SQL file(s) not found: ",
         paste(missing_files, collapse = ", "), call. = FALSE)
  }

  config$db_cfg <- subset(db_conf, name %in% config$qry_cfg$connection)

  return(config)
}
