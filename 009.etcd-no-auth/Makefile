makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=etcd
VERSION?=v3.5.6
PACKAGE=etcd-${VERSION}-linux-amd64.tar.gz
# https://github.com/etcd-io/etcd/releases/download/v3.5.6/etcd-v3.5.6-linux-amd64.tar.gz
LOAD_URL=https://github.com/etcd-io/etcd/releases/download/${VERSION}/${PACKAGE}

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${PACKAGE}

install:
	cd ${PWD} && bash install.sh -f ${PACKAGE}

uninstall:
	cd ${PWD} && bash uninstall.sh
