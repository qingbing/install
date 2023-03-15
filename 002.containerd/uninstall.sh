#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
PLUGIN_NAME=containerd
# 引入公共脚本
. ./../pub_script.sh
# 参数解析
ParseParams

function uninstall() {
    systemctl disable ${PLUGIN_NAME}
    systemctl daemon-reload
    # 删除二进制
    rm -f ${BIN_DIR}/containerd*
    rm -f ${BIN_DIR}/ctr
    # 删除 systemd 文件
    rm -f /lib/systemd/system/${PLUGIN_NAME}.service
}

{
    set -x
    ServiceStop
    uninstall
}
