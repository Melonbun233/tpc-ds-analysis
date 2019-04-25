#!/bin/bash
#start the container
volumePath=/Users/melonbun/workspace/tpc-ds/docker/postgres-data/
port=9876

if [ $# -eq 1 ]
then
  name=$1
  echo Checking volume...
  #checking if we have postgres-data/ directory
  if [ -d $volumePath ]
  then
    echo "Volume already exists"
  else
    mkdir $volumePath
    echo "Volume created as $volumePath"
  fi

  # Starting a new container with postgres data mounted at volumePath
  docker run -d --name $name -v $volumePath:/var/lib/postgresql/data -p $port:5432 melonbun233/tpcds 
  echo "Container started, listening port $port"

else
  echo "Usage: bash start.sh <container name>"
fi




