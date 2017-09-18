FROM alpine:3.5@sha256:c0537ff6a5218ef531ece93d4984efc99bbf3f7497c0a7726c88e2bb7584dc96

ENV EASYRDF_DIST=easyrdf-0.9.0

RUN echo "http://dl-3.alpinelinux.org/alpine/v3.5/main/" > /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.5/community/" > /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.5/main/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.5/main/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories && \
    apk --no-cache update && \
    apk --no-cache add --update curl && \
    apk --no-cache add --update php7 && \
    apk --no-cache add --update php7-mbstring && \
    apk --no-cache add --update php7-curl && \
    apk --no-cache add --update graphviz && \
    mkdir /www && \
    wget -O /tmp/${EASYRDF_DIST}.tar.gz http://www.easyrdf.org/downloads/${EASYRDF_DIST}.tar.gz && \
    tar xzvf /tmp/${EASYRDF_DIST}.tar.gz -C /tmp && \
    mv /tmp/${EASYRDF_DIST}/lib /www/ && \
    rm -rf /tmp/easyrdf* && \
    rm -rf /var/cache/apk/*
COPY entrypoint.sh /
WORKDIR /www
ENTRYPOINT ["/entrypoint.sh"]
COPY www/* /www/
RUN  chmod 700 /entrypoint.sh && \
     patch -p0 -i /www/easyrdf.patch