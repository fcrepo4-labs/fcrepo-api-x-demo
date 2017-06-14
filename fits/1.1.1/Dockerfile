FROM tomcat:8.5.15-jre8-alpine@sha256:eaf901f324d9f49a492270b28669b32a2d7b418db8c649c2268531ddefaa0b01

ENV FITS_VERSION=1.1.1 \
    FITS_WEB_VERSION=1.1.3
ENV FITS_HOME=/opt/fits-${FITS_VERSION}
 

# Fits home dir and dependencies
RUN mkdir -p ${FITS_HOME} && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.6/main/" > /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.6/community/" > /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.6/main/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.6/community/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.6/main/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.6/community/" >> /etc/apk/repositories && \
    apk --no-cache add file-dev curl

# Fits core
RUN curl -SL http://projects.iq.harvard.edu/files/fits/files/fits-${FITS_VERSION}.zip \
    > /opt/fits-${FITS_VERSION}.zip && \
    unzip /opt/fits-${FITS_VERSION}.zip -d /opt  && \
    rm /opt/fits-${FITS_VERSION}.zip

# Fits webapp
RUN  wget -O ${CATALINA_HOME}/webapps/fits.war \
 http://projects.iq.harvard.edu/files/fits/files/fits-${FITS_WEB_VERSION}.war \
    && echo "fits.home=${FITS_HOME}" \
     >> ${CATALINA_HOME}/conf/catalina.properties \
    && echo "shared.loader=\${fits.home}/lib/*.jar" \
     >> ${CATALINA_HOME}/conf/catalina.properties

COPY entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
