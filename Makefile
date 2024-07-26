
WORKD_DIR_ROOT := $(shell pwd)
CACHE_ROOT := "${WORKD_DIR_ROOT}/.cache"

all: build-binaries
	echo "hello world"

build-binaries: download-stuff build-stuff create-certificates

download-stuff: build-etcd build-k8s build-cni-plugin build-containerd build-pause

build-stuff: download-runc  download-protoc download-crictl

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

download-crictl:
	bash ${WORKD_DIR_ROOT}/scripts/download-crictl.bash ${WORKD_DIR_ROOT} | \
	sed -u 's/^/[Download pause] /'

create-certificates:
	bash ${WORKD_DIR_ROOT}/scripts/create-certificates.bash ${WORKD_DIR_ROOT} 2>&1 | \
	sed -u 's/^/[Create certificates] /'
