#!/bin/bash
#removing the existing container and restarting a new one

if [ $# -eq 1 ]
then 
  name=$1

  echo "Stopping and removing the container..."
  docker container rm $name --force

  bash start.sh $name
else
  echo "Usage: bash restart.sh <container name>"
fi