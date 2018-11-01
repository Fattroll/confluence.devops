#!/bin/bash

gcloud auth configure-docker
docker build -t gcr.io/confluence-220616/jenkins:stage ../../docker.img/jenkins
docker push gcr.io/confluence-220616/jenkins:stage
