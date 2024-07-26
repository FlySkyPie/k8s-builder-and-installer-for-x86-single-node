#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

mkdir -p ${CACHE_ROOT}/protoc
cd ${CACHE_ROOT}/protoc


if [ -f include/google/protobuf/source_context.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/timestamp.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/duration.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/type.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/struct.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/descriptor.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/field_mask.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/api.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/wrappers.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/any.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/empty.proto ]; then
    exit 0
fi
if [ -f include/google/protobuf/compiler ]; then
    exit 0
fi
if [ -f include/google/protobuf/compiler/plugin.proto ]; then
    exit 0
fi
if [ -f bin/protoc ]; then
    exit 0
fi
if [ -f readme.txt ]; then
    exit 0
fi

wget -qO- https://github.com/google/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_32.zip |
    busybox unzip -
