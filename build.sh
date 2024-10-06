#!/bin/bash 

REVISION=$(git log -1 --pretty=%h)
VERSION=$2
BASE_IMAGE="bookworm-slim"
REPO="vsrv-01.local:5443/vkorobov/$1:"
TAG="$REPO$VERSION-$BASE_IMAGE"
LATEST="${REPO}latest"
BUILD_TIMESTAMP=$( date -u '+%F %T %Z' )
#docker build -t "$TAG" -t "$LATEST" --build-arg BASE_IMAGE="$BASE_IMAGE" --build-arg VERSION="$VERSION" --build-arg BUILD_TIMESTAMP="$BUILD_TIMESTAMP" --build-arg REVISION="$REVISION" . 
docker buildx build --platform linux/arm64 -t $TAG -t $LATEST --build-arg BASE_IMAGE="$BASE_IMAGE" --build-arg VERSION="$VERSION" --build-arg BUILD_TIMESTAMP="$BUILD_TIMESTAMP" --build-arg REVISION="$REVISION"  --push $1
#docker buildx build --platform linux/arm64,linux/amd64 -t vsrv-01.local:5443/vkorobov/dump1090-fa:9.0.1  --push .

#docker push "$TAG" 
#docker push "$LATEST"
