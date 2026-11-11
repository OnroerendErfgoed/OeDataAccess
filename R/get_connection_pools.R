#' Create a database connection pool
#'
#' Sets up a single [pool::dbPool()] connection pool for the database
#' connection named `poolname`.
#'
#' @param poolname Name of the database connection, matching a value in the
#'   `name` column of `config`.
#' @param config The database configuration, e.g. the `db_cfg` element of
#'   the configuration returned by [get_config()]. Must contain the columns
#'   `name`, `dbname` and `hostname`, and can optionally contain `username`
#'   and `password` columns.
#'
#' @return A `Pool` object.
#'
#' @details
#' Credentials are taken from the `username` and `password` columns of
#' `config` when present. Otherwise they are read from the system keyring
#' (`oe_db_username` and `oe_db_password`), after unlocking the keyring if
#' needed, prompting for the keyring password. This is for development
#' purposes, and will only work when the user has access to all databases.
#'
#' @export
get_pool <- function(poolname, config) {
    if ("username" %in% colnames(config)) {
        username <- config$username[config$name == poolname]
        password <- config$password[config$name == poolname]
    } else {
        if (keyring_is_locked()) {
            keyring_unlock(password = getPass())
        }
        username <- key_get("oe_db_username")
        password <- key_get("oe_db_password")
    }

    dbPool(
        drv = RPostgreSQL::PostgreSQL(),
        dbname = config$dbname[config$name == poolname],
        host = config$hostname[config$name == poolname],
        user = username,
        password = password
    )
}

#' Set up database connection pools
#'
#' Sets up a connection pool for every database connection named in
#' `config`, usually called via [get_datasets()].
#'
#' @param config The database configuration, e.g. the `db_cfg` element of
#'   the configuration returned by [get_config()]. Must contain the columns
#'   `name`, `dbname` and `hostname`, and can optionally contain `username`
#'   and `password` columns.
#'
#' @return A named list of `Pool` objects, one per connection, named after
#'   the connection.
#'
#' @details
#' Credential handling is described in [get_pool()]. If a pool cannot be
#' created, the pools set up so far are closed and an error naming the
#' connection is raised, so no connections are left open on the database
#' server side.
#'
#' @examples
#' \dontrun{
#' config <- get_config(queries = "gridcells")
#' pools <- get_connection_pools(config$db_cfg)
#' # always close the pools yourself when you created them manually
#' lapply(pools, pool::poolClose)
#' }
#'
#' @export
#' @importFrom pool dbPool
#' @importFrom keyring keyring_is_locked keyring_unlock key_get
#' @importFrom getPass getPass
get_connection_pools <- function(config) {
    pools <- list()
    for (name in config$name) {
        tryCatch(
            {
                pools[[name]] <- get_pool(name, config)
            },
            error = function(e) {
                # close pools created before this one failed, so no connections
                # are left open on the database server side
                for (pool in pools) {
                    poolClose(pool)
                }
                stop("Failed to set up connection pool for '", name, "': ",
                    conditionMessage(e),
                    call. = FALSE
                )
            }
        )
    }
    return(pools)
}
