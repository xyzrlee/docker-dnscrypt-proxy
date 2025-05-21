ARG BASE_IMAGE=debian:bookworm

FROM ${BASE_IMAGE} AS builder

ARG VERSION=
ARG SYSTEM=linux
ARG ARCH=x86_64
ARG TMP_DIR=/tmp/build

RUN set -ex \
      && apt-get update \
      && apt-get install -y wget \
      && mkdir -p ${TMP_DIR} \
      && cd ${TMP_DIR} \
      && wget -O dnscrypt-proxy.tar.gz https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/${VERSION}/dnscrypt-proxy-${SYSTEM}_${ARCH}-${VERSION}.tar.gz \
      && tar zxvf dnscrypt-proxy.tar.gz \
      && cd ${SYSTEM}-${ARCH} \
      && mv -v dnscrypt-proxy /usr/local/bin \
      && cd / \
      && rm -rfv ${TMP_DIR} \
      && dnscrypt-proxy -version

# -------

FROM ${BASE_IMAGE}

COPY --from=builder /usr/local/bin/dnscrypt-proxy /usr/local/bin/
COPY entrypoint.sh /

RUN set -ex \
      && apt-get update \
      && apt-get install -y ca-certificates \
      && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]
