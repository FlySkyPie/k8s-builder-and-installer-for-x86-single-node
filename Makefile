
WORKD_DIR_ROOT := $(shell pwd)
CACHE_ROOT := "${WORKD_DIR_ROOT}/.cache"

all: build-etcd
	echo "hello world"


create-cache-folder:
	mkdir -p ${CACHE_ROOT}

build-etcd: create-cache-folder
	cd ${CACHE_ROOT}; \
	git clone https://github.com/etcd-io/etcd.git; \
	cd etcd; \
	git checkout v3.4.15; \
	go mod vendor; \
	env GOOS=linux GOARCH=386 ./build