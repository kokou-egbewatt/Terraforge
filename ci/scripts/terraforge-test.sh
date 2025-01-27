#!/bin/bash

set -eu

USAGE="USAGE:
${0} <test-dist-dir>"

if [[ $# -ne 1 ]]; then
    echo "${USAGE}" >&2
    exit 1
fi

# BUILD DIRECTORIES
SCRIPT_DIR="$(dirname "${0}")"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../../"; pwd -P)"
pushd ${ROOT_DIR} > /dev/null
TEST_DIST_DIR=${1}

# Define the exit trap function
cleanup() {
    if ! find . -type d -name ${TEST_DIST_DIR} | grep -q .; then
        mkdir -p ./${TEST_DIST_DIR}
    fi
    find . -type f -name coverage.out -exec mv {} ./${TEST_DIST_DIR}/coverage.out \; -quit
    find . -type f -name coverage-summary.txt -exec mv {} ./${TEST_DIST_DIR}/coverage-summary.txt \; -quit
    find . -type f -name coverage.html -exec mv {} ./${TEST_DIST_DIR}/coverage.html \; -quit
}
trap cleanup EXIT 

coverage(){
    go test -coverprofile=coverage.out ./...

    if [ -f "coverage.out" ]; then
        go tool cover -func=coverage.out > coverage-summary.txt
    else
        echo "No coverage output found."
    fi

    go tool cover -html=coverage.out -o coverage.html
    echo "HTML coverage report generated."
}


coverage 