makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=containerd
VERSION?=1.6.19
PACKAGE=containerd-${VERSION}-linux-${ARCH}.tar.gz
# https://github.com/containerd/containerd/releases
LOAD_URL=https://github.com/containerd/containerd/releases/download/v${VERSION}/${PACKAGE}
USER?=root

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${PACKAGE}

install:
	cd ${PWD} && bash install.sh -f ${PACKAGE}

uninstall:
	cd ${PWD} && bash uninstall.sh
