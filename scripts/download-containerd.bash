#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -d ${CACHE_ROOT}/containerd/ ]; then
    echo "containerd folder is finished, skip."
    exit 0
fi

cd ${CACHE_ROOT}

git clone git@github.com:containerd/containerd.git
