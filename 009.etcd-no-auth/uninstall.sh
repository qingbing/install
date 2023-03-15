#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
PLUGIN_NAME=etcd
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
installDirConf=(default:/opt/etcd type:string desc:安装目录)
PARAM_CONFS=(
    ["installDir"]=installDirConf
)
# 参数解析
ParseParams
# 参数获取
installDir=${PC["installDir"]}

function uninstall() {
    # 停止服务
    systemctl disable ${PLUGIN_NAME}
    systemctl daemon-reload
    # 删除安装目录
    rm -rf "${installDir}"
    # 删除二进制
    rm -rf "${BIN_DIR}"/etcd
    rm -rf "${BIN_DIR}"/etcdctl
    rm -rf "${BIN_DIR}"/etcdutl
    # 删除启动文件
    rm -f "${SYS_CONF_DIR}"/"${PLUGIN_NAME}".service
}

{
    set -x
    uninstall
}