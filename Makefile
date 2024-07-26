
WORKD_DIR_ROOT := $(shell pwd)
CACHE_ROOT := "${WORKD_DIR_ROOT}/.cache"

all: build-etcd build-k8s download-runc build-cni-plugin download-protoc build-containerd build-pause
	echo "hello world"

create-cache-folder:
	mkdir -p ${CACHE_ROOT}

download-etcd: create-cache-folder
	bash ${WORKD_DIR_ROOT}/scripts/download-etcd.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Download etcd] /'

build-etcd: download-etcd
	bash ${WORKD_DIR_ROOT}/scripts/build-etcd.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Build etcd] /'

download-k8s: create-cache-folder
	bash ${WORKD_DIR_ROOT}/scripts/download-k8s.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Download K8s] /'

build-k8s: download-k8s
	bash ${WORKD_DIR_ROOT}/scripts/build-k8s.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Build K8s] /'

download-runc: create-cache-folder
	bash ${WORKD_DIR_ROOT}/scripts/download-runc.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Download runc] /'

download-cni-plugin:
	bash ${WORKD_DIR_ROOT}/scripts/download-cni-plugin.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Download cni-plugin] /'

build-cni-plugin: download-cni-plugin
	bash ${WORKD_DIR_ROOT}/scripts/build-cni-plugin.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Build cni-plugin] /'

download-protoc: 
	bash ${WORKD_DIR_ROOT}/scripts/download-protoc.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Download protoc] /'

download-containerd: create-cache-folder
	bash ${WORKD_DIR_ROOT}/scripts/download-containerd.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Download containerd] /'

build-containerd: download-containerd
	bash ${WORKD_DIR_ROOT}/scripts/build-containerd.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Build containerd] /'

build-pause:
	bash ${WORKD_DIR_ROOT}/scripts/build-pause.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Build pause] /'
