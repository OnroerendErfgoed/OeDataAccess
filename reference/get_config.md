# Load query and database configuration

Reads the query configuration and database configuration from JSON files
and validates them against each other. The result is meant to be passed
to \[get_datasets()\].

## Usage

``` r
get_config(
  qry_cfg = "config/queries.json",
  db_cfg = "config/db_config.json",
  queries = c()
)
```

## Arguments

- qry_cfg:

  Path to the JSON file with the query configuration. Every query must
  have a \`name\`, a \`connection\` and a \`query_file\`.

- db_cfg:

  Path to the JSON file with the database configuration. Every
  connection must have a \`name\`, a \`dbname\` and a \`hostname\`, and
  can optionally have a \`username\` and a \`password\`.

- queries:

  Optional character vector of query names to select from \`qry_cfg\`.
  By default all queries are selected.

## Value

A list with two elements: \* \`qry_cfg\`: the query configuration,
filtered to \`queries\`. \* \`db_cfg\`: the database configuration,
filtered to the connections used by the selected queries.

## Details

An error is raised when: \* a query \`name\` occurs more than once in
\`qry_cfg\`, \* a query refers to a \`connection\` that is not defined
in \`db_cfg\`, \* a \`query_file\` does not exist on disk.

Query names in \`queries\` that are not defined in \`qry_cfg\` are
ignored, with a warning.

## Examples

``` r
if (FALSE) { # \dontrun{
config <- get_config(
  qry_cfg = "config/queries.json",
  db_cfg = "config/db_config.json",
  queries = c("example_query_name")
)
datasets <- get_datasets(config)
} # }
```
