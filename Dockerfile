#
# Dockerfile for dnscrypt-proxy
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

RUN set -ex \
 && apk add --no-cache dnscrypt-proxy

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["dnscrypt-proxy"]
