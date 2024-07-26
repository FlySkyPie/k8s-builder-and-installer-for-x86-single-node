#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -f ${CACHE_ROOT}/etcd/bin/etcd ] && [ -f ${CACHE_ROOT}/etcd/bin/etcdctl ]; then
    echo "etcd build is finished, skip."
    exit 0
fi
cd ${CACHE_ROOT}/etcd
go mod vendor
env GOOS=linux GOARCH=386 ./build
