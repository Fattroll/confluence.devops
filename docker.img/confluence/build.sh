#!/bin/bash

gcloud auth configure-docker
docker build -t gcr.io/confluence-220616/confluence:0.1 ../../docker.img/confluence
docker push gcr.io/confluence-220616/confluence:0.1
