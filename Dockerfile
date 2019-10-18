#
# Dockerfile for dnscrypt-proxy
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

RUN set -ex \
    && cat "http://dl-cdn.alpinelinux.org/alpine/edge/community" >>/etc/apk/repositories \
    && apk add -U --no-cache dnscrypt-proxy

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["dnscrypt-proxy"]
