#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -f ${CACHE_ROOT}/containerd/bin/containerd ] &&
    [ -f ${CACHE_ROOT}/containerd/bin/containerd-shim-runc-v2 ] &&
    [ -f ${CACHE_ROOT}/containerd/bin/containerd-stress ]; then
    echo "containerd files is finished, skip."
    exit 0
fi

cd ${CACHE_ROOT}/containerd
env GOOS=linux GOARCH=386 CGO_ENABLED=1 make
