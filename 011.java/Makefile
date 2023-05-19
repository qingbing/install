makefileTemplate=./../Makefile.template

# $(shell wget https://www.xxx.com/Makefile -O ${makefileTemplate})
# 变量定义
NAME=java
PACKAGE=jdk.tar.gz

# 引入模板
include ${makefileTemplate}

download:
	@echo jdk官网: https://www.oracle.com/， 下载需要登录token，需要自行注册下载并存放在buildTemp目录下，文件保存为: jdk.tar.gz

install:
	cd ${PWD} && bash install.sh -f ${PACKAGE}

uninstall:
	cd ${PWD} && bash uninstall.sh