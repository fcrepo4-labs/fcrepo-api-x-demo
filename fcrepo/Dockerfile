FROM apix-poc/build:latest 

ENV FCREPO_RUNTIME /opt/fcrepo
ENV FCREPO_VERSION 4.5.0
ENV FCREPO_PORT    8080

    
RUN export FCREPO_JAR=fcrepo-webapp-${FCREPO_VERSION}-jetty-console.jar                                 && \
    mkdir -p ${FCREPO_RUNTIME}                                                                          && \
    curl -L https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-${FCREPO_VERSION}/${FCREPO_JAR}    \
        > /tmp/${FCREPO_JAR}

CMD java -Dfcrepo.home=${FCREPO_RUNTIME}                             \
         -jar /tmp/fcrepo-webapp-${FCREPO_VERSION}-jetty-console.jar \
         --port ${FCREPO_PORT}                                       \
         --headless 2>&1
