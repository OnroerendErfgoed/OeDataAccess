# Create a database connection pool

Sets up a single \[pool::dbPool()\] connection pool for the database
connection named \`poolname\`.

## Usage

``` r
get_pool(poolname, config)
```

## Arguments

- poolname:

  Name of the database connection, matching a value in the \`name\`
  column of \`config\`.

- config:

  The database configuration, e.g. the \`db_cfg\` element of the
  configuration returned by \[get_config()\]. Must contain the columns
  \`name\`, \`dbname\` and \`hostname\`, and can optionally contain
  \`username\` and \`password\` columns.

## Value

A \`Pool\` object.

## Details

Credentials are taken from the \`username\` and \`password\` columns of
\`config\` when present. Otherwise they are read from the system keyring
(\`oe_db_username\` and \`oe_db_password\`), after unlocking the keyring
if needed, prompting for the keyring password. This is for development
purposes, and will only work when the user has access to all databases.
