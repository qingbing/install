#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=rqlite
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:rqlite-v7.13.2-linux-amd64.tar.gz type:string desc:rqlite二进制包 required:true)
ipConf=(default:"${LOCAL_IP}" type:string desc:Rqlite服务IP eg:"${LOCAL_IP}")
httpPortConf=(default:4001 type:int desc:http服务端口 eg:4001)
raftPortConf=(default:4002 type:int desc:http服务端口 eg:4002)
installDirConf=(default:/opt/rqlite type:string desc:安装目录)
testDbConf=(default:false type:bool desc:安装测试数据表)
PARAM_CONFS=(
    ["f"]=fileConf
    ["ip"]=ipConf
    ["httpPort"]=httpPortConf
    ["raftPort"]=raftPortConf
    ["installDir"]=installDirConf
    ["testDB"]=testDbConf
)
# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}
rqliteIp=${PC["ip"]}
httpPort=${rqliteIp}:${PC["httpPort"]}
raftPort=${rqliteIp}:${PC["raftPort"]}
installDir=${PC["installDir"]}
installTestDB=${PC["testDB"]}

function install() {
    mkdir -p "${BIN_DIR}"         # 二进制存放目录
    mkdir -p "${installDir}"/data # 安装目录(数据文件)

    cd "${CUR_PATH}/${TEMP_DIR}" || true
    tDir=$(tar -xzvf "${tarFile}" | head -n 1 | awk -F/ '{print $1}')
    tar -xzvf "${tarFile}"
    mv "${tDir}/rqbench" "${BIN_DIR}"
    mv "${tDir}/rqlite" "${BIN_DIR}"
    mv "${tDir}/rqlited" "${BIN_DIR}"
}

function conf() {
    cd "${CUR_PATH}" || true

    sed \
        -e "s#{{BIN_DIR}}#${BIN_DIR}#g" \
        -e "s#{{HTTP_ADDR}}#${httpPort}#g" \
        -e "s#{{RAFT_ADDR}}#${raftPort}#g" \
        -e "s#{{DATA_DIR}}#${installDir}/data#g" \
        templates/rqlite.service >"${SYS_CONF_DIR}"/"${PLUGIN_NAME}".service

    # rqlite 默认被禁用
    systemctl unmask ${PLUGIN_NAME}
    systemctl daemon-reload
    systemctl enable ${PLUGIN_NAME}
}

function initDatabase() {
    cd "${CUR_PATH}" || true

    # 加入失败重试
    for i in $(seq 1 10); do
        set +e
        r=$(echo -e ".restore ./templates/test.sql\nexit\n" | rqlite -H "${rqliteIp}")
        echo $r | grep "successful"
        if [ $? -eq 0 ]; then
            set -e
            return 0
        elif [ $i -eq 10 ]; then
            echo "inti rqlte db error"
            set -e
            return 1
        else
            echo "inti rqlte db error at time $i, retry after 3 second"
            sleep 3
        fi
        set -e
    done
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
    # 初始化一个test表
    if [ "${installTestDB}" == true ]; then
        initDatabase
    else
        ServiceStatus # 检查状态
    fi
}
