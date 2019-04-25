#!/bin/bash
if [ $# -eq 1 ]; then
  if [ ! -d /var/lib/postgresql/data/analyze ]; then
    mkdir /var/lib/postgresql/data/analyze
    mkdir /var/lib/postgresql/data/analyze/sf_$1
  fi

  if [ ! -d /var/lib/postgresql/data/analyze/sf_$1 ]; then
    mkdir /var/lib/postgresql/data/analyze/sf_$1
  fi

  path="query_analyze/queries_$1/execute_all.sql"
  psql -U postgres -w -d tpcds-$i -A -f $path
else 
  echo "Usage: bash execute_sql.sh <Scaling Factor>"
fi