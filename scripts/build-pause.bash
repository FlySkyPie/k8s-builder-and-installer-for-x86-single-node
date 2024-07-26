#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

cd ${CACHE_ROOT}/kubernetes/build/pause
mkdir -p bin

gcc -Os -Wall -Werror -static -m32 \
    -o bin/pause-linux-i386 linux/pause.c
