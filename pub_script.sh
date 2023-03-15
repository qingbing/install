#!/bin/bash
# 定义变量保存配置的关联数组
declare -A PARAM_CONFS=()
# 定义变量保存最后的参数值
declare -A PC=()
# 使用变量数组记录脚本命令传递的参数
inputParams=(${@})
# 参数解析函数
function ParseParams() {
    declare -A _keyParams=()
    declare -A _requiredParams=()
    declare -A _typeParams=()
    declare -A _descParams=()
    declare -A _defaultParams=()
    declare -A _exampleParams=()
    declare -A _prefixParams=()
    # 将帮助信息加入参数列表
    helpConf=(default: type:bool desc:使用帮助)
    PARAM_CONFS["h"]=helpConf

    # 将参数内容解析到关联数组中
    for key in ${!PARAM_CONFS[*]}; do
        _keyParams["${key}"]=${key}
        kVar=${PARAM_CONFS[$key]}
        TMP=$kVar[*]
        conf=(${!TMP})
        for cv in ${conf[*]}; do
            _key=${cv%%:*}
            _val=${cv#*:}
            case "${_key}" in
            "required")
                _requiredParams["${key}"]=${_val}
                ;;
            "type")
                _typeParams["${key}"]=${_val}
                ;;
            "desc")
                _descParams["${key}"]=${_val}
                ;;
            "default")
                _defaultParams["${key}"]=${_val}
                ;;
            "eg")
                _exampleParams["${key}"]=${_val}
                ;;
            esac
        done
    done

    # 数据规范
    for key in ${!_keyParams[*]}; do
        # require 规范
        if [ "${_requiredParams["${key}"]}" == "true" ]; then
            _requiredParams["${key}"]=true
        else
            _requiredParams["${key}"]=false
        fi
        # desc 规范
        if [ -z ${_descParams["${key}"]} ]; then _descParams["${key}"]="${key}"; fi
        # example 规范
        if [ -z ${_exampleParams["${key}"]} ]; then _exampleParams["${key}"]=""; fi
        # type 和 default 规范
        case "${_typeParams[${key}]}" in
        "int")
            if [ -z ${_defaultParams["${key}"]} ]; then _defaultParams["${key}"]=0; fi
            ;;
        "bool")
            if [ -z ${_defaultParams["${key}"]} ]; then _defaultParams["${key}"]=false; fi
            ;;
        *) # string
            _typeParams["${key}"]=string
            if [ -z ${_defaultParams["${key}"]} ]; then _defaultParams["${key}"]=""; fi
            ;;
        esac
    done

    # 填充默认值
    for key in ${!_defaultParams[*]}; do
        PC[${key}]=${_defaultParams[${key}]}
        _prefixParams["-${key}"]="${key}"
    done
    # 参数赋值
    i=0
    while [ $i -lt ${#inputParams[@]} ]; do
        arg=${inputParams[i]}
        key="${_prefixParams[${arg}]}"
        if [ -z "${key}" ]; then
            # 未设置的参数，直接丢弃
            let i++
            continue
        fi
        # 类型判断赋值
        case "${_typeParams[${key}]}" in
        "bool")
            PC[${key}]=true
            ;;
        *) # int || string
            let i++
            PC[${key}]=${inputParams[i]}
            ;;
        esac
        let i++
    done

    function helpMessage() {
        printf "\n"
        printf "参数说明: 针对bool类型参数，设置为true，不设置为false，不解析后续参数；\n"
        printf "参数检测: 没有对函数类型做严格检查，只检查了是否必填。\n"
        printf "参数提示:\n"
        for key in ${!_keyParams[*]}; do
            if [ "${_requiredParams[${key}]}" == true ]; then
                mode=required
            else
                mode=optional
            fi
            eg=""
            if [ "${_exampleParams[${key}]}" ]; then
                eg="eg(${_exampleParams[${key}]})"
            fi
            printf "    %s %s %s def=%s %s %s\n" "-${key}" "${mode}" "${_typeParams[${key}]}" "${_defaultParams[${key}]}" "${_descParams[${key}]}" "${eg}"
        done
        printf "\n"
        exit
    }

    # 查看帮助信息
    if [ "${PC[h]}" == true ]; then
        helpMessage
    fi

    # 参数检查
    for key in ${!PC[*]}; do
        if [ "${_requiredParams[${key}]}" -a -z "${PC[${key}]}" ]; then
            printf "\nErrorMsg: %s 是必填参数。\n" "-${key}"
            helpMessage
        fi
    done
}

# ============ 常用变量 ============
LOCAL_IP=$(ip addr | grep -v 127.0.0.1 | grep -v inet6 | grep inet | awk '{print $2}' | awk -F/ '{print $1}' | head -n 1)
SUPPORT_YUM=$(cat /etc/os-release | grep 'CentOS' | wc -l)
SUPPORT_SYSTEMD=$(systemctl --version | grep "systemd" | wc -l)
USER=${USER:-""}
TEMP_DIR=${TEMP_DIR:-"buildTemp"}
BIN_DIR=${BIN_DIR:-"/usr/bin"}
USR_LOCAL=${USR_LOCAL:-"/usr/local"}
PLUGIN_NAME=${PLUGIN_NAME:-""} # 当前插件名称
SYS_CONF_DIR=${SYS_CONF_DIR:-"/lib/systemd/system"}

# ============ 通用函数 ============
# 停止服务
function ServiceStop() {
    systemctl stop ${PLUGIN_NAME}.service || true
}

# 启动服务
function ServiceStart() {
    systemctl restart ${PLUGIN_NAME}.service || true
    sleep 3s
}

# 查看服务
function ServiceStatus() {
    systemctl status ${PLUGIN_NAME}.service || true
}

# 检查服务是否在启动中，并打印输出结果
function checkRunning() {
    count=$(ps -ef | grep "$1" | grep -v grep | wc -l)
    if [ $count -gt 0 ]; then
        echo "Service($1) is running"
    else
        echo "Service($1) is not running"
    fi
}
