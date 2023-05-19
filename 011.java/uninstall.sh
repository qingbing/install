#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
# 引入公共脚本
. ./../pub_script.sh
# 参数解析
ParseParams

function uninstall() {
    # 文件删除
    rm -rf ${USR_LOCAL}/jdk
    rm -rf /usr/bin/java
    rm -rf /usr/bin/javac
    # 环境变量
    sed -i '/JAVA_HOME/d' /etc/profile
}

{
    set -x
    uninstall
}
