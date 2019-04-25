#!/bin/bash
if [ $# -eq 1 ]; then
  path="query_analyze/queries_$1/execute_all.sql"
  psql -U postgres -w -d tpcds-$1 -A -f $path
else 
  echo "Usage: bash execute_sql.sh <Scaling Factor>"
fi