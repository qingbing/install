#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
PLUGIN_NAME=registry
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
installDirConf=(default:/opt/registry type:string desc:数据目录)
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
    rm -f "${BIN_DIR}"/registry
    # 删除启动文件
    rm -f "${SYS_CONF_DIR}"/"${PLUGIN_NAME}".service
    # 清除域名映射
    sed -i '/registry.qiyezhu.net/d' /etc/hosts
}

{
    set -x
    # 停止服务
    ServiceStop
    # 卸载
    uninstall
}