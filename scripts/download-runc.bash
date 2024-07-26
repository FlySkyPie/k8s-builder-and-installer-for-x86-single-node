#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -f ${CACHE_ROOT}/runc/runc.386 ]; then
    echo "runc file is existing, skip."
    exit 0
fi

mkdir -p ${CACHE_ROOT}/runc

wget -O ${CACHE_ROOT}/runc/runc.386 \
    https://github.com/opencontainers/runc/releases/download/v1.2.0-rc.2/runc.386
