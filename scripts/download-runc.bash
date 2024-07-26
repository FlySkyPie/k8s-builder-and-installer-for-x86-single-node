#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

# echo CACHE_ROOT ${CACHE_ROOT}

mkdir -p ${CACHE_ROOT}/runc

wget -O ${CACHE_ROOT}/runc/runc.386 \
    https://github.com/opencontainers/runc/releases/download/v1.2.0-rc.2/runc.386
