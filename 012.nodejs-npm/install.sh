#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=node
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:node-v20.0.0-linux-arm64.tar.gz type:string desc:node二进制包 required:true)
PARAM_CONFS=(
    ["f"]=fileConf
)
# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}

function install() {
    mkdir -p "${BIN_DIR}" # 二进制存放目录
    rm -rf "${USR_LOCAL}/node" # 清理原有的 node 源文件存放目录

    cd "${CUR_PATH}/${TEMP_DIR}" || true
    tDir=$(tar -xzvf "${tarFile}" | head -n 1 | awk -F/ '{print $1}')
    tar --no-same-owner -xzf "${tarFile}" && mv "${tDir}" "${USR_LOCAL}/node"
}

function conf()
{
    ln -s "${USR_LOCAL}/node/bin/npm" "${BIN_DIR}"
    ln -s "${USR_LOCAL}/node/bin/node" "${BIN_DIR}"
}

function installTs()
{
    npm install -g typescript
    ln -s "${USR_LOCAL}/node/bin/tsc" "${BIN_DIR}"
}

{
    set -x
    # 安装
    install
    # 配置
    conf
    # 安装 ts
    installTs
}