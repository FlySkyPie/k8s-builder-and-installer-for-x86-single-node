#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

# ETCD_NAME="arachne-node-alpha"
INTERNAL_IP="192.168.0.144"

mkdir -p ${CACHE_ROOT}/services

if [ -f ${CACHE_ROOT}/services/etcd.service ]; then
    echo "File 'etcd.service' exist, skip."
else
    cat <<EOF | tee ${CACHE_ROOT}/services/etcd.service
[Unit]
Description=etcd
Documentation=https://etcd.io/

[Service]
Type=notify
Environment="ETCD_UNSUPPORTED_ARCH=386" # for the i386 architecture only
ExecStart=/usr/local/bin/etcd \\
  --name controller \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster controller=https://${INTERNAL_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
fi
