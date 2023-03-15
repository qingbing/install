#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
PLUGIN_NAME=docker-buildx
# 引入公共脚本
. ./../pub_script.sh
# 参数解析
ParseParams
# 当前组件变量
CLI_PLUGIN_DIR=/usr/libexec/docker/cli-plugins

function uninstall() {
    # 删除二进制
    rm -rf "${CLI_PLUGIN_DIR}"/docker-buildx
}

{
    set -x
    uninstall
}