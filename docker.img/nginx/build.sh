#!/bin/bash

gcloud auth configure-docker
docker build -t gcr.io/confluence-220616/proxy:stage ../../docker.img/nginx
docker push gcr.io/confluence-220616/proxy:stage
