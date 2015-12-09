#!/bin/bash
set -e

docker build --no-cache -t quay.io/trackmaven/elasticsearch:1.7 1.7
docker push quay.io/trackmaven/elasticsearch:1.7
docker build --no-cache -t quay.io/trackmaven/elasticsearch:2.1 2.1
docker push quay.io/trackmaven/elasticsearch:2.1
