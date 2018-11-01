FROM openjdk:8-jdk-alpine

RUN apk add --no-cache git openssh-client curl unzip bash ttf-dejavu coreutils tini

ARG JENKINS_HOME="/var/jenkins_home"
ARG JENKINS_PATH="/usr/share/jenkins/"

RUN mkdir -p $JENKINS_HOME \
  && chown 1000:1000 $JENKINS_HOME \
  && addgroup -g 1000 jenkins \
  && adduser -h "$JENKINS_HOME" -u 1000 -G jenkins -s /bin/bash -D jenkins \
  && mkdir -p $JENKINS_PATH


VOLUME $JENKINS_HOME

EXPOSE 8080


ARG JENKINS_URL=http://mirrors.jenkins.io/war-stable/latest/jenkins.war
RUN curl -fsSL ${JENKINS_URL} -o $JENKINS_PATH/jenkins.war

USER jenkins

# ENV JENKINS_UC https://updates.jenkins.io
# ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
# ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
RUN chown -R jenkins "$JENKINS_HOME"
ENTRYPOINT  [ "java", "-jar", "/usr/share/jenkins/jenkins.war" ]
