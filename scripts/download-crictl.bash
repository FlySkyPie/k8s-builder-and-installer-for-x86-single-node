#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -f ${CACHE_ROOT}/crictl/crictl ]; then
    echo "crictl file is existing, skip."
    exit 0
fi

mkdir -p ${CACHE_ROOT}/crictl
cd ${CACHE_ROOT}/crictl
wget -qO- -q --show-progress --https-only --timestamping \
    https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.21.0/crictl-v1.21.0-linux-386.tar.gz |
    tar xvz
