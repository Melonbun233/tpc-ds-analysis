#Load data into a new database with specified scaling factor
#This file is copied into the docker
#Usage: bash load-data.sh <scaling factor>
#!/bin/bash
name=tpcds

if [ $# -ne 1 ]
then 
  echo "usage: bash load-data.sh <scaling factor>"
else
  db=tpcds-$1

  echo "Creating a databse $db and load the schema..."
  createdb -U postgres -w -O postgres $db
  psql -U postgres -w $db -f tpcds.sql

  echo "Generating data..."
  mkdir data-$1
  ./dsdgen -SCALE $1 -FORCE -VERBOSE -DIR data-$1

  echo "Loading data into the databse..."
  #temporarily store the data in the volume
  mkdir /var/lib/postgresql/data/tmp
  mkdir /var/lib/postgresql/data/tmp/data-$1
  for i in `ls data-$1/*.dat`; do
    table=${i/.dat/}
    table=${table#*/}
    echo "Loading $table..."
    sed 's/|$//' $i > /var/lib/postgresql/data/tmp/$i
    psql tpcds-$1 -U postgres -w -q -c "TRUNCATE $table"
    psql tpcds-$1 -U postgres -w -c "\\copy $table FROM '/var/lib/postgresql/data/tmp/$i' CSV DELIMITER '|'"
  done
  #remove temp directory
  #rm -r /var/lib/postgresql/data/tmp
  echo "Data loaded into database $db"

fi