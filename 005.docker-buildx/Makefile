makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=docker-buildx
VERSION?=0.10.3
PACKAGE=buildx-v${VERSION}.linux-${ARCH}
# https://github.com/docker/buildx/releases
LOAD_URL=https://github.com/docker/buildx/releases/download/v${VERSION}/${PACKAGE}

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${NAME}

install:
	cd ${PWD} && bash install.sh -f ${NAME}

uninstall:
	cd ${PWD} && bash uninstall.sh
