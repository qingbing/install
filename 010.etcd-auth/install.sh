#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=etcd
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:etcd-v3.5.6-linux-amd64.tar.gz type:string desc:etcd二进制包 required:true)
certIpsConf=(default:${LOCAL_IP} type:string desc:证书允许的IP,多个IP用','分隔)
clusterConf=(default:etcd=http://${LOCAL_IP}:2380 type:string desc:etcd集群初始化连接,只能使用2380端口 eg:node1=http://ip1:2380,node2=http://ip2:2380)
clusterTokenConf=(default:etcd-cluster type:string desc:集群token)
clusterStateConf=(default:new type:string desc:当前集群状态)
nameConf=(default:etcd type:string desc:etcd节点名,必须和集群初始化连接中的节点名对应一致 eg:etcd-node1)
ipConf=(default:"${LOCAL_IP}" type:string desc:本节点IP eg:"${LOCAL_IP}")
installDirConf=(default:/opt/etcd type:string desc:安装目录)
PARAM_CONFS=(
    ["f"]=fileConf
    ["cluster"]=clusterConf
    ["certIps"]=certIpsConf
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
certIps=${PC["certIps"]}
cluster=${PC["cluster"]}
clusterToken=${PC["clusterToken"]}
clusterState=${PC["clusterState"]}
name=${PC["name"]}
ip=${PC["ip"]}
installDir=${PC["installDir"]}

OLD_IFS="${IFS}"
IFS=","
arr=($certIps)
IFS="${OLD_IFS}"
etcdCertIps=""
for ip in "${arr[@]}"; do
    etcdCertIps="${etcdCertIps}        \"${ip}\",\n"
done

function install() {
    mkdir -p "${BIN_DIR}"         # 二进制存放目录
    mkdir -p "${installDir}"/conf # 安装目录(配置目录)
    mkdir -p "${installDir}"/ssl  # 安装目录(证书目录)
    mkdir -p "${installDir}"/data # 安装目录(数据目录)

    cd "${CUR_PATH}/${TEMP_DIR}" || true
    # 解压证书工具,生成证书,并复制证书文件
    tar -xzvf cfssl.tar.gz
    cd "${CUR_PATH}" || true
    cp cert/ca-csr.json "${TEMP_DIR}"/cfssl
    cp cert/ca-config.json "${TEMP_DIR}"/cfssl
    sed \
        -e "s#{{ETCD_IPS}}#${etcdCertIps}#g" \
        cert/server-csr.json.template >"${TEMP_DIR}"/cfssl/server-csr.json
    cd "${CUR_PATH}/${TEMP_DIR}/cfssl" || true
    rm -rf ./*.pem
    # 根据配置文件生成自签CA证书
    ./cfssl gencert -initca ca-csr.json | ./cfssljson -bare ca -
    # 生成证书(hosts 集群内部通信ip,一个都不能少,为了方便后期扩容可以多写几个预留的ip)
    # 生成证书(如果果已经执行过命令来生成文件，需先删除文件后再执行以上命令)
    ./cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | ./cfssljson -bare server
    cp *.pem "${installDir}"/ssl

    cd "${CUR_PATH}/${TEMP_DIR}" || true
    tDir=$(tar -xzvf "${tarFile}" | head -n 1 | awk -F/ '{print $1}') # 获取解压目录名
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
        -e "s#{{INSTALL_DIR}}#${installDir}#g" \
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
