#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
PLUGIN_NAME=docker
# 引入公共脚本
. ./../pub_script.sh
# 参数解析
ParseParams

function uninstall() {
    systemctl disable ${PLUGIN_NAME}.service
    systemctl disable ${PLUGIN_NAME}.socket
    systemctl daemon-reload
    # 删除二进制
    rm -rf ${BIN_DIR}/docker
    rm -rf ${BIN_DIR}/docker-init
    rm -rf ${BIN_DIR}/docker-proxy
    rm -rf ${BIN_DIR}/dockerd
    rm -rf ${BIN_DIR}/runc

    # 删除配置文件
    rm -f /lib/systemd/system/${PLUGIN_NAME}.service
    rm -f /lib/systemd/system/${PLUGIN_NAME}.socket
    rm -f /etc/docker/daemon.json
}

{
    set -x
    ServiceStop
    uninstall
}
