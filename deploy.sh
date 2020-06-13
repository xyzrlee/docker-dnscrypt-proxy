#!/bin/bash

set -e

if [[ "${TRAVIS_BRANCH}" != "${DOCKERHUB_BUILD_BRANCH}" ]]
then
    echo "branch [${TRAVIS_BRANCH}] not [${DOCKERHUB_BUILD_BRANCH}]"
    exit 0
fi

REPO_URL="https://github.com/DNSCrypt/dnscrypt-proxy.git"
REPO_NAME="dnscrypt-proxy"
REPO_VERSION_FILE_DIR="."
REPO_VERSION_FILE="ChangeLog"

REPO_ROOT="${HOME}/repo"
REPO_VERSION_FILE_PATH="${REPO_ROOT}/${REPO_NAME}/${REPO_VERSION_FILE_DIR}/${REPO_VERSION_FILE}"

VERSION_ROOT="${HOME}/cache/version"
VERSION_DIR="${VERSION_ROOT}/${REPO_NAME}"
VERSION_FILE_PATH="${VERSION_DIR}/${REPO_VERSION_FILE}"

echo "REPO_ROOT=${REPO_ROOT}"
echo "VERSION_DIR=${VERSION_DIR}"

mkdir -p ${REPO_ROOT}
mkdir -p ${VERSION_DIR}

[[ -f ${VERSION_FILE_PATH}.new ]] || touch ${VERSION_FILE_PATH}.new
rm -f ${VERSION_FILE_PATH}
mv ${VERSION_FILE_PATH}.new ${VERSION_FILE_PATH}

rm -rf ${REPO_ROOT}/${REPO_NAME}
git clone --depth=10 ${REPO_URL} ${REPO_ROOT}/${REPO_NAME}

set +e
md5sum --check ${VERSION_FILE_PATH}
[[ $? == 0 ]] && echo "same version" && exit 0

set -e

md5sum ${REPO_VERSION_FILE_PATH} > ${VERSION_FILE_PATH}

rm -rf ${REPO_ROOT}

curl --request POST \
    --header "Content-Type: application/json" \
    --data '{"source_type": "Branch", "source_name": "${DOCKERHUB_BUILD_BRANCH}"}' \
    ${DOCKERHUB_BUILD_TRIGGER}