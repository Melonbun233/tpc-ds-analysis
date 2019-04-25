#script used to load data from outside the container
#usage bash load.sh <container name> <scaling factor>

if [ $# -eq 2 ]
then 
  name=$1
  scaling=$2

  script="bash load-data.sh $scaling"
  docker exec -i -t $name sh -c "$script"
else
  echo "Usage: bash load.sh <container name> <scaling factor>"
fi