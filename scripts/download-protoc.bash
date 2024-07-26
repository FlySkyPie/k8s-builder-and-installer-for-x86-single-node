#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

mkdir -p ${CACHE_ROOT}/protoc
cd ${CACHE_ROOT}/protoc
wget -qO- https://github.com/google/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_32.zip |
    busybox unzip -
