FROM alpine:3.4

MAINTAINER Elliot Metsger <emetsger@jhu.edu>
LABEL description = "Provides a Java 8 JDK, Git, Maven, and a seeded Maven repository under ${MAVEN_REPO}"

# Packages:
# - java 'openjdk8'
# - maven 'maven'
# - git 'git'

# Add the APK 'testing' repository (contains 'maven')

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Update repository contents and add packages

RUN apk --no-cache update   && \
    apk add                    \
       openjdk8                \
       maven                   \
       git

# Prepare the Maven repository

ENV MAVEN_REPO /build/repository

RUN mkdir -p ${MAVEN_REPO}

WORKDIR /tmp

RUN \

    # Simple project used for mvn commands below
    echo "<project> <modelVersion>4.0.0</modelVersion> <groupId>foo</groupId> <artifactId>bar</artifactId> <version>1.0-SNAPSHOT</version> </project>" > pom.xml && \

    # Seed various artifacts likely to be used, saving some time when running this container.
    mvn -Dmaven.repo.local=${MAVEN_REPO} org.apache.maven.plugins:maven-clean-plugin:3.0.0:clean && \
    mvn -Dmaven.repo.local=${MAVEN_REPO} org.apache.maven.plugins:maven-compiler-plugin:3.5.1:compile && \
    mvn -Dmaven.repo.local=${MAVEN_REPO} org.apache.maven.plugins:maven-install-plugin:2.5.2:install -Dskip || true && \
    mvn -Dmaven.repo.local=${MAVEN_REPO} org.apache.maven.plugins:maven-surefire-plugin:2.19.1:test && \
    mvn -Dmaven.repo.local=${MAVEN_REPO} org.apache.maven.plugins:maven-verifier-plugin:1.1:verify || true && \
    rm pom.xml               && \
    rm -rf target/           && \
    rm -rf ${MAVEN_REPO}/foo
