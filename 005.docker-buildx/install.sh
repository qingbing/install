#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=docker-buildx
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:docker-buildx type:string desc:docker-buildx二进制文件 required:true)
PARAM_CONFS=(
    ["f"]=fileConf
)
# 参数解析
ParseParams
# 参数获取
binFile=${PC["f"]}
# 当前组件变量
CLI_PLUGIN_DIR=/usr/libexec/docker/cli-plugins

function install() {
    mkdir -p "${CLI_PLUGIN_DIR}"

    cd "${CUR_PATH}"/"${TEMP_DIR}" || true
    cp "${binFile}" "${CLI_PLUGIN_DIR}"/docker-buildx
    chmod a+x "${CLI_PLUGIN_DIR}"/docker-buildx
}

{
    set -x
    # 安装
    install
}
