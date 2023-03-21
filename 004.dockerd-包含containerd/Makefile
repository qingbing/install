makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=docker
VERSION?=20.10.20
PACKAGE=docker-${VERSION}.tgz
# https://download.docker.com/linux/static/stable
S_ARCH=$(shell if [ $$(arch) == "aarch64" ]; then printf "aarch64"; else printf "x86_64"; fi;)
LOAD_URL=https://download.docker.com/linux/static/stable/${S_ARCH}/${PACKAGE}

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