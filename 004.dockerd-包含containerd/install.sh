#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=docker
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:docker-20.10.20.tgz type:string desc:docker二进制包 required:true)
PARAM_CONFS=(
    ["f"]=fileConf
)
# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}

function install() {
    mkdir -p ${BIN_DIR}

    cd "${CUR_PATH}/${TEMP_DIR}"
    tar -xzvf "${tarFile}"
    mv docker/* ${BIN_DIR}
}

function conf() {
    cd "${CUR_PATH}"
    # 配置启动脚本
    mkdir -p ${SYS_CONF_DIR} && cp templates/docker.service ${SYS_CONF_DIR}/${PLUGIN_NAME}.service
    mkdir -p /etc/docker && cp templates/daemon.json /etc/docker
    # 进程管理
    systemctl daemon-reload
    systemctl enable ${PLUGIN_NAME}
    # 添加用户组
    groupadd docker
}

{
    set -x
    # 停止原有服务
    ServiceStop
    # 安装
    install
    # 配置
    conf
    # 启动
    ServiceStart
    # 检查是否启动成功
    checkRunning "${BIN_DIR}/${PLUGIN_NAME}"
    ServiceStatus # 检查状态
}