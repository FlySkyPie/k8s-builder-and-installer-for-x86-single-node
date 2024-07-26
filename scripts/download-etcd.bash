#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -d ${CACHE_ROOT}/etcd/ ]; then
    echo "etcd folder is finished, skip."
    exit 0
fi

cd ${CACHE_ROOT}
git clone --depth 1 --branch v3.4.15 https://github.com/etcd-io/etcd.git
