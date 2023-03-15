makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=go
VERSION?=1.19.5
PACKAGE=go${VERSION}.linux-${ARCH}.tar.gz
LOAD_URL=https://go.dev/dl/${PACKAGE}
USER?=root

# 引入模板
include ${makefileTemplate}

download:
	cd ${PWD} && mkdir -p ${TEMP_DIR} && wget ${LOAD_URL} -O ${TEMP_DIR}/${PACKAGE}

install:
	cd ${PWD} && bash install.sh -f ${PACKAGE}

uninstall:
	cd ${PWD} && bash uninstall.sh

user:
	chown -R "${USER}":"${USER}" /code
	go env -w GOPATH="/code/go"
	go env -w CGO_ENABLED="1"
	go env -w GOPROXY="http://goproxy.cn,direct"
	go env -w GO111MODULE=on