# Set up default configuration files

Writes template configuration files to the default locations
\`config/queries.json\` and \`config/db_config.json\`, relative to the
working directory, for use with \[get_config()\].

## Usage

``` r
setup_config()
```

## Value

Invisibly, a list with the paths of the created files: \`qry_cfg\` and
\`db_cfg\`.

## Details

This function is meant to be run once at the start of a project, in an
interactive session. It fails outside of interactive sessions and when
either of the files already exists, so existing configurations are never
overwritten.

The templates contain a single example query and database connection
each. After running this function, edit both files to describe your
queries and connections, and make sure every \`query_file\` points to an
existing SQL file. The required fields are described in
\[get_config()\].

## Examples

``` r
if (FALSE) { # \dontrun{
setup_config()
# edit config/queries.json and config/db_config.json, then:
config <- get_config()
datasets <- get_datasets(config)
} # }
```
