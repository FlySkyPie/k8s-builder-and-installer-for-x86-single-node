#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -d ${CACHE_ROOT}/plugins/ ]; then
    echo "plugins folder is finished, skip."
    exit 0
fi

cd ${CACHE_ROOT}
git clone --depth 1 --branch v0.9.1 https://github.com/containernetworking/plugins.git
