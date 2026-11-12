# Fetch datasets from the configured databases

Executes every configured query on its configured database connection
and returns the results as a named list.

## Usage

``` r
get_datasets(config)
```

## Arguments

- config:

  A configuration list as returned by \[get_config()\].

## Value

A named list of data frames, with one element per selected query, named
after the query.

## Details

For every query, the SQL file given by its \`query_file\` is read and
executed with \[DBI::dbGetQuery()\] on a connection pool for its
\`connection\`. One pool is set up per database connection and all pools
are closed when the function exits, also on error. When a query fails,
an error is raised naming the query, connection and file.

## Examples

``` r
if (FALSE) { # \dontrun{
config <- get_config(queries = "gridcells")
datasets <- get_datasets(config)
str(datasets$gridcells)
} # }
```
