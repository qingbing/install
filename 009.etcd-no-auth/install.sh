#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=etcd
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:etcd-v3.5.6-linux-amd64.tar.gz type:string desc:etcd二进制包 required:true)
clusterConf=(default:etcd=http://${LOCAL_IP}:2380 type:string desc:etcd集群初始化连接,只能使用2380端口 eg:node1=http://ip1:2380,node2=http://ip2:2380)
clusterTokenConf=(default:etcd-cluster type:string desc:集群token)
clusterStateConf=(default:new type:string desc:当前集群状态)
nameConf=(default:etcd type:string desc:etcd节点名,必须和集群初始化连接中的节点名对应一致 eg:etcd-node1)
ipConf=(default:"${LOCAL_IP}" type:string desc:本节点IP eg:"${LOCAL_IP}")
installDirConf=(default:/opt/etcd type:string desc:安装目录)
PARAM_CONFS=(
    ["f"]=fileConf
    ["cluster"]=clusterConf
    ["clusterToken"]=clusterTokenConf
    ["clusterState"]=clusterStateConf
    ["name"]=nameConf
    ["ip"]=ipConf
    ["installDir"]=installDirConf
)
# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}
cluster=${PC["cluster"]}
clusterToken=${PC["clusterToken"]}
clusterState=${PC["clusterState"]}
name=${PC["name"]}
ip=${PC["ip"]}
installDir=${PC["installDir"]}

function install() {
    mkdir -p "${BIN_DIR}" # 二进制存放目录
    mkdir -p "${installDir}"/conf # 安装目录(配置文件)
    mkdir -p "${installDir}"/data # 安装目录(数据文件)

    cd "${CUR_PATH}/${TEMP_DIR}" || true
    tDir=$(tar -xzvf "${tarFile}" | head -n 1 | awk -F/ '{print $1}')
    tar -xzvf "${tarFile}"
    mv "${tDir}/etcd" "${BIN_DIR}"
    mv "${tDir}/etcdctl" "${BIN_DIR}"
    mv "${tDir}/etcdutl" "${BIN_DIR}"
}

function conf() {
    cd "${CUR_PATH}" || true

    sed \
        -e "s#{{NAME}}#${name}#g" \
        -e "s#{{DATA_DIR}}#${installDir}/data#g" \
        -e "s#{{LISTEN_PEER_URLS}}#http://${ip}:2380#g" \
        -e "s#{{LISTEN_CLIENT_URLS}}#http://${ip}:2379#g" \
        -e "s#{{INITIAL_ADVERTISE_PEER_URLS}}#http://${ip}:2380#g" \
        -e "s#{{ADVERTISE_CLIENT_URLS}}#http://${ip}:2379#g" \
        -e "s#{{INITIAL_CLUSTER}}#${cluster}#g" \
        -e "s#{{INITIAL_CLUSTER_TOKEN}}#${clusterToken}#g" \
        -e "s#{{INITIAL_CLUSTER_STATE}}#${clusterState}#g" \
        templates/default.conf >"${installDir}"/conf/default.conf

    sed \
        -e "s#{{BIN_DIR}}#${BIN_DIR}#g" \
        -e "s#{{CONF_DIR}}#${installDir}/conf#g" \
        templates/${PLUGIN_NAME}.service >"${SYS_CONF_DIR}"/"${PLUGIN_NAME}".service

    systemctl unmask ${PLUGIN_NAME}
    systemctl daemon-reload
    systemctl enable ${PLUGIN_NAME}
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
    echo "etcd当前节点安装成功,若为多集群,请在其它节点继续安装!"
    # 检查状态
    ServiceStatus
}
