#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=go
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:go1.19.5.linux-amd64.tar.gz type:string desc:go安装包 required:true)
PARAM_CONFS=(
    ["f"]=fileConf
)
# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}

function remove() {
    rm -rf "${USR_LOCAL}"/go
    sed -i '/\/code\/go\/bin:\/usr\/local\/go\/bin/d' /etc/profile
}

function install() {
    cd "${CUR_PATH}/${TEMP_DIR}" || true
    tar -xzvf "${tarFile}"
    mv go "${USR_LOCAL}"
}

function config() {
    mkdir -p /code/go/src
    cat >>/etc/profile <<EOF
export PATH=\$PATH:/code/go/bin:/usr/local/go/bin
EOF
    source /etc/profile
    go env -w GOPATH="/code/go"
    go env -w CGO_ENABLED="1"
    go env -w GOPROXY="http://goproxy.cn,direct"
    go env -w GO111MODULE=on
}

{
    set -x
    remove
    install
    config
}
