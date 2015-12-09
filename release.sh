#!/bin/bash
set -e

docker build -t --no-cache quay.io/trackmaven/elasticsearch:1.7 1.7
docker push quay.io/trackmaven/elasticsearch:1.7
docker build -t --no-cache quay.io/trackmaven/elasticsearch:2.1 2.1
docker push quay.io/trackmaven/elasticsearch:2.1
