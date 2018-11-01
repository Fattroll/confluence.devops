#!/bin/bash

gcloud auth configure-docker
docker build -t gcr.io/confluence-220616/jenkins:0.1 ../../docker.img/jenkins
docker push gcr.io/confluence-220616/jenkins:0.1
