#!/usr/bin/env bash

echo "BASE_IMAGE=${BASE_IMAGE}"
echo "VERSION=${VERSION}"
echo "SYSTEM=${SYSTEM}"
echo "TMP_DIR=${TMP_DIR}"

build_args="--build-arg"

if [ -n "${BASE_IMAGE}" ]
then
  build_args="${build_args} BASE_IMAGE=${BASE_IMAGE}"
fi
if [ -n "${VERSION}" ]
then
  build_args="${build_args} VERSION=${VERSION}"
fi
if [ -n "${SYSTEM}" ]
then
  build_args="${build_args} SYSTEM=${SYSTEM}"
fi
if [ -n "${TMP_DIR}" ]
then
  build_args="${build_args} TMP_DIR=${TMP_DIR}"
fi

echo "build_args=${build_args}"

docker buildx build --progress plain --debug ${build_args} -t dnscrypt-proxy .

