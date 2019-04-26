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
  mkdir /var/lib/postgresql/data/tmp
  mkdir /var/lib/postgresql/data/tmp/data-$1
  ./dsdgen -SCALE $1 -FORCE -VERBOSE -DIR /var/lib/postgresql/data/tmp/data-$1

  echo "Loading data into the databse..."
  #temporarily store the data in the volume
  
  for i in `ls /var/lib/postgresql/data/tmp/data-$1/*.dat`; do
    table=${i/.dat/}
    table=${table#/var/lib/postgresql/data/tmp/data-$1/}
    echo "Loading $table..."
    sed 's/|$//' $i > /var/lib/postgresql/data/tmp/$table.dat
    psql tpcds-$1 -U postgres -w -q -c "TRUNCATE $table"
    psql tpcds-$1 -U postgres -w -c "\\copy $table FROM '/var/lib/postgresql/data/tmp/$table.dat' CSV DELIMITER '|'"
    #clear tmp data
    rm /var/lib/postgresql/data/tmp/$table.dat
  done
  #remove temp directory
  #rm -r /var/lib/postgresql/data/tmp
  echo "Data loaded into database $db"

fi