#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -d ${CACHE_ROOT}/kubernetes/ ]; then
    echo "kubernetes folder is finished, skip."
    exit 0
fi
cd ${CACHE_ROOT}
git clone --depth 1 --branch v1.21.0 https://github.com/kubernetes/kubernetes.git
