#!/usr/bin/env bash

DOCKER_HUB_USERNAME="tanyak1601"
IMAGE_NAME="nestjs-rest-api"
TAG="latest"
DOCKERFILE_DIRECTORY="/Users/Tatsiana_Krautsova2/Documents/devops-fundamentals-course/nestjs-rest-api"

docker login --username $DOCKER_HUB_USERNAME

docker build -f ${DOCKERFILE_DIRECTORY}/Dockerfile -t $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG ${DOCKERFILE_DIRECTORY}
docker tag $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG $DOCKER_HUB_USERNAME/$IMAGE_NAME:latest

docker push $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG

echo "Docker image successfully pushed."