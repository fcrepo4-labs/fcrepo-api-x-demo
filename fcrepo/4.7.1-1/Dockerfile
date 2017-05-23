FROM tomcat:8.5-jre8-alpine@sha256:7ba4d49795a3783d08cc53b896616a0397ae8a3cf61ecb4c0b77ebd45cce3b76

ENV FCREPO_VERSION      4.7.1
ENV FCREPO_WEBAPP       fcrepo-${FCREPO_VERSION}/fcrepo-webapp-${FCREPO_VERSION}.war
ENV FCREPO_HOST         localhost
ENV FCREPO_PORT         80
ENV FCREPO_CONTEXT_PATH /fcrepo
ENV FCREPO_LOG_LEVEL    INFO
ENV DEBUG_PORT          5006
ENV DEBUG_ARG           "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=\${DEBUG_PORT}"

EXPOSE ${DEBUG_PORT}
EXPOSE ${FCREPO_PORT}

# Fcrepo webapp
RUN echo "http://dl-3.alpinelinux.org/alpine/v3.5/main/" > /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.5/community/" > /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.5/main/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.5/main/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories && \
    apk --no-cache update   && \
    apk --no-cache add         \
      curl                     \
      gettext                  \
      git                      \
      maven                    \
      openjdk8                 \
      net-tools             && \
    rm -rf /var/cache/apk/* && \

    git clone https://github.com/fcrepo4/fcrepo4.git                                     && \
    cd fcrepo4                                                                           && \
    git config --global user.email "emetsger@jhu.edu"                                    && \
    git config --global user.name "Fcrepo API-X Container"                               && \
    git checkout -b 4.7.1 fcrepo-4.7.1                                                   && \
    git cherry-pick 447728cf                                                             && \
    git cherry-pick da933468                                                             && \
    PATH=/usr/lib/jvm/java-1.8-openjdk/bin:$PATH JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
      mvn clean verify -Djavadoc.skip -Dcheckstyle.skip -Denforcer.skip -DskipTests      && \
    cp fcrepo-webapp/target/fcrepo-webapp-4.7.1.war \
      ${CATALINA_HOME}/webapps/fcrepo.war                                                && \
    echo "fcrepo.modeshape.configuration=classpath:/config/file-simple/repository.json" \
      >> ${CATALINA_HOME}/conf/catalina.properties \                                     && \
    echo "org.apache.catalina.webresources.Cache.level = SEVERE" \
      >> ${CATALINA_HOME}/conf/logging.properties                                        && \
    cd ..                                                                                && \
    rm -rf fcrepo4                                                                       && \
    rm -rf /build/repository                                                             && \
    rm -rf ~/.m2

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
