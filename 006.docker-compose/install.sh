#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=docker-compose
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:docker-compose type:string desc:docker-compose二进制文件 required:true)
PARAM_CONFS=(
    ["f"]=fileConf
)
# 参数解析
ParseParams
# 参数获取
binFile=${PC["f"]}

function install() {
    mkdir -p "${BIN_DIR}"

    cd "${CUR_PATH}"/"${TEMP_DIR}" || true
    cp "${binFile}" "${BIN_DIR}"/docker-compose
    chmod a+x "${BIN_DIR}"/docker-compose
}

{
    set -x
    # 安装
    install
}
