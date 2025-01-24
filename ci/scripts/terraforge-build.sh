#!/bin/bash

set -eu

USAGE="USAGE:
${0} <build-dir>"

if [[ $# -ne 1 ]]; then
    echo "${USAGE}" >&2
    exit 1
fi

# BUILD DIRECTORIES
SCRIPT_DIR="$(dirname "${0}")"
pushd ${SCRIPT_DIR} > /dev/null
BUILD_DIR=${1}
TERRAFORGE_MAIN_DIR="cmd"
RUN_DIR="$(cd "../../${TERRAFORGE_MAIN_DIR}"; pwd -P)"

# BUILD PLATFORM ARCHITECTURE
LINUX_ARCH=amd64
LINUX_OS=linux

build(){
    # 
    pushd ${RUN_DIR} > /dev/null

    # BUILD TERRAFORGE
    GOOS=$LINUX_OS GOARCH=$LINUX_ARCH go build -ldflags="-s -w" -o ../${1}/terraforge_${LINUX_OS}_${LINUX_ARCH} terraforge.go
}



build $BUILD_DIR

