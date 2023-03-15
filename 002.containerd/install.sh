#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=containerd
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:containerd-1.6.19-linux-amd64.tar.gz type:string desc:containerd二进制包 required:true)
PARAM_CONFS=(
    ["f"]=fileConf
)
# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}


function clearEnv() {
    set +e
    if [ $SUPPORT_YUM -gt 0 ]; then
        yum remove -y containerd.io || true
    else
        apt-get --purge remove -y containerd.io || true
    fi
}

function install() {
    mkdir -p ${BIN_DIR}

    cd "${CUR_PATH}/${TEMP_DIR}"
    tar -xzvf "${tarFile}"
    mv bin/* ${BIN_DIR}
}

function config() {
    set -e
    cd "${CUR_PATH}"
    # 配置启动脚本
    mkdir -p ${SYS_CONF_DIR} && cp templates/containerd.service ${SYS_CONF_DIR}/${PLUGIN_NAME}.service
    systemctl daemon-reload
    systemctl enable ${PLUGIN_NAME}
}

{
    set -x
    ServiceStop   # 停止原有服务
    clearEnv     # 清理环境
    install      # 安装
    config       # 配置
    ServiceStart # 启动
    checkRunning "${BIN_DIR}/${PLUGIN_NAME}" # 检查是否启动成功
    ServiceStatus # 检查状态
}
