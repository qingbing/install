makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=registry
VERSION?=2.8.0

# https://github.com/distribution/distribution/releases/download/v2.8.0/registry_2.8.0_linux_amd64.tar.gz
LOAD_URL=https://github.com/distribution/distribution/releases/download/v"${VERSION}"/registry_"${VERSION}"_linux_"${ARCH}".tar.gz

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${NAME}.tar.gz

install:
	cd ${PWD} && bash install.sh -f ${NAME}.tar.gz

uninstall:
	cd ${PWD} && bash uninstall.sh
