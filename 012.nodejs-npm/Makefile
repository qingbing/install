makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=node
VERSION?=v20.0.0
PACKAGE=node-${VERSION}-linux-arm64.tar.gz
# https://nodejs.org/dist/${VERSION}/node-${VERSION}-linux-arm64.tar.gz
# https://nodejs.org/dist/${VERSION}/node-${VERSION}-linux-x86.tar.gz
LOAD_URL=https://nodejs.org/dist/${VERSION}/node-${VERSION}-linux

# 引入模板
include ${makefileTemplate}

download:
ifeq (${ARCH}, arm64)
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL}-arm64.tar.gz -O ${TEMP_DIR}/${PACKAGE}
else
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL}-x86.tar.gz -O ${TEMP_DIR}/${PACKAGE}
endif

install:
	cd ${PWD} && bash install.sh -f ${PACKAGE}

uninstall:
	cd ${PWD} && bash uninstall.sh
