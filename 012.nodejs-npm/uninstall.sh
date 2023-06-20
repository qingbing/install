#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
PLUGIN_NAME=node
# 引入公共脚本
. ./../pub_script.sh
# 参数解析
ParseParams

function uninstall() {
    # 移除 ts
    npm uninstall -g typescript
    rm -rf ${BIN_DIR}/tsc

    # 删除二进制(软连接)
    rm -rf ${BIN_DIR}/npm
    rm -rf ${BIN_DIR}/node
    
    # 删除源文件
    rm -rf "${USR_LOCAL}/node"
}

{
    set -x
    uninstall
}
