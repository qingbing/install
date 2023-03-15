#!/bin/bash
# 确保在脚步当前目录
cd $(dirname $0)
# 引入公共脚本
. ./../pub_script.sh
# 参数解析
ParseParams

function uninstall() {
    rm -rf ${USR_LOCAL}/go
    sed -i '/\/code\/go\/bin:\/usr\/local\/go\/bin/d' /etc/profile
}

{
    set -x
    uninstall
}
