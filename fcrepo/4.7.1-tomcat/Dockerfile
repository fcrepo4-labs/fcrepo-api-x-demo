FROM tomcat:8.5-jre8-alpine

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
RUN apk --no-cache update   && \
    apk --no-cache add         \
      curl                     \
      gettext                  \
      net-tools             && \
    rm -rf /var/cache/apk/* && \
 curl -L \
 https://github.com/fcrepo4/fcrepo4/releases/download/${FCREPO_WEBAPP} \
    > ${CATALINA_HOME}/webapps/fcrepo.war \
 && echo "fcrepo.modeshape.configuration=classpath:/config/file-simple/repository.json" \
    >> ${CATALINA_HOME}/conf/catalina.properties \
 && echo "org.apache.catalina.webresources.Cache.level = SEVERE" \
    >> ${CATALINA_HOME}/conf/logging.properties

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
