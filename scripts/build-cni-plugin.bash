#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

if [ -f ${CACHE_ROOT}/plugins/bin/bandwidth ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/firewall ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/host-local ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/macvlan ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/sbr ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/vlan ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/bridge ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/flannel ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/ipvlan ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/portmap ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/static ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/vrf ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/dhcp ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/host-device ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/loopback ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/ptp ] &&
    [ -f ${CACHE_ROOT}/plugins/bin/tuning ]; then
    echo "CNI plugin files are exist, skip."
    exit 0
fi

cd ${CACHE_ROOT}/plugins
env GOOS=linux GOARCH=386 ./build_linux.sh
