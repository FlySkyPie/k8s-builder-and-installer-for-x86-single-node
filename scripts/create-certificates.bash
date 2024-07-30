#!/bin/env bash

WORKD_DIR_ROOT=$1
CACHE_ROOT="${WORKD_DIR_ROOT}/.cache"

NODE_NAME="arachne-node-alpha"
NODE_IP="192.168.0.144"
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

mkdir -p ${CACHE_ROOT}/certificates
cd ${CACHE_ROOT}/certificates

if ! command -v cfssl &>/dev/null; then
  echo "cfssl could not be found"
  exit 1
fi
if ! command -v cfssljson &>/dev/null; then
  echo "cfssljson could not be found"
  exit 1
fi

echo "[Encryption Config]"

if [ -f encryption-config.yaml ]; then
  echo "File 'encryption-config.yaml' exist, skip."
else
  cat >encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
fi

echo "[Certificate Authority]"

if [ -f ca-config.json ]; then
  echo "File 'ca-config.json' exist, skip."
else
  cat >ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF
fi

if [ -f ca-csr.json ]; then
  echo "File 'ca-csr.json' exist, skip."
else
  cat >ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f ca.pem ]; then
  echo "File 'ca.pem' exist, skip."
else
  cfssl gencert -initca ca-csr.json | cfssljson -bare ca
fi

# ===============

echo "[The Admin Client Certificate]"

if [ -f admin-csr.json ]; then
  echo "File 'admin-csr.json' exist, skip."
else
  cat >admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f admin-key.pem ]; then
  echo "File 'admin-key.pem' exist, skip."
else
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    admin-csr.json | cfssljson -bare admin
fi

# ===============

echo "[The Kubelet Client Certificates]"

if [ -f ${NODE_NAME}-csr.json ]; then
  echo "File '${NODE_NAME}-csr.json' exist, skip."
else
  cat >${NODE_NAME}-csr.json <<EOF
{
  "CN": "system:node:${NODE_NAME}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f ${NODE_NAME}.pem ]; then
  echo "File '${NODE_NAME}.pem' exist, skip."
else
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -hostname=${NODE_NAME},${NODE_IP},127.0.0.1 \
    -profile=kubernetes \
    ${NODE_NAME}-csr.json | cfssljson -bare ${NODE_NAME}
fi

# ===============

echo "[The Controller Manager Client Certificate]"

if [ -f kube-controller-manager-csr.json ]; then
  echo "File 'kube-controller-manager-csr.json' exist, skip."
else
  cat >kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f kube-controller-manager.pem ]; then
  echo "File 'kube-controller-manager.pem' exist, skip."
else
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
fi

# ===============

echo "[The Kube Proxy Client Certificate]"

if [ -f kube-proxy-csr.json ]; then
  echo "File 'kube-proxy-csr.json' exist, skip."
else
  cat >kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f kube-proxy.pem ]; then
  echo "File 'kube-proxy.pem' exist, skip."
else
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    kube-proxy-csr.json | cfssljson -bare kube-proxy
fi

# ===============

echo "[The Scheduler Client Certificate]"

if [ -f kube-scheduler-csr.json ]; then
  echo "File 'kube-scheduler-csr.json' exist, skip."
else
  cat >kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f kube-scheduler.pem ]; then
  echo "File 'kube-scheduler.pem' exist, skip."
else
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    kube-scheduler-csr.json | cfssljson -bare kube-scheduler
fi

# ===============

echo "[The Kubernetes API Server Certificate]"

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

if [ -f kubernetes-csr.json ]; then
  echo "File 'kubernetes-csr.json' exist, skip."
else
  cat >kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f kubernetes.pem ]; then
  echo "File 'kubernetes.pem' exist, skip."
else
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -hostname=${NODE_IP},127.0.0.1,${KUBERNETES_HOSTNAMES} \
    -profile=kubernetes \
    kubernetes-csr.json | cfssljson -bare kubernetes
fi

# ===============

echo "[The Service Account Key Pair]"

if [ -f service-account-csr.json ]; then
  echo "File 'service-account-csr.json' exist, skip."
else
  cat >service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
fi

if [ -f service-account.pem ]; then
  echo "File 'service-account.pem' exist, skip."
else
  cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    service-account-csr.json | cfssljson -bare service-account
fi
