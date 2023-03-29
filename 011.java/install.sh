#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
CUR_PATH=$(pwd)
PLUGIN_NAME=jdk
# 引入公共脚本
. ./../pub_script.sh
# 脚步参数定义
fileConf=(default:jdk.tar.gz type:string desc:jdk安装包 required:true)
PARAM_CONFS=(
    ["f"]=fileConf
)
# 参数解析
ParseParams
# 参数获取
tarFile=${PC["f"]}

function remove() {
    rm -rf ${USR_LOCAL}/jdk
    rm -rf /usr/bin/java
    rm -rf /usr/bin/javac
    sed -i '/JAVA_HOME/d' /etc/profile
}

function install() {
    cd "${CUR_PATH}/${TEMP_DIR}" || true
    tDir=$(tar -xzvf "${tarFile}" | head -n 1 | awk -F/ '{print $1}') # 获取解压目录名
    tar -xzvf "${tarFile}"
    mv "${tDir}" "${USR_LOCAL}/jdk"
    # 制作软连接
    ln -s "${USR_LOCAL}"/jdk/bin/java /usr/bin/java
    ln -s "${USR_LOCAL}"/jdk/bin/javac /usr/bin/javac
}

function config() {
    mkdir -p /code/go/src
    # 环境变量配置
    cat >>/etc/profile <<EOF
export JAVA_HOME=${USR_LOCAL}/jdk
export JRE_HOME=\${JAVA_HOME}/jre
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:\$PATH
EOF
    source /etc/profile
}

{
    set -x
    remove
    install
    config
}
