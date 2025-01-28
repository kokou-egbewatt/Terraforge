#!/bin/bash

set -eu

USAGE="USAGE:
${0}"

if [[ $# -ne 0 ]]; then
    echo "${USAGE}" >&2
    exit 1
fi

# BUILD DIRECTORIES
SCRIPT_DIR="$(dirname "${0}")"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../../"; pwd -P)"
pushd ${ROOT_DIR} > /dev/null

git diff -s --exit-code 'origin/main' -- cmd pkg go.mod && exit 0
echo "Code changed; checking version and CHANGELOG updateds..."
git diff 'origin/main' -- CHANGELOG.rst | grep "+Version"
echo "CHANGELOG was properly updated!"