# Set up database connection pools

Sets up a connection pool for every database connection named in
\`config\`, usually called via \[get_datasets()\].

## Usage

``` r
get_connection_pools(config)
```

## Arguments

- config:

  The database configuration, e.g. the \`db_cfg\` element of the
  configuration returned by \[get_config()\]. Must contain the columns
  \`name\`, \`dbname\` and \`hostname\`, and can optionally contain
  \`username\` and \`password\` columns.

## Value

A named list of \`Pool\` objects, one per connection, named after the
connection.

## Details

Credential handling is described in \[get_pool()\]. If a pool cannot be
created, the pools set up so far are closed and an error naming the
connection is raised, so no connections are left open on the database
server side.

## Examples

``` r
if (FALSE) { # \dontrun{
config <- get_config(queries = "gridcells")
pools <- get_connection_pools(config$db_cfg)
# always close the pools yourself when you created them manually
lapply(pools, pool::poolClose)
} # }
```
