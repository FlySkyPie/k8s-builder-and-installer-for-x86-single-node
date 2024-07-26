
WORKD_DIR_ROOT := $(shell pwd)
CACHE_ROOT := "${WORKD_DIR_ROOT}/.cache"

all: build-etcd build-k8s
	echo "hello world"


create-cache-folder:
	mkdir -p ${CACHE_ROOT}

build-etcd: create-cache-folder
	if [ -f ${CACHE_ROOT}/etcd/bin/etcd ] && [ -f ${CACHE_ROOT}/etcd/bin/etcdctl ]; then \
		echo "Etcd build is finished, skip."; \
		exit 0; \
	fi; \
	cd ${CACHE_ROOT}; \
	git clone https://github.com/etcd-io/etcd.git; \
	cd etcd; \
	git checkout v3.4.15; \
	go mod vendor; \
	env GOOS=linux GOARCH=386 ./build

build-k8s: create-cache-folder
	cd ${CACHE_ROOT}; \
	git clone --depth 1 --branch  v1.21.0 https://github.com/kubernetes/kubernetes.git; \
	cd kubernetes; \
	build/run.sh make kubectl KUBE_BUILD_PLATFORMS=linux/386; \
	build/run.sh make kube-scheduler KUBE_BUILD_PLATFORMS=linux/386; \
	build/run.sh make kube-apiserver KUBE_BUILD_PLATFORMS=linux/386; \
	build/run.sh make kube-controller-manager KUBE_BUILD_PLATFORMS=linux/386; \
	build/run.sh make kubelet KUBE_BUILD_PLATFORMS=linux/386; \
	build/run.sh make kube-proxy KUBE_BUILD_PLATFORMS=linux/386; 