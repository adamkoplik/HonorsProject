#!/bin/bash

echo "Build the docker"

docker build . --progress=plain \
               --build-arg QUARTO_VERSION=1.1.149 \
               --build-arg CONDA_ENV=flex_dashboard \
               --build-arg PYTHON_VER=3.8 \
               -t adamkoplik/flex_dash_env:dev.0.0.0.9000

if [[ $? = 0 ]] ; then
echo "Pushing docker..."
docker push adamkoplik/flex_dash_env:dev.0.0.0.9000
else
echo "Docker build failed"
fi