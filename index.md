# OeDataAcces

R package for config based data fetching from PostgreSQL databases in R.

The package is intended to facilitate config based execution of set of
SQL queries against a set of PostGreSQL database backends. The general
wrokflow is:

- configure database connections in a JSON files
- register SQL files (one query per file) in a config file that matches
  them with a connection
- run `get_datasets(get_config(), queries)` where queries is a list of
  names of registered queries.

The primary use case is ease database access in Quarto documents. Here
you can list the database queries in the yaml header, which makes it
easy to identify the data that is used by the Quarto document.

The
[`get_datasets()`](https://onroerenderfgoed.github.io/OeDataAccess/reference/get_datasets.md)
function handles connection setup and pooling, fetching the data, and
connection pool cleanup. It returns a list of datsets, where the name of
the dataset corresponds to the configured query name.

## Installation

Install the library using devtools.

``` r

library(devtools)
install_github('OnroerendErfgoed/OeDataAccess')
```

## Usage

``` r

library(OeDataAccess)

queries <- c("query1","query2")

#config takes a qry_cfg and db_cfg file, but defaults to
# `config/queries.json` and `config/db_config.json`
config <- get_config()

datasets <- get_datasets(config, queries)

head(datasets$query1)
```

To get started quickly, you can generate a config template in the
default location in an interactive R session:

``` r

library(OeDataAcces)

setup_config()
```
