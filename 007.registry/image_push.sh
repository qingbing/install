#!/bin/bash

# push镜像到镜像仓库
function loadPushImage() {
    set -x
    imageFile=$1
    if [ "${imageFile}" == "" ]; then
        echo "必须设置镜像包"
        exit
    fi
    repo=${2:-registry.qiyezhu.net}
    images=$(ctr -n k8s.io i import ${imageFile} | grep "unpacking " | awk '{print $2}')
    for im in ${images}; do
        newIm="${repo}/${im#*/}"
        if [ "${im}" != "${newIm}" ]; then
            ctr -n k8s.io i tag --force "${im}" "${newIm}"
        fi
        ctr -n k8s.io i push -k "${newIm}"
    done
}

loadPushImage $1