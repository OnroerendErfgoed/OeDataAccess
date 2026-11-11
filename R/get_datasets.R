#' Fetch datasets from the configured databases
#'
#' Executes every configured query on its configured database connection
#' and returns the results as a named list.
#'
#' @param config A configuration list as returned by [get_config()].
#'
#' @return A named list of data frames, with one element per selected query,
#'   named after the query.
#'
#' @details
#' For every query, the SQL file given by its `query_file` is read and
#' executed with [DBI::dbGetQuery()] on a connection pool for its
#' `connection`. One pool is set up per database connection and all pools
#' are closed when the function exits, also on error. When a query fails,
#' an error is raised naming the query, connection and file.
#'
#' @examples
#' \dontrun{
#' config <- get_config(queries = "gridcells")
#' datasets <- get_datasets(config)
#' str(datasets$gridcells)
#' }
#'
#' @export
#' @importFrom DBI dbGetQuery
#' @importFrom pool poolClose
#' @importFrom readr read_file
get_datasets <- function(config) {
  # setup connection pools
  pools <- get_connection_pools(config$db_cfg)
  on.exit({
    for (pool in pools) {
      poolClose(pool)
    }
  })

  datasets <- list()

  for (i in seq_len(nrow(config$qry_cfg))) {
    name <- config$qry_cfg$name[i]
    connection <- config$qry_cfg$connection[i]
    query_file <- config$qry_cfg$query_file[i]

    pool <- pools[[connection]]
    if (is.null(pool)) {
      stop("No connection pool available for query '", name,
           "': connection '", connection, "' is not defined in the database config.",
           call. = FALSE)
    }

    tryCatch({
      datasets[[name]] <- dbGetQuery(pool, read_file(query_file))
    }, error = function(e) {
      stop("Query '", name, "' failed (connection: ", connection,
           ", file: ", query_file, "): ", conditionMessage(e),
           call. = FALSE)
    })
  }

  return(datasets)
}
