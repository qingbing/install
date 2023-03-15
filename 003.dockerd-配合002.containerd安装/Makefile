makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=docker
VERSION?=20.10.20
PACKAGE=docker-${VERSION}.tgz
# https://download.docker.com/linux/static/stable
ifeq (${ARCH}, arm64)
LOAD_URL=https://download.docker.com/linux/static/stable/aarch64/"${PACKAGE}"
else
LOAD_URL=https://download.docker.com/linux/static/stable/x86_64/"${PACKAGE}"
endif

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${PACKAGE}

install:
	cd ${PWD} && bash install.sh -f ${PACKAGE}

uninstall:
	cd ${PWD} && bash uninstall.sh

user:
	usermod -aG docker ${USER} # 将用户加入 docker 组
	newgrp docker # 刷新 docker 组