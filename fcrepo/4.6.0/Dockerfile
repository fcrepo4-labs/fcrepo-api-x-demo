FROM emetsger/apix-build:latest 

ENV FCREPO_VERSION 4.6.0
ENV FCREPO_RUNTIME /opt/fcrepo/${FCREPO_VERSION}
ENV FCREPO_PORT    8080
ENV DEBUG_PORT     5006

EXPOSE ${FCREPO_PORT}
EXPOSE ${DEBUG_PORT}
    
RUN export FCREPO_JAR=fcrepo-webapp-${FCREPO_VERSION}-jetty-console.jar                                 && \
    mkdir -p ${FCREPO_RUNTIME}                                                                          && \
    curl -L https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-${FCREPO_VERSION}/${FCREPO_JAR}    \
        > /tmp/${FCREPO_JAR}

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
