imageName=tpcds
remote=melonbun233/tpcds:latest
remoteImage=latest

echo Building the image...
docker build -t $imageName .

echo Tagging with remote repository...
docker tag $imageName $remote

echo Pushing to the remote repository...
docker push $remote