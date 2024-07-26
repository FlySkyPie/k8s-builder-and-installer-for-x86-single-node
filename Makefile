
WORKD_DIR_ROOT := $(shell pwd)
CACHE_ROOT := "${WORKD_DIR_ROOT}/.cache"

all: build-etcd build-k8s download-runc build-cni-plugin download-protoc build-containerd
	echo "hello world"

create-cache-folder:
	mkdir -p ${CACHE_ROOT}

download-etcd: create-cache-folder
	if [ -d ${CACHE_ROOT}/etcd/ ]; then \
		echo "etcd folder is finished, skip."; \
		exit 0; \
	fi; \
	cd ${CACHE_ROOT}; \
	git clone https://github.com/etcd-io/etcd.git;

build-etcd: download-etcd
	if [ -f ${CACHE_ROOT}/etcd/bin/etcd ] && [ -f ${CACHE_ROOT}/etcd/bin/etcdctl ]; then \
		echo "etcd build is finished, skip."; \
		exit 0; \
	fi; \
	cd ${CACHE_ROOT}/etcd; \
	git checkout v3.4.15; \
	go mod vendor; \
	env GOOS=linux GOARCH=386 ./build

download-k8s: create-cache-folder
	if [ -d ${CACHE_ROOT}/kubernetes/ ]; then \
		echo "kubernetes folder is finished, skip."; \
		exit 0; \
	fi; \
	cd ${CACHE_ROOT}; \
	git clone --depth 1 --branch  v1.21.0 https://github.com/kubernetes/kubernetes.git;

build-k8s: download-k8s
	cd ${CACHE_ROOT}/kubernetes; \
	if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kubectl ]; then \
		build/run.sh make kubectl KUBE_BUILD_PLATFORMS=linux/386; \
	fi; \
	if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-scheduler ]; then \
		build/run.sh make kube-scheduler KUBE_BUILD_PLATFORMS=linux/386; \
	fi; \
	if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-apiserver ]; then \
		build/run.sh make kube-apiserver KUBE_BUILD_PLATFORMS=linux/386; \
	fi; \
	if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-controller-manager ]; then \
		build/run.sh make kube-controller-manager KUBE_BUILD_PLATFORMS=linux/386; \
	fi; \
	if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kubelet ]; then \
		build/run.sh make kubelet KUBE_BUILD_PLATFORMS=linux/386; \
	fi; \
		if [ ! -f ${CACHE_ROOT}/kubernetes/_output/dockerized/bin/linux/386/kube-proxy ]; then \
		build/run.sh make kube-proxy KUBE_BUILD_PLATFORMS=linux/386; \
	fi;

download-runc: create-cache-folder
	bash ${WORKD_DIR_ROOT}/scripts/download-runc.bash ${WORKD_DIR_ROOT} | sed -u 's/^/[download-runc] /'

download-cni-plugin:
	bash ${WORKD_DIR_ROOT}/scripts/download-cni-plugin.bash ${WORKD_DIR_ROOT} | sed -u 's/^/[download-cni-plugin] /'

build-cni-plugin: download-cni-plugin
	bash ${WORKD_DIR_ROOT}/scripts/build-cni-plugin.bash ${WORKD_DIR_ROOT} | sed -u 's/^/[build-cni-plugin] /'

download-protoc: 
	bash ${WORKD_DIR_ROOT}/scripts/download-protoc.bash ${WORKD_DIR_ROOT} | sed -u 's/^/[download-protoc] /'

download-containerd: create-cache-folder
	bash ${WORKD_DIR_ROOT}/scripts/download-containerd.bash ${WORKD_DIR_ROOT} | sed -u 's/^/[download-containerd] /'

build-containerd: download-containerd
	bash ${WORKD_DIR_ROOT}/scripts/build-containerd.bash ${WORKD_DIR_ROOT} | sed -u 's/^/[build-containerd] /'
