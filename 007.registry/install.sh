#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=registry
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:registry.tar.gz type:string desc:registry二进制包 required:true)
hostConf=(default:127.0.0.1 type:string desc:服务主机IP)
portConf=(default:5000 type:string desc:服务监听端口 eg:5000)
installDirConf=(default:/opt/registry type:string desc:安装目录)
PARAM_CONFS=(
    ["f"]=fileConf
    ["host"]=hostConf
    ["port"]=portConf
    ["installDir"]=installDirConf
)

# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}
host=${PC["host"]}
port=${PC["port"]}
installDir=${PC["installDir"]}

function install() {
    mkdir -p "${BIN_DIR}"         # 二进制存放目录
    mkdir -p "${installDir}"/conf # 安装目录(配置文件)
    mkdir -p "${installDir}"/data # 安装目录(数据文件)

    cd "${CUR_PATH}/${TEMP_DIR}" || true
    tar -xzvf "${tarFile}"
    mv registry "${BIN_DIR}"
}

function conf() {
    cd "${CUR_PATH}" || true
    cp templates/custom.key "${installDir}"/conf/cert.key
    cp templates/custom.crt "${installDir}"/conf/cert.crt

    sed \
        -e "s#{{INSTALL_DIR}}#${installDir}#g" \
        -e "s#{{LISTEN_PORT}}#${port}#g" \
        templates/conf.yaml >"${installDir}"/conf/default.yaml

    sed \
        -e "s#{{CRT_FILE}}#${installDir}/conf/cert.crt#g" \
        -e "s#{{KEY_FILE}}#${installDir}/conf/cert.key#g" \
        templates/default.env >"${installDir}"/conf/default.env

    sed \
        -e "s#{{CONF_DIR}}#${installDir}/conf#g" \
        -e "s#{{BIN_DIR}}#${BIN_DIR}#g" \
        templates/registry.service >"${SYS_CONF_DIR}"/"${PLUGIN_NAME}".service

    # registry 默认被禁用
    systemctl unmask ${PLUGIN_NAME}
    systemctl daemon-reload
    systemctl enable ${PLUGIN_NAME}

    # 域名配置
    echo "${LOCAL_IP}    registry.qiyezhu.net" >> /etc/hosts
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
