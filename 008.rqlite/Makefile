makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=rqlite
VERSION?=v7.13.2
TESTDB?=0
PACKAGE=rqlite-${VERSION}-linux-${ARCH}.tar.gz
# https://github.com/rqlite/rqlite/releases/download/v7.13.2/rqlite-v7.13.2-linux-amd64.tar.gz
LOAD_URL=https://github.com/rqlite/rqlite/releases/download/${VERSION}/${PACKAGE}

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${PACKAGE}

install:
ifeq (${TESTDB}, 1)
	cd ${PWD} && bash install.sh -f ${PACKAGE} -testDB
else
	cd ${PWD} && bash install.sh -f ${PACKAGE}
endif

uninstall:
	cd ${PWD} && bash uninstall.sh
