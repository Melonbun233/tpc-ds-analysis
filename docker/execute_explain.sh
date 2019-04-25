#!/bin/bash
if [ $# -eq 1 ]; then
  if [ ! -d /var/lib/postgresql/data/explain ]; then
    mkdir /var/lib/postgresql/data/explain
    mkdir /var/lib/postgresql/data/explain/sf_$1
  fi

  if [ ! -d /var/lib/postgresql/data/explain/sf_$1 ]; then
    mkdir /var/lib/postgresql/data/explain/sf_$1
  fi

  path="query_explain/queries_$1/execute_all.sql"
  psql -U postgres -w -d tpcds-1 -A -f $path
else 
  echo "Usage: bash execute_sql.sh <Scaling Factor>"
fi