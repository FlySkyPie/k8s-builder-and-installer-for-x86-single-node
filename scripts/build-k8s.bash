#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

cd ${CACHE_ROOT}/kubernetes
if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kubectl ]; then
    build/run.sh make kubectl KUBE_BUILD_PLATFORMS=linux/386
fi
if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-scheduler ]; then
    build/run.sh make kube-scheduler KUBE_BUILD_PLATFORMS=linux/386
fi
if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-apiserver ]; then
    build/run.sh make kube-apiserver KUBE_BUILD_PLATFORMS=linux/386
fi
if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-controller-manager ]; then
    build/run.sh make kube-controller-manager KUBE_BUILD_PLATFORMS=linux/386
fi
if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kubelet ]; then
    build/run.sh make kubelet KUBE_BUILD_PLATFORMS=linux/386
fi
if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-proxy ]; then
    build/run.sh make kube-proxy KUBE_BUILD_PLATFORMS=linux/386
fi
