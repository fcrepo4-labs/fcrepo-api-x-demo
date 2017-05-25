FROM alpine:3.5@sha256:c0537ff6a5218ef531ece93d4984efc99bbf3f7497c0a7726c88e2bb7584dc96
RUN echo "http://dl-3.alpinelinux.org/alpine/v3.5/main/" > /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/v3.5/community/" > /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.5/main/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.5/main/" >> /etc/apk/repositories && \
    echo "http://dl-5.alpinelinux.org/alpine/v3.5/community/" >> /etc/apk/repositories && \
    apk --no-cache update && \
    apk add --update curl && \
    apk add --update php7 && \
    apk add --update php7-mbstring && \
    apk add --update graphviz && \
    
    rm -rf /var/cache/apk/* && \
    mkdir /www
COPY www/* /www/
COPY entrypoint.sh /
WORKDIR /www
ENTRYPOINT ["/entrypoint.sh"]
