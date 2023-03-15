makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=docker-compose
VERSION?=2.16.0
# https://get.daocloud.io/docker/compose/releases/download/2.16.0/docker-compose-linux-x86_64
# LOAD_URL=https://get.daocloud.io/docker/compose/releases/download/"${VERSION}"/docker-compose-`uname -s`-`uname -m`

# https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64
LOAD_URL=https://github.com/docker/compose/releases/download/v"${VERSION}"/docker-compose-`uname -s`-`uname -m`

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${NAME}

install:
	cd ${PWD} && bash install.sh -f ${NAME}

uninstall:
	cd ${PWD} && bash uninstall.sh
