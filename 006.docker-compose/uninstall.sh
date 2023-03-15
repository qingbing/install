#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
PLUGIN_NAME=docker-compose
# 引入公共脚本
. ./../pub_script.sh
# 参数解析
ParseParams

function uninstall() {
    # 删除二进制
    rm -rf ${BIN_DIR}/docker-compose
}

{
    set -x
    uninstall
}