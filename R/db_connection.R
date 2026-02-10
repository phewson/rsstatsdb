library(DBI)
library(RPostgres)

create_connection <- function() {
  conn <- dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("PGDATABASE"),
    host   = Sys.getenv("PGHOST"),
    port   = Sys.getenv("PGPORT"),
    user   = Sys.getenv("PGUSER")
  )
  return(conn)
}
